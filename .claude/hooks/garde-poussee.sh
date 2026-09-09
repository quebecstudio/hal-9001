#!/usr/bin/env bash
# Refuse à l'agent les deux gestes qu'un `git revert` ne défait pas : pousser et
# fusionner. Le cahier les soumet déjà à autorisation ; ce hook rend la règle
# vraie plutôt que demandée.
#
# Le développeur, lui, n'est pas concerné : il pousse en tapant `! git push`
# dans sa saisie, ce qui n'est pas un appel d'outil et ne passe pas par ici.
#
# Branché par setup.sh sur PreToolUse/Bash. Reçoit l'appel en JSON sur l'entrée
# standard et rend sa décision en JSON sur la sortie.

set -eu

# Pas de jq ni de node garantis sur un poste : on lit la commande au grep. Le
# JSON échappe les guillemets, jamais les espaces — le motif tient donc sur la
# forme de la commande, sans dépendre de la mise en forme du document.
commande=$(tr -d '\n' | sed -n 's/.*"command"[[:space:]]*:[[:space:]]*"\(\([^"\]\|\.\)*\)".*/\1/p')

# `git -C dir push`, `git --no-pager merge` : les options s'intercalent.
if printf '%s' "$commande" | grep -Eq '(^|[;&|]|&&)[[:space:]]*(git([[:space:]]+-[^[:space:]]+([[:space:]]+[^[:space:]-][^[:space:]]*)?)*[[:space:]]+(push|merge)|gh[[:space:]]+pr[[:space:]]+merge)([[:space:]]|$)'; then
  cat <<'JSON'
{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"deny","permissionDecisionReason":"Pousser et fusionner ne se font pas par l'agent : ces gestes ne se défont pas. Annonce ce que tu voulais faire et demande au développeur de lancer la commande lui-même, en la préfixant de « ! » dans sa saisie."}}
JSON
  exit 0
fi

exit 0
