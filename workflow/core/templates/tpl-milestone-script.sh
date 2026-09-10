#!/usr/bin/env bash
# Ouverture du milestone MNNNN — <Titre court>.
# Référence : workflow/blueprints/NNNN-kebab-title.md
#
# Écrit depuis ce gabarit, relu, puis exécuté une seule fois. C'est le seul geste
# du cycle qui crée dans un système externe et qu'aucun revert ne défait.
#
# Écrit pour bash 3.2 : macOS en livre encore un de 2007, et les tableaux
# associatifs n'y existent pas. La correspondance clé → numéro passe donc par
# des lignes, ce qui est moins élégant et n'impose rien à personne.

set -euo pipefail
cd "$(dirname "$0")/.."
. core/scripts/lib/forge.sh

TITRE="MNNNN — <Titre court>"
DESCRIPTION="<Résumé de ce que le milestone livre, lisible sans ouvrir le blueprint.> Réf. blueprint NNNN."
REF=$'\n\nRéf. blueprint NNNN\n'

# Garde d'idempotence : si le jalon existe, on ne crée rien. Le titre s'y compare
# à l'exact — le renommer le rendrait introuvable, et une seconde exécution en
# créerait un doublon.
if existant=$(findMilestoneByTitle "$TITRE"); then
  echo "Le jalon « $TITRE » existe déjà (#$existant). Abandon."
  exit 0
fi

echo "=== Création du jalon ==="
JALON=$(createMilestone "$TITRE" "$DESCRIPTION")
echo "  jalon #$JALON créé"

# Une entrée par ligne du découpage du blueprint, dans l'ordre. La clé sert aux
# dépendances plus bas et à retrouver le corps ; les labels se séparent par des
# virgules, sans espace.
#
#   clé|type|labels|titre
ISSUES=(
  "socle|feature|backend|<Titre de l'issue>"
  "suite|feature|backend|<Titre de l'issue>"
)

# Le corps de chaque tâche, dans `corps_<clé>`. Il vit hors du tableau : `read`
# s'arrête au premier saut de ligne, et un corps qui voyagerait dans la même
# ligne que les métadonnées y serait tronqué sans que rien ne le dise. Un `|`
# dans le texte décalerait en outre les champs.
#
# Heredoc en quotes simples : le corps part tel qu'il est écrit, sans expansion
# ni échappement. C'est `createIssue` qui le fait passer par un fichier.
corps_socle=$(cat <<'CORPS'
<Corps, depuis core/templates/tpl-issue.md>
CORPS
)

corps_suite=$(cat <<'CORPS'
<Corps>
CORPS
)

# Les dépendances, en paires « bloquée bloquante », recopiées de la colonne
# « Bloquée par » du blueprint. Rien d'autre : une dépendance qui manque au
# tableau manque au plan.
DEPENDANCES=(
  "suite socle"
)

# La table des tâches créées, une ligne « clé<TAB>numéro<TAB>identifiant ».
CREEES=""
cherche() { printf '%s\n' "$CREEES" | grep -F "$1	" | cut -f"$2"; }

echo "=== Création des tâches ==="
for entree in "${ISSUES[@]}"; do
  IFS='|' read -r cle type labels titre <<< "$entree"
  # Expansion indirecte plutôt qu'un tableau associatif, qui est de bash 4.
  ref_corps="corps_$cle"
  corps=${!ref_corps:-}
  # Une tâche sans corps est un découpage incomplet, pas une tâche courte.
  [ -n "$corps" ] || { echo "Corps absent pour « $cle » : définissez $ref_corps." >&2; exit 1; }
  IFS=$'\t' read -r numero identifiant < <(createIssue "$JALON" "$titre" "$type" "$labels" "$corps$REF")
  CREEES="$CREEES$cle	$numero	$identifiant"$'\n'
  echo "  #$numero  $titre"
done

echo "=== Câblage des dépendances ==="
for paire in "${DEPENDANCES[@]}"; do
  read -r bloquee bloquante <<< "$paire"
  block "$(cherche "$bloquee" 2)" "$(cherche "$bloquante" 3)"
  echo "  #$(cherche "$bloquee" 2) est bloquée par #$(cherche "$bloquante" 2)"
done

echo
echo "Jalon #$JALON ouvert, ${#ISSUES[@]} tâches créées."
echo "Vérifiez le câblage avant de commencer : listBlockedBy <numéro>"
