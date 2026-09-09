# HAL 9001 — la méthode

*Rocket science starter kit.*

Coder à l'intuition en laissant l'agent écrire n'oblige pas à travailler comme
un débutant. Un cadrage avant le plan, un plan avant le code, un chantier par
plan, des tâches créées par un script versionné, une révision avant chaque
fusion.

Ce document décrit la méthode telle qu'elle est appliquée, indépendamment du
langage. Elle est décrite avec **Claude Code, Git et GitHub** : la forge est
remplaçable, l'agent est une dépendance assumée.

C'est une méthode à partis pris. Elle tranche là où d'autres laissent choisir.
S'en écarter en défait l'intérêt. Ce qui reste libre est nommé comme tel.

---

## Introduction

Ce qu'il faut avoir lu avant de commencer. Ni l'un ni l'autre ne fait partie du
cycle.

| # | Section | Ce qu'on y trouve |
|---|---------|-------------------|
| 01 | [Le métier a changé](01-le-metier.md) | Pourquoi cette méthode, qui est l'architecte, ce qu'est l'agent, le glossaire |
| 02 | [Installer](02-installer.md) | Ce qu'il faut avoir, ce qui se remplace, poser la méthode sur un dépôt |

## Le cycle

| # | Section | Ce qu'on y trouve |
|---|---------|-------------------|
| 03 | [Le cycle](03-le-cycle.md) | Les neuf états et deux sorties, les trois voies, pourquoi ça rend efficace |
| 04 | [Le cahier d'instructions](04-les-instructions.md) | Les deux fichiers de règles, les mots-clés et leurs marqueurs |
| 05 | [Le cadrage](05-le-cadrage.md) | Établir une compréhension commune avant qu'une ligne s'écrive |
| 06 | [Le blueprint](06-le-blueprint.md) | Le plan : ce qu'il est, son cycle de vie, ses amendements |
| 07 | [Le backlog](07-le-backlog.md) | Consigner une idée sans quitter le travail en cours |
| 08 | [La dette technique](08-les-dettes.md) | Ce qu'un chantier laisse derrière lui, et comment on le rembourse |
| 09 | [Le chantier](09-le-chantier.md) | Le jalon, le découpage en issues, le script qui les crée |
| 10 | [Le travail](10-le-travail.md) | Une issue, un cycle. Sessions, tokens, commits, livraison |
| 11 | [La révision](11-la-revision.md) | La PR, l'audit de sécurité, la fusion |
| 12 | [À plusieurs](12-a-plusieurs.md) | Le dossier partagé, les amendements, la circulation des règles |

## Les annexes

| | Annexe | Ce qu'on y trouve |
|---|--------|-------------------|
| A | [Le dossier workflow](A-le-dossier.md) | L'arborescence, ce qui reste hors Git, la numérotation |
| B | [Les gabarits](B-les-gabarits.md) | Un squelette par type de document, et où les lire |
| C | [La forge](C-la-forge.md) | Le contrat de `forge.sh`, ses garanties, comment la porter |
| D | [La ligne de statut](D-la-ligne-de-statut.md) | Ce que le poste affiche, et le fichier d'état |
| E | [Les procédures](E-les-procedures.md) | Les neuf commandes `/nom`, et la mise à jour du kit |

---

## Ce qui fait autorité

Ce document **explique**. Il ne recopie aucun fichier du dépôt : une copie
diverge à la première correction, et c'est la copie qu'on lit.

| Ce qu'on cherche | Où c'est écrit |
|------------------|----------------|
| Les règles de travail de l'agent | `workflow/core/methode.md` |
| Le cycle, les statuts, le nommage | `workflow/core/cycle.md` |
| Les règles, l'architecture et la pile du projet | `workflow/instructions.md` |
| Les commandes de la forge et les pièges d'ici | `workflow/README.md` |
| Comment installer | [`install.md`](../install.md) |

*État au 9 septembre 2026.*
