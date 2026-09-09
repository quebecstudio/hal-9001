# 02 — Installer

[← Le métier](01-le-metier.md) · [Sommaire](README.md) · [Suivant : Le cycle →](03-le-cycle.md)

**Le plus simple est de laisser un agent le faire.** Dans le dépôt du projet, on
lui donne [`install.md`](../install.md) : il pose les fichiers, propose
l'architecture, la pile et les conventions telles qu'il les observe, et s'arrête
pour faire valider.

À la main, c'est cinq étapes. Le détail de chacune suit.

---

## Les cinq étapes

### 1. Vérifier

L'arbre de travail est propre — l'étape suivante écrit dans l'index. `gh` est
authentifié. On sait quel dépôt distant vise le projet.

### 2. Poser les fichiers

```sh
git remote add hal https://github.com/quebecstudio/hal-9001.git
git fetch hal
git checkout hal/main -- workflow/core workflow/README.md workflow/instructions.md .claude
git reset
```

**Si `workflow/` ou `.claude/` existent déjà**, ne pas lancer le `checkout` tel
quel : `git diff hal/main -- <les mêmes chemins>` d'abord, puis fichier par
fichier.

### 3. Lancer le script d'installation

```sh
bash workflow/core/scripts/setup.sh
```

Il pose tout ce qui est mécanique et **finit par la liste de ce qu'il ne sait
pas faire**. Cette liste est la feuille de route des deux étapes suivantes.

C'est le développeur qui l'exécute, ou qui l'autorise.

### 4. Écrire les fichiers racine

`CLAUDE.md`, `AGENTS.md` selon l'agent, réduits à un **renvoi** vers le cahier.
Un seul endroit fait autorité.

```
Lire `workflow/core/cycle.md` et `workflow/README.md` avant tout chantier.

@workflow/core/methode.md
@workflow/instructions.md
@workflow/instructions.local.md
```

Pour un agent qui ne lit pas les imports, la même chose en clair, en première
ligne.

### 5. Remplir ce que la copie laisse en blanc

C'est la moitié qu'on oublie, et un dépôt à moitié amorcé produit des plans
creux.

| À remplir | Où | Sans quoi |
|-----------|-----|-----------|
| L'architecture, la pile avec ses **versions exactes**, les conventions | `workflow/instructions.md` | L'agent invente, et il invente différemment chaque fois. |
| Les commandes exactes de la forge, et les pièges d'ici | `workflow/README.md` | Un agent qui ne trouve pas la commande s'arrête et la demande. |
| Le **lanceur de tests** et ses commandes — ciblée et suite | Section Pile | Le premier chantier s'en passe, et chaque chantier suivant hérite d'une surface plus grande à couvrir après coup. |
| Le dépôt visé, déduit du remote par `setup.sh` | `workflow/repo.sh` | Un remote peut pointer un fork alors que les issues vivent en amont. |
| Les étiquettes du projet, les types de tâche, les dépendances | Dans la forge | Le premier script de jalon est le bon endroit : il est relu, commité et rejouable. |

C'est fait. Le premier blueprint porte la première vraie fonctionnalité, jamais
l'amorçage.

---

## Le détail

### Ce qui est requis

La méthode est décrite avec GitHub et Claude Code. Les deux ne se remplacent pas
de la même façon : **la forge est un choix d'outils**, l'**agent est une
dépendance assumée**.

| Capacité requise | Ici | Équivalents |
|------------------|-----|-------------|
| Un dépôt Git distant, avec branches et demandes de fusion. | GitHub | GitLab, Azure DevOps, Bitbucket, Gitea, un Git auto-hébergé avec n'importe quel outil de revue. |
| Un suivi de tâches qui connaît jalons, étiquettes, types et **dépendances réelles**, interrogeable par API. | Issues et jalons GitHub | Issues GitLab avec epics, work items Azure Boards, Jira, Linear. Il faut un champ « bloqué par » réel, pas un texte. |
| Une ligne de commande sur cette API, authentification déjà réglée sur le poste. | `gh` | `glab`, `az boards`, un client REST maison. |
| Un agent qui lit des fichiers d'instructions à la racine, exécute des commandes, et demande avant d'engager. | Claude Code | Tout agent capable de ces trois choses reprend le contenu ; il perd les procédures, la garde et la ligne de statut. |

S'y ajoutent **bash**, qui porte tout l'outillage et ne s'installe pas — Git for
Windows le livre là où il pourrait manquer —, et **une suite de tests** que
l'agent peut lancer seul.

Ce que la forge doit porter, précisément, est le [contrat de la forge](C-la-forge.md#le-contrat-de-la-forge).

> **Pourquoi l'agent, lui, n'est pas remplaçable.** Le contenu — les règles, le
> cycle, les gabarits, les scripts — vit sur n'importe quel agent. Mais les neuf
> procédures, la garde qui refuse un geste et la ligne de statut sont écrites
> pour Claude Code, et ce sont précisément les pièces qui **contraignent** au
> lieu de demander. Sur un autre outil, HAL redevient de la prose. Ce n'est pas
> une étape vers autre chose.

### Ce que `setup.sh` pose

Les dossiers manquants et leurs `.gitkeep`, les exclusions Git, la fin de ligne
LF sur les `.sh`, la ligne de statut et son fichier d'état, la constante de
dépôt déduite du remote.

Il est **idempotent** : relancé, il ne touche à rien de ce qui est en place.
Écrire dans les réglages de l'agent demande une permission que l'agent ne peut
pas se donner — d'où l'exécution par le développeur, ou son approbation dans le
dialogue de permission.

### Pourquoi les chemins sont nommés un par un

`workflow/core` et `.claude` sont le kit. Le reste de `workflow/` — blueprints,
backlog, dettes, notes, scripts de jalon — est le **travail** du dépôt amont.
Copier `workflow` en entier ferait partir les plans et les idées de l'amont dans
chaque projet installé. La frontière est détaillée à
l'[annexe A](A-le-dossier.md#le-kit-et-le-travail).

`.claude/` n'est pas un dossier de poste : il est versionné et partagé comme le
reste, et c'est ce qui rend l'outillage identique pour toute l'équipe. Ce qui
n'appartient qu'à un développeur porte le suffixe `.local` et reste hors Git.

Il n'apporte **pas** `.claude/settings.json` : le réglage se fabrique à
l'arrivée. `.claude/` transporte ce qui se copie, pas ce qui se produit.

### Sur un projet existant

L'ordre s'inverse. Le socle est déjà là, et c'est ce qui rend le cahier
difficile : ses sections ne se remplissent pas de mémoire.

On demande à l'agent de parcourir le dépôt et de proposer une première version
de l'architecture, de la pile et des conventions **telles qu'il les observe**.
Le développeur corrige — l'agent décrit ce qu'il voit, y compris ce qu'on ne
veut plus faire.

Les fichiers racine s'**ajustent**, ils ne s'écrasent pas : on ajoute le renvoi,
on ne retire rien. Ce qui décrit le projet a sa place dans `instructions.md`, et
son retrait de `CLAUDE.md` se **propose**. Une consigne existante qui
contredirait le cahier se signale ; elle ne se tranche pas seul.

Le premier blueprint vient ensuite, sur la première fonctionnalité, pas sur une
remise en ordre.

### Ce qu'on adapte, on le forke

Les gabarits, les mots-clés, les statuts, jusqu'aux règles : tout cela se
change, et c'est prévu. Mais une équipe qui les réécrit dans son coin perd le
lien avec l'amont, et n'a plus aucun moyen de dire ce qu'elle a modifié ni
pourquoi.

Forker donne ce point de comparaison : ce qu'on a changé se lit dans un diff, et
ce que la méthode gagne ensuite se tire au lieu d'être recopié. Le remote `hal`
reste en place pour ça — et pour la [mise à jour](E-les-procedures.md#installer-et-mettre-à-jour).

---

[← Le métier](01-le-metier.md) · [Sommaire](README.md) · [Suivant : Le cycle →](03-le-cycle.md)
