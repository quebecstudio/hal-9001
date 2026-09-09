#!/usr/bin/env bash
# La bibliothèque de forge : ce que les scripts de milestone demandent à l'outil
# de suivi, et rien de plus. Le contrat est à l'annexe D du document de
# référence, avec les garanties qu'il exige de toute implémentation.
#
# Celle-ci parle à GitHub, par `gh`. Un projet sur une autre forge réécrit ce
# fichier **sous le même nom et contre le même contrat** : rien d'autre ne bouge,
# ni le gabarit de script, ni le dépôt visé. Le transport ne fait pas partie du
# contrat — une implémentation GitLab peut prendre `glab`, une autre du `curl`.
#
# Ce que celle-ci exige du poste : `gh`, authentifié. Rien d'autre : `-F` type
# les paramètres, `-F champ=@fichier` passe les textes longs, et `--jq` lit les
# réponses avec le jq embarqué dans gh. Aucun secret ne vit ici.
#
# Toute fonction sort en erreur si l'appel échoue : un script de milestone ne
# doit jamais continuer sur un appel raté.

set -euo pipefail

# Le dépôt visé vit hors de core/, dans un fichier que l'amont ne porte pas :
# une mise à jour ne peut donc pas l'écraser. setup.sh le crée ; s'il manque, on
# échoue bruyamment, ce qui vaut mieux qu'un repli silencieux sur une valeur
# fausse qui créerait les tâches d'un chantier dans le vide.
_ici=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
# shellcheck source=/dev/null
. "$_ici/../../../repo.sh"

# ── Jalons ──────────────────────────────────────────────────────────────

listMilestones() {
  gh api "repos/$REPO/milestones?state=all&per_page=100" "$@"
}

# La garde d'idempotence des scripts, et le titre s'y compare à l'exact.
# Renommer un jalon est sans danger pour la forge, fatal ici : le script ne le
# retrouve plus et en recrée un second. C'est pourquoi un chantier abandonné
# garde son titre — l'abandon se dit dans la description.
#
# Chercher par titre impose de lire une liste, faute d'index par nom : c'est la
# seule exception à la garantie « après une écriture, on relit l'objet ».

# Rend le **numéro** du jalon, et sort en 1 s'il n'existe pas — la forme d'un
# retour suit le langage, et en bash un numéro se teste là où un objet demande
# un parseur. La comparaison se fait sur des lignes « titre<TAB>numéro » plutôt
# que dans une expression jq où le titre serait interpolé : un titre porte un
# tiret cadratin et des espaces, et il n'a rien à faire dans du code.
findMilestoneByTitle() {
  local ligne
  ligne=$(listMilestones --jq '.[] | "\(.title)\t\(.number)"' |
            grep -F -m1 "$(printf '%s\t' "$1")") || return 1
  printf '%s' "${ligne##*$'\t'}"
}

# Rend le numéro du jalon créé.
createMilestone() {
  gh api "repos/$REPO/milestones" -X POST \
    -f "title=$1" -f "description=$2" --jq .number
}

# La description sert à fermer en expliquant pourquoi : un chantier abandonné dit
# ce qui a été renoncé, où le problème a migré et où le travail vit. Elle
# s'affiche sous le titre dans la liste des jalons, donc l'abandon se voit sans
# rien ouvrir.
closeMilestone() {
  if [ -n "${2:-}" ]; then
    gh api "repos/$REPO/milestones/$1" -X PATCH -f state=closed -f "description=$2" >/dev/null
  else
    gh api "repos/$REPO/milestones/$1" -X PATCH -f state=closed >/dev/null
  fi
}

# ── Étiquettes ──────────────────────────────────────────────────────────

# --force met à jour l'étiquette si elle existe déjà.
upsertLabel() {
  gh label create "$1" --color "$2" --description "${3:-}" --force >/dev/null
}

# Tolère l'absence : le premier script nettoie les étiquettes par défaut de la
# forge, qui peuvent déjà avoir été retirées.
deleteLabel() {
  gh label delete "$1" --yes >/dev/null 2>&1 || return 0
}

# ── Tâches ──────────────────────────────────────────────────────────────

# Rend « numéro<TAB>identifiant » : les deux servent, le numéro pour l'affichage
# et les commandes, l'identifiant interne pour les dépendances.
#
# Le corps passe par un fichier — `-F champ=@fichier` — et jamais en argument :
# un texte long qui traverse la ligne de commande perd ses accents et ses
# apostrophes, et l'échec est silencieux. Payé quatre fois.
createIssue() {
  local milestone=$1 titre=$2 type=$3 labels=$4 corps=$5
  local fichier; fichier=$(mktemp)
  printf '%s' "$corps" > "$fichier"
  local args=(-f "title=$titre" -F "body=@$fichier" -F "milestone=$milestone" -f "type=$type")
  local IFS=,
  for label in $labels; do [ -n "$label" ] && args+=(-f "labels[]=$label"); done
  unset IFS
  gh api "repos/$REPO/issues" -X POST "${args[@]}" --jq '"\(.number)\t\(.id)"'
  rm -f "$fichier"
}

commentIssue() {
  local fichier; fichier=$(mktemp)
  printf '%s' "$2" > "$fichier"
  gh api "repos/$REPO/issues/$1/comments" -X POST -F "body=@$fichier" >/dev/null
  rm -f "$fichier"
}

# La raison décide de ce que la forge affiche : « completed » met la pastille du
# travail livré, « not_planned » celle de ce qui ne se fera pas. Sans elle, une
# tâche jamais faite devient indistinguable d'une tâche livrée.
closeIssue() {
  gh api "repos/$REPO/issues/$1" -X PATCH \
    -f state=closed -f "state_reason=${2:-completed}" >/dev/null
}

# ── Dépendances ─────────────────────────────────────────────────────────

# Deux pièges, tous deux silencieux si on les rate :
# - `issue_id` est l'identifiant interne de la tâche bloquante (dix chiffres),
#   pas le numéro affiché dans l'URL ;
# - il doit partir comme un entier. Passé en chaîne, l'API répond
#   422 « Invalid property /issue_id ». `-F` type le paramètre là où `-f` en
#   ferait une chaîne : c'est toute la différence, et elle tient à une lettre.
block() {
  gh api "repos/$REPO/issues/$1/dependencies/blocked_by" -X POST -F "issue_id=$2" >/dev/null
}

# Comme listMilestones, elle passe ses options à gh : « listBlockedBy 13 --jq
# .[].number » évite de rendre une réponse entière quand on ne veut qu un champ.
listBlockedBy() {
  local numero=$1; shift
  gh api "repos/$REPO/issues/$numero/dependencies/blocked_by" "$@"
}
