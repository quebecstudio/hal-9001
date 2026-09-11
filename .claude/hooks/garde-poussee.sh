#!/usr/bin/env bash
# Refuse à l'agent les gestes qu'un `git revert` ne défait pas : fusionner, et
# pousser ailleurs que sur sa propre branche de chantier. Le cahier les soumet
# déjà à autorisation ; ce hook rend la règle vraie plutôt que demandée.
#
# Une branche `dev/<slug>` fait exception : c'est un brouillon que la révision
# relit et que la fusion absorbe. La pousser se défait — il suffit de supprimer
# la branche du distant —, alors qu'un tronc poussé est tiré et construit
# dessus dans l'heure.
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

# La poussée d'une branche de chantier, et elle seule. Le motif décrit la
# commande **entière** — pas un fragment — pour trois raisons, toutes déjà vues
# ailleurs :
#
# - `git push origin dev/x:main` pousse une branche de chantier **vers le
#   tronc** ; un motif qui cherche « dev/ » quelque part le laisserait passer ;
# - `--force`, `--all`, `--mirror` n'apparaissent pas : ce qu'ils écrasent au
#   distant ne se retrouve nulle part en local ;
# - un enchaînement `git push origin dev/x && git push origin main` se lit comme
#   une seule commande, d'où l'ancrage aux deux bouts.
#
# Le nom de branche s'arrête donc avant tout « : », et la ligne se termine là.
if printf '%s' "$commande" | grep -Eq '^[[:space:]]*git[[:space:]]+push([[:space:]]+(-u|--set-upstream))?[[:space:]]+[A-Za-z0-9._-]+[[:space:]]+dev/[A-Za-z0-9._/-]+[[:space:]]*$'; then
  exit 0
fi

# `git -C dir push`, `git --no-pager merge` : les options s'intercalent.
if printf '%s' "$commande" | grep -Eq '(^|[;&|]|&&)[[:space:]]*(git([[:space:]]+-[^[:space:]]+([[:space:]]+[^[:space:]-][^[:space:]]*)?)*[[:space:]]+(push|merge)|gh[[:space:]]+pr[[:space:]]+merge)([[:space:]]|$)'; then
  cat <<'JSON'
{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"deny","permissionDecisionReason":"Fusionner, et pousser ailleurs que sur une branche de chantier, ne se font pas par l'agent : ces gestes ne se défont pas. Seul « git push <distant> dev/<slug> » passe, éventuellement avec -u, sans refspec ni --force. Pour le reste, annonce ce que tu voulais faire et demande au développeur de lancer la commande lui-même, en la préfixant de « ! » dans sa saisie."}}
JSON
  exit 0
fi

exit 0
