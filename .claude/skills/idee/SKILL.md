---
name: idee
description: Dépose une idée dans le backlog et revient au travail en cours. C'est le mot-clé « Idée : » de la méthode.
disable-model-invocation: true
allowed-tools: Bash(git add workflow/backlog/*), Bash(git commit *), Bash(git status *)
argument-hint: [l'idée]
---

## L'idée

$ARGUMENTS

## Ce que le backlog contient déjà

!`ls workflow/backlog/ workflow/backlog/delivered/ workflow/backlog/abandoned/ 2>/dev/null`

## Où on en était

!`cat workflow/etat.local.md 2>/dev/null || echo "(pas de fichier d'état)"`

## Ce qu'il faut faire

**D'abord, chercher le doublon.** Le backlog est relu à chaque nouveau cadrage :
une même idée déposée deux fois sous deux noms y survit longtemps. Si une entrée
existante couvre le sujet, ne crée rien — dis laquelle, et propose de l'enrichir.

Sinon, écrire l'entrée en suivant `workflow/core/templates/tpl-backlog.md`. Lis le
gabarit : c'est lui qui fixe les champs, pas cette procédure. Le nom du fichier
est en kebab-case, sans numéro.

Le champ `origin` prend le chantier et l'issue en cours, lus dans l'état
ci-dessus — c'est ce qui permettra plus tard de savoir d'où l'idée venait.

Puis commiter, seul, avec un sujet de la forme `Backlog : <ce que l'entrée
propose>`.

## Puis reprendre

C'est l'étape qu'on escamote, et c'est la raison d'être du mot-clé : l'idée se
dépose **sans quitter** le travail en cours. Reviens à ce que l'état ci-dessus
indique, en une phrase qui dit où tu reprends.
