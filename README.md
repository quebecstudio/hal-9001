# HAL 9001

**Rocket science starter kit.**

Une méthode pour coder à l'intuition avec un agent sans travailler comme un noob :
un cadrage avant le plan, un plan avant le code, un chantier par plan, des tâches
générées par un script versionné, et une révision avec audit avant chaque fusion.

**→ [Lire la méthode](documentation/README.md)** — douze sections et cinq
annexes : le cycle, le cahier d'instructions, le cadrage, le blueprint, le
chantier, la révision — puis le dossier `workflow`, les gabarits, la forge, la
ligne de statut et les procédures.

## Installer

Deux dossiers sont à poser dans le dépôt du projet : `workflow/`, qui se lit, et
`.claude/`, qui s'applique. Le reste de ce dépôt — la documentation — n'a rien à
faire dans un projet.

**Le plus simple est de laisser un agent le faire** : dans le dépôt du projet,
on lui donne [`install.md`](install.md). Il pose les fichiers **et** remplit les
sections que la copie laisse en blanc — ce qu'aucune commande ne sait faire,
puisqu'il faut lire le dépôt pour les écrire.

À la main, c'est cinq étapes :
**[documentation/02-installer.md](documentation/02-installer.md)**.

## Ce que ce dépôt contient

| | |
|---|---|
| [`documentation/`](documentation/README.md) | La méthode expliquée. Reste ici, ne s'installe pas. |
| `workflow/core/` | Le kit : les règles, le cycle, les gabarits, les scripts. |
| `.claude/` | Les neuf procédures et la garde. |
| [`install.md`](install.md) | Le prompt d'installation, à donner à un agent dans le projet cible. |
| `workflow/blueprints/`, `backlog/`, `debts/` | Le travail de **ce** dépôt. Ne part pas dans les installations. |

## Ce qui se remplace, et ce qui ne se remplace pas

**La forge se remplace** — GitLab, Azure DevOps, Jira : les
[préalables](documentation/02-installer.md#ce-qui-est-requis) disent par quoi,
et le [contrat de la forge](documentation/C-la-forge.md#le-contrat-de-la-forge)
dit ce qu'elle doit porter.

**L'agent, non** : HAL est écrit pour Claude Code, et l'assume. Les règles, le
cycle, les gabarits et les scripts vivent ailleurs sans rien perdre ; les
procédures, la garde qui refuse un geste et la ligne de statut, non — et ce sont
elles qui contraignent au lieu de demander.

**Ce qu'on adapte, on le forke.** Les gabarits, les mots-clés, les statuts,
jusqu'aux règles : tout cela se change, et c'est prévu. Forker donne le point de
comparaison — ce qu'on a modifié se lit dans un diff, et ce que la méthode gagne
ensuite se tire au lieu d'être recopié à la main.
