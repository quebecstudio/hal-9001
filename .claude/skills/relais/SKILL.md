---
name: relais
description: Rédige le passage de relais dans workflow/handoff.md, pour qu'une autre session reprenne le chantier sans repartir à l'aveugle.
disable-model-invocation: true
allowed-tools: Bash(git status *), Bash(git log *), Bash(git branch *), Bash(git diff --stat *), Bash(date *)
---

## L'état du dépôt

Ce bloc est l'ancre : recopier ces faits en tête du relais.

!`date "+%F %H:%M"`

Branche et fichiers modifiés :

!`git status --short --branch`

Les commits de la session :

!`git log --oneline -12`

L'état courant déclaré, s'il y en a un :

!`cat workflow/etat.local.md 2>/dev/null || echo "(pas de fichier d'état)"`

## Ce qu'il faut faire

Écrire `workflow/handoff.md` en suivant `workflow/core/templates/tpl-handoff.md`.
Lire le gabarit avant d'écrire : c'est lui qui fixe les sections, pas cette
procédure.

**Remplir l'ancre en premier**, avec les faits ci-dessus : heure, branche, HEAD
et son sujet, position vs distant, état de l'arbre. C'est ce que la reprise
compare pour dire si le relais a vieilli — et comme elle supprime le fichier
après lecture, l'ancre est la seule trace qui permettra de le juger.

Le fichier est ignoré par Git. Il ne se commite pas.

## Ce qui fait un bon relais

Le lecteur est une session neuve : elle n'a rien vu de ce qui vient de se
passer, et elle ne peut pas deviner ce qu'on ne lui écrit pas.

- **Nommer les fichiers, ne pas les recopier.** Un chemin et une section
  suffisent. Coller du contenu gonfle le fichier sans rien apprendre.
- **Dire l'état de l'issue en cours**, pas seulement son numéro : ce qui est
  fait, ce qui reste, et où le travail s'est arrêté dans le code.
- **Écrire ce qui a échoué.** Les fausses pistes, les diagnostics démentis, ce
  qui n'a pas pu être vérifié et pourquoi. C'est ce qui a le plus de valeur pour
  le suivant, et la première chose qui disparaît d'un compte rendu qui ne
  raconte que les succès. La section « À ne pas refaire » existe pour ça.
- **Ne pas répéter ce qui est déjà consigné ailleurs.** Le blueprint, les
  commentaires de livraison et la méthode sont lisibles ; le relais y renvoie.

## Avant de rendre la main

Vérifier que ce qui doit durer est déjà ailleurs : une décision sur l'issue, une
règle dans la méthode ou les instructions du projet, une idée dans `workflow/backlog/`. Le relais est un
fichier jetable — ce qu'on n'y confie qu'à lui est perdu à la reprise.

Dire ensuite en une ligne que le relais est écrit, et s'arrêter là.
