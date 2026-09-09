#!/usr/bin/env bash
# Ligne de statut : où on en est dans le cycle.
#
# Reçoit sur stdin le JSON de l'agent, rend une ligne sur stdout, et sort
# toujours en 0 — hors dépôt, sans git, sans fichier d'état, avec une entrée
# incomplète. Une ligne de statut qui plante gêne à chaque frappe.
#
# Aucune dépendance externe : pas de jq. Son absence ne se voit pas, elle fait
# simplement disparaître un champ sans erreur.

set -u

ENTREE=$(cat 2>/dev/null || true)

JAUNE=$'\033[33m'
ROUGE=$'\033[31m'
GRIS=$'\033[2m'
FIN=$'\033[0m'

# L'entrée est un JSON plat produit par l'agent, jamais une donnée d'origine
# inconnue : l'extraction au sed est acceptable ici et nulle part ailleurs.
champ() {
  printf '%s' "$ENTREE" | tr -d '\n' \
    | sed -n "s/.*\"$1\"[[:space:]]*:[[:space:]]*\"\([^\"]*\)\".*/\1/p" | head -n1
}

RACINE=$(champ project_dir)
[ -n "$RACINE" ] || RACINE=$(champ cwd)
[ -n "$RACINE" ] || RACINE=$PWD
MODELE=$(champ display_name)

# Le remplissage du contexte, pré-calculé par l'agent. `used_percentage`
# existe aussi sous `rate_limits` : on isole le segment qui suit
# `context_window`, coupé avant `rate_limits` si celui-ci vient après, ce qui
# reste juste quel que soit l'ordre des deux objets.
SEG=$(printf '%s' "$ENTREE" | tr -d '\n')
SEG=${SEG#*\"context_window\"}
case $SEG in *'"rate_limits"'*) SEG=${SEG%%\"rate_limits\"*} ;; esac
# Vide quand le champ vaut null : avant le premier appel de la session, et
# après un /compact jusqu'au suivant. C'est un état normal, pas une panne.
CONTEXTE=$(printf '%s' "$SEG" \
  | sed -n 's/.*"used_percentage"[[:space:]]*:[[:space:]]*\([0-9][0-9.]*\).*/\1/p' \
  | cut -d. -f1)

# Le vocabulaire de l'état, et la seule source qui l'énonce : setup.sh le lit
# ici pour écrire l'en-tête de etat.local.md, et la documentation y renvoie.
#
# Un mot entre s'il désigne un état durable du poste. Un geste n'en est pas un —
# « Relais » achève la session, plus personne ne regarde la ligne — ni une
# suspension de quelques heures : « Bug » obligerait à réécrire le fichier deux
# fois par incident, et un fichier qu'on tient trop souvent finit par mentir.
ETAPES="Repos Cadrage Blueprint Chantier Branche Issues Courte Dettes Révision Fusion Abandon"

# Celles où n'avoir ni chantier ni issue est l'état normal, et où l'alerte
# « hors chantier » se tait donc. « Courte » en fait partie par définition :
# c'est la voie sans blueprint ni milestone.
SANS_CHANTIER="Repos Cadrage Blueprint Courte"

# --- L'état déclaré ----------------------------------------------------------
# Première ligne utile de workflow/etat.local.md. Le script y cherche trois
# choses dans n'importe quel ordre ; le reste de la ligne est ignoré.
LIGNE=""
if [ -r "$RACINE/workflow/etat.local.md" ]; then
  LIGNE=$(grep -v -e '^[[:space:]]*$' -e '^[[:space:]]*#' \
            "$RACINE/workflow/etat.local.md" 2>/dev/null | head -n1)
fi

etape=""
for e in $ETAPES; do
  case " $LIGNE " in
    *" $e "*|*" $e"|"$e "*|"$e") etape=$e; break ;;
  esac
done

chantier=$(printf '%s' "$LIGNE" | sed -n 's/.*\(^\|[[:space:]]\)[Mm]\([0-9]\{1,4\}\).*/\2/p')
issue=$(printf '%s' "$LIGNE" | sed -n 's/.*#\([0-9]\{1,6\}\).*/\1/p')

# Au Blueprint, faute de chantier ouvert, le numéro du plan tient lieu de repère.
plan=""
if [ "$etape" = "Blueprint" ] && [ -z "$chantier" ]; then
  plan=$(printf '%s' "$LIGNE" | sed -n 's/.*\(^\|[[:space:]]\)\([0-9]\{4\}\)\([[:space:]]\|$\).*/\2/p')
fi

# --- La branche --------------------------------------------------------------
branche=""
if command -v git >/dev/null 2>&1; then
  # `--show-current` nomme la branche même sans commit, là où `rev-parse`
  # répondrait « HEAD ». Le repli sert aux git antérieurs à 2.22.
  branche=$(git -C "$RACINE" branch --show-current 2>/dev/null || true)
  if [ -z "$branche" ] && git -C "$RACINE" rev-parse --git-dir >/dev/null 2>&1; then
    branche=$(git -C "$RACINE" rev-parse --abbrev-ref HEAD 2>/dev/null || true)
  fi
fi

# --- Ce que Git sait déjà -----------------------------------------------------
# Le fichier d'état a menti une session entière, parce qu'il est tenu à la main.
# Deux des trois choses qu'il porte se déduisent, et ce qui se déduit ne ment
# pas : la branche `dev/<slug>` nomme le blueprint, dont le numéro est celui du
# jalon ; le sujet du dernier commit porte le numéro d'issue.
#
# Ce qui est écrit dans le fichier reste prioritaire — Git ne sait pas tout, et
# une correction à la main doit pouvoir gagner.
if [ -z "$chantier" ] && [ -n "$branche" ]; then
  case "$branche" in
    dev/*)
      slug=${branche#dev/}
      # Un seul blueprint porte ce slug ; s'il y en a deux, on n'invente pas.
      trouves=$(ls "$RACINE"/workflow/blueprints/[0-9][0-9][0-9][0-9]-"$slug".md 2>/dev/null | wc -l)
      if [ "$trouves" -eq 1 ]; then
        fichier=$(ls "$RACINE"/workflow/blueprints/[0-9][0-9][0-9][0-9]-"$slug".md 2>/dev/null)
        base=${fichier##*/}
        chantier=${base%%-*}
      fi
      ;;
  esac
fi

if [ -z "$issue" ] && command -v git >/dev/null 2>&1; then
  # « MNNNN #13: … » ou « #13: … ». Le sujet seul : un corps de message peut
  # citer d'autres numéros, et ce serait alors le mauvais qui s'afficherait.
  sujet=$(git -C "$RACINE" log -1 --format=%s 2>/dev/null || true)
  issue=$(printf '%s' "$sujet" | sed -n 's/^\([Mm][0-9]\{1,4\}[[:space:]]\+\)\?#\([0-9]\{1,6\}\).*/\2/p')
fi

# --- Composition -------------------------------------------------------------
morceaux=""
ajouter() { morceaux="${morceaux:+$morceaux$GRIS · $FIN}$1"; }

if [ -n "$etape" ]; then
  ajouter "$etape"
else
  ajouter "${JAUNE}étape inconnue${FIN}"
fi

if [ -n "$chantier" ]; then
  # Le milestone porte les quatre chiffres du blueprint : M02 se lit M0002.
  ajouter "$(printf 'M%04d' "$((10#$chantier))")"
elif [ -n "$plan" ]; then
  ajouter "$plan"
fi

[ -n "$issue" ] && ajouter "#$issue"

# Une alerte ne crie que sur une anomalie : aux étapes sans chantier, n'avoir
# ni milestone ni issue est l'état normal.
normal=""
for e in $SANS_CHANTIER; do
  [ "$etape" = "$e" ] && normal=1 && break
done
if [ -z "$chantier" ] && [ -z "$issue" ] && [ -z "$plan" ] && [ -z "$normal" ]; then
  ajouter "${JAUNE}hors chantier${FIN}"
fi

if [ -z "$branche" ]; then
  ajouter "${JAUNE}hors dépôt${FIN}"
elif [ "$branche" = "main" ] || [ "$branche" = "master" ]; then
  ajouter "${JAUNE}${branche}${FIN}"
else
  ajouter "$branche"
fi

# Les paliers suivent la règle du relais : l'alerte doit arriver assez tôt pour
# qu'une tâche en cours puisse encore se terminer, puisque c'est là qu'un relais
# se pose. En dessous de 75 %, elle crierait sur un état normal.
if [ -n "$CONTEXTE" ]; then
  if [ "$CONTEXTE" -ge 90 ]; then
    ajouter "${ROUGE}${CONTEXTE}%${FIN}"
  elif [ "$CONTEXTE" -ge 75 ]; then
    ajouter "${JAUNE}${CONTEXTE}%${FIN}"
  elif [ "$CONTEXTE" -ge 50 ]; then
    ajouter "${CONTEXTE}%"
  else
    ajouter "$GRIS${CONTEXTE}%$FIN"
  fi
fi

[ -n "$MODELE" ] && ajouter "$GRIS$MODELE$FIN"

printf '%s\n' "$morceaux"
exit 0
