# Un contrat de l'agent, pour changer d'outil sans tout perdre

Statut : Proposé

## Le problème, ou l'envie

La méthode est agnostique, son exécutabilité ne l'est pas. Le contenu — les
règles, le cycle, les gabarits, les scripts — vit sur n'importe quel agent. Mais
la moitié des fichiers propagés est propre à Claude Code : les neuf procédures
et leur format, le hook et son protocole de décision, la ligne de statut, les
imports de `CLAUDE.md`.

Or c'est exactement ce qui **contraint** au lieu de demander : `/question` qui
retire les outils d'écriture, la garde qui refuse `git push`, l'état visible en
permanence. Sur un autre agent, HAL redevient de la prose — et R04 était née de
ce constat-là.

Trois contrats ont été écrits : celui des fonctions, celui du transport, celui
de la forge. L'agent est le seul acteur du cycle à ne pas avoir le sien.

## L'idée

Cinq capacités, et pour chacune ce qu'on perd sans elle :

- **Lire un fichier d'instructions au démarrage, sans qu'on le lui demande.**
  La seule éliminatoire : sans elle, rien ne tient.
- **Exécuter des commandes, et demander avant celles qui engagent.** Sans elle,
  la méthode reste applicable, mais tout repose sur la vigilance humaine.
- **Charger une consigne nommée pour un seul tour** — les procédures. Sans
  elles, les mots-clés restent, joués à la main.
- **Refuser un geste avant qu'il parte** — le hook. Sans lui, `push` et `merge`
  redeviennent une consigne. C'est la perte la plus lourde.
- **Afficher un état persistant.** Sans elle, `etat.local.md` est un fichier que
  personne ne regarde.

## Ce qu'elle vaudrait

Un développeur saurait avant de changer d'agent ce qu'il perd, et dans quel
ordre. Et la promesse de portabilité cesserait d'être à moitié vraie : elle le
serait pour le contenu, et documentée comme partielle pour l'outillage.

## Ce qu'elle toucherait

L'annexe D du document, qui porte déjà les trois autres contrats. Et
`workflow/core/cycle.md`, qui est propagé et nomme pourtant
`.claude/hooks/garde-poussee.sh` — du spécifique dans un fichier qui se veut
universel.

## Les questions ouvertes

**Faut-il porter les procédures, ou seulement dire ce qu'elles font ?** Un
portage vers un autre format d'agent serait un second jeu de fichiers à tenir —
et le dépôt a déjà refusé deux fois de livrer ce qu'aucun projet n'exécute.

**Le hook a-t-il un équivalent ailleurs ?** C'est la capacité la plus rare et la
plus précieuse. Si aucun autre agent ne l'offre, le contrat dira que HAL y perd
sa seule contrainte réelle, et ce sera une information utile plutôt qu'un
regret.

**Cette entrée n'engage à rien.** Claude Code est assumé, et les textes le disent
sans renvoyer ici comme à une promesse : HAL est écrit pour lui, ce n'est pas
une étape vers autre chose. Un projet qui aurait besoin d'un autre agent posera
la question, et c'est à ce moment-là qu'elle se tranchera — avec ce qu'on saura
alors, qui vaudra mieux que ce qu'on suppose aujourd'hui.
