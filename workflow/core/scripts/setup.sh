#!/usr/bin/env bash
# Pose HAL 9001 sur ce dépôt : tout ce qui est mécanique, et rien d'autre.
#
#   bash workflow/core/scripts/setup.sh          installe ce qui manque
#   bash workflow/core/scripts/setup.sh --update    montre l'écart avec l'amont
#   bash workflow/core/scripts/setup.sh --update --apply   aligne ce qui est en retard
#
# À lancer par le développeur : écrire dans les réglages de l'agent demande une
# autorisation que l'agent ne peut pas se donner lui-même.
#
# Idempotent : relancé, il ne touche à rien de ce qui est déjà en place. Ce
# qu'il ne sait pas faire — lire le dépôt, remplir les sections en blanc — il le
# signale à la fin, et c'est le travail que `install.md` confie à un agent.

set -eu

if RACINE=$(git rev-parse --show-toplevel 2>/dev/null) && [ -n "$RACINE" ]; then
  :
else
  RACINE=$(cd "$(dirname "$0")/../.." && pwd)
fi
cd "$RACINE"

REMOTE=hal
fait=0
signale_apres=
note() { printf '  %s\n' "$1"; }
pose() { printf '  + %s\n' "$1"; fait=$((fait + 1)); }

# --- Mise à jour du kit d'amont ----------------------------------------------
# Ce qui vient de HAL 9001 vit dans un seul dossier, et rien d'autre n'y vit :
# le reste de workflow/ appartient au projet. Un dossier plutôt qu'une liste de
# chemins — un fichier ajouté en amont arrive sans qu'on touche à ce script.
KIT=".claude/skills .claude/hooks workflow/core"

# Tout le corps est dans une fonction : bash la lit en entier avant de
# l'exécuter, ce qui la protège de la mise à jour de ce fichier-ci, qui vit
# dans workflow/core et se met donc à jour lui-même.
maj() {
  appliquer=${1:-}

  git remote get-url "$REMOTE" >/dev/null 2>&1 || {
    echo "Pas de remote « $REMOTE ». Ajoutez-le d'abord :"
    echo "  git remote add $REMOTE <url du fork de HAL 9001>"
    return 1
  }
  git fetch --quiet "$REMOTE"
  git rev-parse --verify --quiet "$REMOTE/main" >/dev/null || {
    echo "« $REMOTE » n'a pas de branche main."
    return 1
  }

  amont=$(git ls-tree -r --name-only "$REMOTE/main" -- $KIT | sort)
  # `--others` autant que le suivi : un fichier tout juste pris par un
  # `git checkout` n'est pas encore dans l'index, et `ls-files` seul le
  # redonnerait « absent ici » à chaque relance, jusqu'au commit.
  ici=$(git ls-files --cached --others --exclude-standard -- $KIT | sort)

  # Sans cette garde, un amont vide ferait déclarer tout le kit orphelin, et le
  # script inviterait à le supprimer. Le pipeline se terminant par `sort`,
  # `set -e` ne rattrape pas l'échec de `ls-tree`.
  [ -n "$amont" ] || {
    echo "Aucun fichier de kit trouvé sur $REMOTE/main. Rien n'est touché."
    return 1
  }

  # Un fichier qui diffère de l'amont est soit en retard, soit adapté par le
  # projet. Rien ne le dit — on le cherche : si le contenu local a existé tel
  # quel en amont, c'est un retard ; sinon quelqu'un l'a modifié ici.
  # `git ls-tree` plutôt que la syntaxe `révision:chemin` : sous Git Bash,
  # MSYS prend `hal/main:.claude/...` pour une liste de chemins séparés par
  # deux-points et la réécrit, ce qui fausse la comparaison sans prévenir.
  blob() { git ls-tree -r "$1" -- "$2" | awk '{print $3}'; }

  retard=""
  modifies=""
  for f in $amont; do
    [ -f "$f" ] || continue
    local_hash=$(git hash-object "$f")
    [ "$local_hash" = "$(blob "$REMOTE/main" "$f")" ] && continue
    vu=""
    for c in $(git rev-list "$REMOTE/main" -- "$f"); do
      [ "$(blob "$c" "$f")" = "$local_hash" ] && { vu=1; break; }
    done
    if [ -n "$vu" ]; then retard="$retard $f"; else modifies="$modifies $f"; fi
  done

  if [ -n "$retard" ]; then
    echo "=== En retard sur l'amont ==="
    for f in $retard; do echo "  $f"; done
  fi

  if [ -n "$modifies" ]; then
    echo
    echo "=== Modifiés ici, et jamais alignés ==="
    echo "Leur contenu n'a existé sous cette forme dans aucune version d'amont."
    for f in $modifies; do echo "  ! $f"; done
    echo "      git diff $REMOTE/main -- <fichier>   pour voir quoi"
  fi

  nouveaux=$(comm -23 <(printf '%s\n' "$amont") <(printf '%s\n' "$ici"))
  if [ -n "$nouveaux" ]; then
    echo
    echo "=== Nouveaux en amont, absents ici ==="
    echo "À prendre si vous les voulez ; laissés en place sinon, car une absence"
    echo "peut être une décision — la bibliothèque de l'autre langage, par exemple."
    printf '%s\n' "$nouveaux" | sed "s#^#      git checkout $REMOTE/main -- #"
  fi

  orphelins=$(comm -13 <(printf '%s\n' "$amont") <(printf '%s\n' "$ici"))
  if [ -n "$orphelins" ]; then
    echo
    echo "=== Absents de l'amont, présents ici ==="
    echo "Les scripts de milestone du projet vivent là. Rien n'y touche."
    printf '%s\n' "$orphelins" | sed 's/^/  · /'
  fi

  echo
  if [ -z "$retard" ] && [ -z "$modifies" ]; then
    echo "Le kit est aligné sur l'amont."
    return 0
  fi

  # Montrer d'abord, aligner ensuite : le défaut ne touche à rien.
  if [ "$appliquer" != "--apply" ]; then
    echo "Rien n'a été modifié. Pour aligner ce qui est en retard :"
    echo "  bash workflow/core/scripts/setup.sh --update --apply"
    [ -n "$modifies" ] && echo "Les fichiers modifiés ici ne seront pas touchés, même alors."
    return 0
  fi

  n=0
  for f in $retard; do
    git checkout "$REMOTE/main" -- "$f"
    git reset --quiet -- "$f"
    n=$((n + 1))
  done
  echo "$n fichier(s) alignés. Les modifiés ici n'ont pas été touchés."
  echo "Relisez avant de commiter :  git diff -- $KIT"

  # setup.sh a pu changer sous nos pieds ; la version qui tourne est l'ancienne.
  if ! git diff --quiet -- workflow/core/scripts/setup.sh; then
    echo
    echo "  ! setup.sh a été mis à jour. Relancez-le pour utiliser la nouvelle"
    echo "    version : celle qui vient de tourner était encore l'ancienne."
  fi
}

if [ "${1:-}" = "--update" ]; then
  maj "${2:-}"
  exit $?
fi

echo "=== Structure ==="
for d in blueprints backlog backlog/delivered backlog/abandoned \
         debts debts/settled notes milestones; do
  if [ -d "workflow/$d" ]; then
    note "workflow/$d"
  else
    mkdir -p "workflow/$d"
    # Git ne versionne pas un dossier vide : sans .gitkeep, la structure
    # disparaît au premier clone.
    : > "workflow/$d/.gitkeep"
    pose "workflow/$d"
  fi
done

echo
echo "=== Ce que Git doit ignorer ==="
for motif in workflow/instructions.local.md workflow/handoff.md 'workflow/*.local.md'; do
  if [ -f .gitignore ] && grep -qxF "$motif" .gitignore; then
    note "$motif"
  else
    [ -f .gitignore ] && [ -n "$(tail -c1 .gitignore)" ] && printf '\n' >> .gitignore
    printf '%s\n' "$motif" >> .gitignore
    pose "$motif"
  fi
done

if [ -f .gitattributes ] && grep -q '\*\.sh' .gitattributes; then
  note ".gitattributes"
else
  # Git Bash refuse un script en CRLF, avec une erreur sur le retour chariot.
  printf '*.sh text eol=lf\n' >> .gitattributes
  pose ".gitattributes — les scripts restent en LF"
fi

echo
echo "=== La ligne de statut ==="
STATUT=workflow/core/scripts/statusline.sh
if [ ! -f "$STATUT" ]; then
  note "absent : $STATUT — la ligne de statut est sautée"
else
  chmod +x "$STATUT" workflow/core/scripts/setup.sh 2>/dev/null || true

  CLE='  "statusLine": {
    "type": "command",
    "command": "bash \"$CLAUDE_PROJECT_DIR/workflow/core/scripts/statusline.sh\""
  }'
  REGLAGES=.claude/settings.json
  if [ ! -f "$REGLAGES" ]; then
    mkdir -p .claude
    printf '{\n%s\n}\n' "$CLE" > "$REGLAGES"
    pose "$REGLAGES"
  elif grep -q '"statusLine"' "$REGLAGES"; then
    # Une clé déjà là n'est pas une clé qui marche : après une migration, elle
    # peut pointer un script renommé. La ligne est alors muette, et rien ne le
    # dit — l'installation est le seul moment où quelqu'un regarde.
    vise=$(sed -n 's/.*CLAUDE_PROJECT_DIR\/\([^"\\]*\).*/\1/p' "$REGLAGES" | head -n1)
    if [ -n "$vise" ] && [ ! -f "$vise" ]; then
      note "$REGLAGES — la clé pointe $vise, qui n'existe pas"
      signale_apres="$REGLAGES — statusLine pointe un script absent : $vise"
    else
      note "$REGLAGES"
    fi
  elif [ "$(sed -n '/[^[:space:]]/{p;q;}' "$REGLAGES" | tr -d '[:space:]')" = "{" ]; then
    cp "$REGLAGES" "$REGLAGES.bak"
    # La clé passe par l'environnement : `awk -v` interpréterait les séquences
    # d'échappement et mangerait les \" du JSON.
    CLE="$CLE" awk 'NR==1 && /^[[:space:]]*\{/ {print; print ENVIRON["CLE"] ","; next} {print}' \
      "$REGLAGES.bak" > "$REGLAGES"
    pose "$REGLAGES complété (copie : $REGLAGES.bak)"
  else
    note "à ajouter à la main dans $REGLAGES :"
    printf '%s\n' "$CLE"
  fi

  if [ -f workflow/etat.local.md ]; then
    note "workflow/etat.local.md"
  else
    # Les mots sont lus dans le script, seule source qui les énonce : sans eux
    # sous les yeux, celui qui tient le fichier en invente de bonne foi, et la
    # ligne affiche « étape inconnue » sur un état pourtant juste.
    mots=$(sed -n 's/^ETAPES="\(.*\)"$/\1/p' "$STATUT")
    {
      printf '# Où on en est : l'"'"'étape, et elle seule. Le reste se déduit de Git.\n'
      printf '# Étapes : %s\n' "${mots:-voir ETAPES dans $STATUT}"
      printf '# Le reste de la ligne est ignoré. Ce fichier ne se commite pas.\n'
      printf 'Repos\n'
    } > workflow/etat.local.md
    pose "workflow/etat.local.md"
  fi
fi

echo
echo "=== La garde des gestes irréversibles ==="
GARDE=.claude/hooks/garde-poussee.sh
if [ ! -f "$GARDE" ]; then
  note "absent : $GARDE — la garde est sautée"
else
  chmod +x "$GARDE" 2>/dev/null || true
  HOOK='  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          { "type": "command", "command": "bash \"$CLAUDE_PROJECT_DIR/.claude/hooks/garde-poussee.sh\"" }
        ]
      }
    ]
  }'
  REGLAGES=.claude/settings.json
  if [ ! -f "$REGLAGES" ]; then
    mkdir -p .claude
    printf '{\n%s\n}\n' "$HOOK" > "$REGLAGES"
    pose "$REGLAGES — la garde"
  elif grep -q '"hooks"' "$REGLAGES"; then
    note "$REGLAGES — une clé hooks est déjà là"
  elif [ "$(sed -n '/[^[:space:]]/{p;q;}' "$REGLAGES" | tr -d '[:space:]')" = "{" ]; then
    cp "$REGLAGES" "$REGLAGES.bak"
    HOOK="$HOOK" awk 'NR==1 && /^[[:space:]]*\{/ {print; print ENVIRON["HOOK"] ","; next} {print}' \
      "$REGLAGES.bak" > "$REGLAGES"
    pose "$REGLAGES complété (copie : $REGLAGES.bak)"
  else
    note "à ajouter à la main dans $REGLAGES :"
    printf '%s\n' "$HOOK"
  fi
fi

echo
echo "=== Ce que la méthode attend du poste ==="
# Ni installés ni proposés à l'installation : ce sont des outils de poste, au
# même titre qu'une forge authentifiée. On dit ce qui manque, et on continue —
# le kit se pose très bien sur un poste incomplet, il ne s'exécutera pas.
#
# `gh` n'est exigé que par la bibliothèque livrée, qui vise GitHub. Une
# implémentation pour une autre forge déclare ses propres besoins.
for outil in git bash gh; do
  if command -v "$outil" >/dev/null 2>&1; then
    note "$outil"
  else
    signale "$outil — absent : les scripts de milestone ne pourront pas tourner"
  fi
done
# macOS livre encore bash 3.2 : les tableaux associatifs sont de bash 4, et le
# gabarit s'en passe pour cette raison. On le dit plutôt que de l'exiger.
[ "${BASH_VERSINFO:-0}" -lt 4 ] &&
  note "bash ${BASH_VERSION%%(*} — écrire les scripts sans tableaux associatifs"

echo
echo "=== Le dépôt visé ==="
# Hors du kit, et hors du dossier core/ qui le porte : ce fichier appartient au
# projet, et sa place le dit. --update ne touche que ce qui est sous core/. La valeur se déduit du remote
# origin, mais elle se fait confirmer — un remote peut pointer un fork quand les
# issues vivent en amont.
depot=$(git remote get-url origin 2>/dev/null | sed -e 's#.*[:/]\([^/]*/[^/]*\)$#\1#' -e 's#\.git$##' || true)
cible=workflow/repo.sh
if [ ! -f workflow/core/scripts/lib/forge.sh ]; then
  note "absent : la bibliothèque de forge — le dépôt visé est sauté"
elif [ -f "$cible" ]; then
  note "$cible"
elif [ -z "$depot" ]; then
  note "$cible — pas de remote origin, à écrire à la main"
else
  printf '# Le dépôt que les scripts de milestone visent. Hors de core/ : une mise à\n# jour ne l'"'"'écrase pas.\nREPO="%s"\n' "$depot" > "$cible"
  pose "$cible — $depot, à confirmer"
fi

echo
echo "=== Les procédures ==="
if [ -d .claude/skills ] && [ -n "$(ls .claude/skills 2>/dev/null)" ]; then
  ls .claude/skills | sed 's/^/  \//'
else
  note "aucune — elles arrivent avec le dossier .claude/, pas avec ce script"
fi

# --- Ce que ce script ne sait pas faire --------------------------------------
echo
echo "=== Ce qui reste, et qui demande de lire le dépôt ==="
reste=0
signale() { printf '  → %s\n' "$1"; reste=$((reste + 1)); }

# Le contrat de la Pile : la pile est libre, sa déclaration ne l'est pas. Les
# règles s'appuient dessus pour savoir quoi lancer, donc une clé absente est un
# trou, pas un choix. Une clé encore entre chevrons compte comme absente — le
# gabarit les livre toutes, et seule leur valeur dit si quelqu'un a lu le dépôt.
# `grep -F` plutôt qu'un motif : les clés sont en gras Markdown, et les
# astérisques d'une expression régulière se sont déjà perdus une fois ici.
PILE=workflow/instructions.md
if [ -f "$PILE" ]; then
  manquantes=""
  for cle in Langage Paquets Formateur CI; do
    ligne=$(grep -m1 -F "**$cle**" "$PILE" || true)
    case "$ligne" in
      "" | *"<"*) manquantes="$manquantes $cle" ;;
    esac
  done
  [ -n "$manquantes" ] && signale "$PILE — la Pile ne déclare pas :$manquantes"

  surface=$(grep -m1 -F "**Surface " "$PILE" || true)
  case "$surface" in
    "" | *"<nom>"*) signale "$PILE — la Pile ne déclare aucune surface de test" ;;
  esac

  # La CI se déduit de sa configuration, jamais d'une préférence. Son absence
  # n'est pas un défaut : beaucoup de projets vivent sans, et longtemps. On la
  # nomme pour que la Pile puisse répondre, et on ne la réclame pas.
  ci=""
  [ -d .github/workflows ] && [ -n "$(ls .github/workflows 2>/dev/null)" ] && ci="GitHub Actions"
  [ -f .gitlab-ci.yml ] && ci="${ci:+$ci, }GitLab CI"
  [ -f Jenkinsfile ] && ci="${ci:+$ci, }Jenkins"
  [ -d .circleci ] && ci="${ci:+$ci, }CircleCI"
  [ -f azure-pipelines.yml ] && ci="${ci:+$ci, }Azure Pipelines"
  [ -f bitbucket-pipelines.yml ] && ci="${ci:+$ci, }Bitbucket Pipelines"
  [ -f .drone.yml ] && ci="${ci:+$ci, }Drone"
  if [ -n "$ci" ]; then
    note "intégration continue vue : $ci"
  else
    note "aucune intégration continue vue — « aucune » est une réponse, à écrire dans la Pile"
  fi

  # Les frameworks de test se déduisent des fichiers de dépendances. On ne
  # remplit rien — la commande exacte demande de lire les scripts du projet —
  # mais on nomme ce qu'on a vu, et surtout ce qu'on n'a pas vu : un dépôt sans
  # framework est un dépôt où « tests ciblés » ne veut rien dire.
  vus=""
  for outil in vitest jest jasmine mocha playwright cypress; do
    [ -f package.json ] && grep -qF "\"$outil" package.json && vus="$vus $outil"
  done
  for outil in pest phpunit; do
    [ -f composer.json ] && grep -qF "/$outil" composer.json && vus="$vus $outil"
  done
  if [ -n "$vus" ]; then
    note "frameworks de test vus dans les dépendances :$vus"
  elif [ -f package.json ] || [ -f composer.json ]; then
    signale "aucun framework de test dans les dépendances — les blueprints listent"
    note "    les comportements à prouver, et les tests attendent dans debts/"
  fi
fi

for f in workflow/instructions.md workflow/README.md; do
  # Le chapeau de ces fichiers commence lui aussi par `<` : on ne compte qu'à
  # partir du premier titre, sinon le bilan ne s'éteint jamais et cesse d'être
  # lu. Le `|| true` reste nécessaire — sur un fichier absent, awk sort en 2 et
  # `set -e` emporterait le script.
  n=$(awk '/^## /{apres=1} apres && /^</{c++} END{print c+0}' "$f" 2>/dev/null || true)
  [ "${n:-0}" -gt 0 ] && signale "$f — $n section(s) en blanc"
done

if [ -f workflow/core/scripts/lib/forge.sh ]; then
  # La constante ne vit pas dans la bibliothèque : on vérifie son fichier, et
  # qu'il ne porte pas la valeur d'exemple.
  if [ ! -f workflow/repo.sh ]; then
    signale "workflow/repo.sh — absent : les scripts de milestone ne sauront pas où écrire"
  elif grep -q '<owner>/<repo>' workflow/repo.sh 2>/dev/null; then
    signale "workflow/repo.sh — le dépôt visé est encore la valeur d'exemple"
  fi
fi
for f in CLAUDE.md AGENTS.md; do
  if [ ! -f "$f" ]; then
    signale "$f — absent, doit renvoyer à la méthode et aux instructions"
  elif ! grep -q 'workflow/core/methode.md' "$f" || ! grep -q 'workflow/instructions.md' "$f"; then
    signale "$f — ne renvoie pas à la méthode et aux instructions"
  fi
done

[ -n "$signale_apres" ] && signale "$signale_apres"

[ "$reste" -eq 0 ] && note "rien — le dépôt est complet"

echo
if [ "$fait" -eq 0 ]; then
  echo "Rien à poser, tout était en place."
else
  echo "$fait élément(s) posé(s). Relisez avant de commiter : git status"
fi
if [ "$reste" -gt 0 ]; then
  echo "Pour le reste, donnez install.md à un agent dans ce dépôt."
fi
if [ -f "$STATUT" ]; then
  echo
  echo "Aperçu de la ligne de statut :"
  printf '{"workspace":{"project_dir":"%s"},"model":{"display_name":"Opus 5"}}' "$RACINE" \
    | bash "$STATUT"
  echo "Elle apparaît au prochain démarrage de l'agent."
fi
