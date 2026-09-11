# Annexe E — Les procédures

[← Annexe D](D-la-ligne-de-statut.md) · [Sommaire](README.md)

Une procédure est un fichier que l'agent charge quand on tape son nom, et qui
vaut **pour ce tour-là seulement**. Neuf sont livrées, dans `.claude/skills/` :
six portent le nom d'un mot-clé, les trois autres couvrent le cadrage d'un
sujet, l'ouverture d'un chantier et son abandon.

**Une procédure ne redit pas la règle : elle la joue.** Le cahier est déjà en
contexte du premier au dernier tour ; une procédure qui recopierait ses règles
créerait un second texte destiné à diverger du premier.

Ce qu'elle apporte est ailleurs, et c'est ce qui décide si elle mérite
d'exister : elle change **ce que l'agent voit**, en injectant l'état réel du
dépôt avant qu'il commence, et **ce qu'il peut faire**, en retirant ou en
pré-approuvant des outils pour la durée du tour.

| Procédure | Ce qu'elle voit | Ce qu'elle peut |
|-----------|-----------------|-----------------|
| [`/question`](#question) | — | Retire les outils d'écriture, **Bash compris**. |
| [`/idee`](#idee) | Le backlog entier, l'état courant | Pré-approuve le dépôt et le commit, restreints à `workflow/backlog/`. |
| [`/bug`](#bug) | L'état du dépôt, l'issue en cours | — |
| [`/amendement`](#amendement) | Le statut de chaque blueprint, la date du jour | — |
| [`/cadrage`](#cadrage) | Le backlog, les chantiers passés, l'état du dépôt | Retire les outils d'édition ; pose l'étape `Cadrage` avant le tour. |
| [`/chantier`](#chantier) | Les blueprints, les scripts déjà écrits, la branche | — |
| [`/abandon`](#abandon) | L'état, le statut des blueprints, la date | — |
| [`/relais`](#relais) | Les commits de la session, les fichiers modifiés, l'heure | — |
| [`/reprise`](#reprise) | Le relais, l'état du dépôt maintenant | Supprime le relais une fois lu. |

---

## Les neuf

### `/question`

*Le mot-clé « Question : », rendu exécutoire. Marqueur de réponse : ❓*

**C'est la seule qui contraigne plutôt qu'elle ne demande.** « Question : » dans
un message est une règle que l'agent peut enfreindre par distraction ;
`/question` lui retire Edit, Write et **Bash**, et il ne peut plus modifier un
fichier même s'il le voulait. Read, Grep et Glob restent : on lit, on ne touche
pas.

Bash a longtemps manqué à la liste, et la garantie annoncée n'en était pas une :
tant qu'il restait, un `sed` ou un heredoc écrivait dans un fichier malgré le
reste. **Retirer Edit et Write ferme la porte ; laisser Bash laisse la
fenêtre.**

Si la réponse fait apparaître un travail évident, l'agent le propose — il ne le
fait pas.

### `/idee`

*Le mot-clé « Idée : ». Marqueur de réponse : 💡*

Elle fait l'inverse de `/question` : elle **pré-approuve** le dépôt et le
commit, verrouillés sur `workflow/backlog/`. Le mot-clé existe pour qu'une idée
se dépose sans quitter le travail en cours ; s'arrêter pour demander
l'autorisation de commiter casserait précisément ce qu'il protège.

Elle montre **le backlog entier** — en attente, livré, abandonné — avant
d'écrire, et le premier geste est de chercher le doublon. Une idée déposée deux
fois sous deux noms survit longtemps à un backlog relu à chaque cadrage : quand
une entrée couvre déjà le sujet, on l'enrichit au lieu d'en ouvrir une seconde.

Le champ `origin` prend le chantier et l'issue en cours, pour qu'on sache plus
tard d'où l'idée venait. Le commit est seul, et son sujet dit ce que l'entrée
propose.

**Puis elle reprend le travail interrompu**, en disant où. C'est l'étape qu'on
escamote, et c'est la raison d'être du mot-clé.

### `/bug`

*Le mot-clé « Bug : ». Marqueur de réponse : 🐛*

**Reproduire avant de corriger.** C'est l'étape qu'on saute quand le défaut a
l'air évident, et c'est celle qui compte : un test qui échoue prouve qu'on a
compris le symptôme, puis prouve qu'on l'a réglé.

Le test porte sur **le comportement observé**, pas sur la cause supposée — et on
vérifie qu'il échoue pour la bonne raison, un test qui échoue à cause d'une
faute de frappe ne prouvant rien. Puis le code, puis les tests ciblés, pas la
suite complète.

Le point non évident : **le défaut se corrige sous l'issue dont il relève**,
avec son propre commit. S'il ne relève d'aucune issue ouverte, c'est peut-être
une entrée de backlog, et il faut le dire plutôt que de le glisser là.

**Si le défaut ne se reproduit pas, on ne corrige pas à l'aveugle** : on dit ce
qui a été tenté et on demande les conditions d'apparition. Une correction posée
sur un symptôme non reproduit ajoute du code sans rien fermer.

### `/amendement`

*Le mot-clé « Amendement : ». Marqueur de réponse : ✏️*

Elle affiche **le statut de chaque blueprint**, parce que c'est lui qui décide
de tout :

| Ce qui est visé | Ce qui se passe |
|-----------------|-----------------|
| Blueprint `Proposé` | Ce n'est pas un amendement : le corps se corrige directement. |
| Blueprint `Accepté` | Bloc **en tête**, daté, qui dit sa conséquence. Le corps n'est jamais réécrit. |
| Issue ouverte | Un commentaire d'issue, même contenu. |
| Pièce fermée, `Remplacé` ou `Abandonné` | On n'amende pas ce qui est clos : ça devient une entrée de backlog. |

Deux règles d'ordre. **S'entendre d'abord** — un amendement mal compris se
consigne pourtant, et le document ment ensuite avec autorité. Et **consigner
avant** qu'une ligne parte dans l'autre sens : un amendement écrit après coup
n'est plus un amendement, c'est une justification.

Elle ne touche pas au statut, et n'écrit pas le code que l'amendement rend
nécessaire.

### `/cadrage`

*Pas de mot-clé. L'entrée du cycle.*

Elle **retire les outils d'édition** : un cadrage ne produit rien qu'une
décision. Bash reste, pour lire et interroger — l'historique, la forge, le code,
les dépendances —, parce que peser le travail demande de regarder ; il ne sert
pas à écrire. Elle montre le backlog, les chantiers passés et l'état du dépôt,
parce qu'une idée oubliée qui revient sous un autre nom est le gaspillage le plus
courant.

Elle enchaîne : dire ce qu'on a compris, **poser le périmètre**, peser le
travail par les [trois mesures](03-le-cycle.md#les-trois-voies), proposer la
voie, rendre le sommaire en quatre blocs.

Deux exigences la caractérisent. **Devant une ambiguïté, elle ne devine pas** :
elle va chercher ce qui manque — lire le code, compter les dépendances réelles —
puis revient avec ce qu'elle a trouvé. Et elle pose la question **avec l'outil
de choix** plutôt qu'en prose : ce qu'on lit dans un paragraphe se saute, ce
qu'on clique se prend.

**L'étape `Cadrage` est posée avant le tour**, par un bloc que le harnais exécute
à l'ouverture — entrer dans un cadrage, c'est être au Cadrage. C'est la seule
procédure qui écrit son propre état, et elle le fait parce qu'elle est la seule à
ne pas pouvoir l'écrire pendant : un jour, l'agent a annoncé une étape qu'il
n'avait pas lue, faute de l'avoir écrite au tour d'avant.

L'étape **suivante**, celle que la voie ouvre, s'annonce à la sortie et s'écrit
au premier tour outillé. Tenir `etat.local.md` est déjà une règle de la méthode ;
la procédure n'a pas à la doubler.

### `/chantier`

*Pas de mot-clé.*

Elle couvre l'étape où une erreur crée des objets dans un système externe, que
ni `git revert` ni rien d'autre ne défait. **Rien n'est exécuté sans accord.**

Elle s'arrête d'elle-même si le blueprint visé n'est pas `Accepté`. Elle vérifie
aussi ses **alternatives** : si l'option la moins chère a été écartée par un
jugement non vérifié, elle s'arrête et le dit — ouvrir le chantier est le geste
après lequel se tromper coûte cher, et un jugement s'éprouve avant, pas après.

Puis : écrire le script depuis son gabarit, **le montrer et s'arrêter** — c'est
la seule relecture avant que les issues existent pour de bon —, l'exécuter une
fois, reporter les numéros réels dans le blueprint, **montrer le chemin**, créer
la branche.

Montrer le chemin est ce qui rend les tâches utilisables : le graphe en vagues
tel que la **forge** le porte — pas tel que le blueprint le prévoyait —, les
ordres valides, celui qu'on recommande et son motif, puis la première issue de
chaque chemin ouvert et le régime de travail proposé.

Une issue qui manque au tableau du blueprint manque au plan : elle le dit
plutôt que de la fabriquer. Et elle n'écrit pas de code — ouvrir le chantier et
prendre la première issue sont deux gestes distincts.

### `/abandon`

*Pas de mot-clé. La seconde sortie du cycle.*

**L'abandon se décide, il ne se propose pas.** Si le développeur n'a pas dit
qu'il renonce, la procédure s'arrête et demande.

Un chantier abandonné n'est pas un échec à cacher. Ce qui compte est qu'on
puisse savoir des mois plus tard pourquoi on avait renoncé, et **retrouver le
travail déjà fait**. D'où huit gestes dont aucun n'efface :

- les issues jamais faites se ferment en « non planifié » — sans cette raison,
  la forge les affiche comme complétées ;
- les issues livrées restent en « complété » : leur travail existe ;
- le jalon se ferme **en amendant sa description** — qui, quand, pourquoi, et
  **le nom de la branche** où le travail vit. Son titre ne bouge pas : la garde
  d'idempotence cherche par titre exact, et un « (abandonné) » ajouté ferait
  recréer le jalon au prochain lancement ;
- le blueprint passe à `Abandonné`, corps intact ;
- la branche reste, non fusionnée ;
- l'entrée de backlog **retourne au backlog**, amendée de ce que la tentative a
  appris. Abandonner un chantier n'est pas abandonner l'idée : une solution
  surdimensionnée ne dit rien du besoin, qui tient toujours.

### `/relais`

*Le mot-clé « Relais : ». Marqueur de réponse : 🔁*

Elle montre les commits de la session, les fichiers modifiés, l'heure et l'état
— **c'est l'ancre**, à recopier en tête du relais.

Ce qui fait un bon relais : nommer les fichiers sans les recopier, dire l'état
de l'issue en cours et pas seulement son numéro, et **écrire ce qui a échoué** —
les fausses pistes, les diagnostics démentis, ce qui n'a pas pu être vérifié.
C'est ce qui a le plus de valeur pour le suivant, et la première chose qui
disparaît d'un compte rendu qui ne raconte que les succès.

Avant de rendre la main, elle vérifie que **ce qui doit durer est déjà
ailleurs** : une décision sur l'issue, une règle dans le cahier, une idée au
backlog. Le relais est un fichier jetable — ce qu'on n'y confie qu'à lui est
perdu à la reprise.

### `/reprise`

*Le mot-clé « Reprise : ». Marqueur de réponse : 🔄*

**La seule qui supprime un fichier**, et c'est délibéré : le relais est éphémère
par conception, sa fonction s'épuise à la lecture.

Elle lit le relais et les fichiers qu'il nomme — le relais est un index, pas le
contexte —, **supprime le fichier**, résume en trois lignes, puis attend avant
de modifier le dépôt.

Ce qui permet de juger si le relais a vieilli n'est pas de le garder, mais son
**ancre** : heure, branche, HEAD, distant, arbre, comparés à l'état réel. Une
branche qui a changé se dit avant tout le reste ; un HEAD qui a avancé se donne
en nombre de commits. Un relais sans ancre se lit avec la prudence d'un relais
périmé.

Si le relais est absent, elle le dit et s'arrête : il ne faut surtout pas en
inventer le contenu.

---

## Les skills qui ne sont pas des procédures

Un projet peut avoir d'autres skills : celles qu'un écosystème fournit — un
serveur MCP de framework, un outil qui tient la section Pile à jour — et celles
qu'il écrit pour son propre domaine.

Elles vivent au même endroit, `.claude/skills/`, et rien ne les distingue
techniquement. Ce qui les distingue est **d'où elles viennent** :

| | D'où | Ce que `--update` en fait |
|---|---|---|
| Les neuf procédures | Le kit | Alignées, et retirées si l'amont les retire. |
| Une skill de projet, ou d'écosystème | Le projet | **Jamais touchée** : ce qui n'existe pas en amont n'est pas géré. |

Et ce qui les sépare d'une règle du cahier vaut d'être connu : **une règle vaut
tout le temps et coûte du contexte en permanence ; une skill ne se charge que
quand son domaine est touché.** Une convention qui vaut pour tout le code va au
cahier. Un savoir-faire qui ne sert qu'en touchant un domaine précis est une
skill.

## Ce qu'on n'a pas outillé, et pourquoi

Le tri s'est fait sur un seul critère — *la procédure change-t-elle ce que
l'agent voit ou ce qu'il peut ?* — et non sur la longueur de la règle.

- **⚠️ Attention** n'en a pas. Relire la règle visée, corriger ce qui vient
  d'être produit, juger si la règle manquait : c'est du jugement, sans rien à
  injecter ni à verrouiller.
- **🔴 Interruption et 🧩 Conseil** non plus, et c'est cohérent : ils partent de
  l'agent. On n'invoque pas une procédure pour s'interrompre soi-même.
- **Pas d'alias.** `/idea` à côté de `/idee` ferait deux vocabulaires pour un
  même geste — ce que la méthode refuse partout ailleurs.

## En écrire une

Le format tient en un dossier et un fichier, `.claude/skills/<nom>/SKILL.md`,
dont l'en-tête déclare ce que la procédure fait, et le corps ce qu'elle joue. Le
nom du dossier devient la commande.

- **Le nom est celui du mot-clé, sans accent** : un geste, un mot.
- **Elle ne recopie aucune règle**, ni aucune forme de réponse. Elle renvoie au
  cahier, qui reste la source.
- **Elle ne s'invoque pas d'elle-même.** Le cahier gouverne déjà le moment où
  chaque geste se pose ; une procédure qui se déclencherait seule ajouterait un
  second déclencheur en concurrence — et pour `/reprise`, elle supprimerait un
  passage de relais que personne ne lui a demandé de lire.

## Installer, et mettre à jour

**Rien à installer** : une procédure est découverte par sa seule présence, et le
`checkout` de `.claude/` suffit à les poser toutes.

La mise à jour demande une commande, parce qu'un `checkout` ajoute et remplace
mais **ne supprime jamais** — une procédure retirée en amont resterait sur le
projet sans que personne le voie :

```sh
bash workflow/core/scripts/setup.sh --update
```

Elle aligne tout le kit d'amont : `.claude/skills/`, `.claude/hooks/`,
`workflow/core/` avec ses gabarits et ses scripts. `instructions.md` et
`workflow/README.md` en sont exclus, puisque le projet les remplit.

**Elle montre avant d'agir.** Sans `--apply`, rien n'est touché : le script dit
ce qui diffère et s'arrête. C'est le défaut, parce qu'une mise à jour qui aligne
d'abord et explique ensuite ne laisse aucune place au refus.

Et surtout, elle distingue deux choses que « diffère de l'amont » confond : un
fichier **en retard** et un fichier **modifié ici**. Elle cherche pour cela si
le contenu local a existé tel quel dans une version d'amont. `--apply` n'aligne
que les retards ; ce qui a été adapté n'est jamais écrasé, il est listé avec la
commande pour en voir le diff. C'est la protection qui manquait : la constante
de dépôt d'un projet a bien failli disparaître ainsi, et le dégât ne se serait vu
qu'au chantier suivant, quand un script aurait créé des issues dans le vide.

Trois précautions plus anciennes tiennent toujours :

- **Le script ne met à jour que ce qui est déjà là.** Reprendre le dossier
  entier ramènerait ce que le projet a retiré exprès.
- **Ce qui est nouveau en amont est signalé, jamais imposé** — une absence peut
  être une décision.
- **Ce qui n'existe pas en amont n'est jamais touché**, à commencer par les
  scripts de jalon et les skills du projet.

Rien n'est commité : les fichiers sont posés dans la copie de travail pour être
relus. Si `setup.sh` s'est lui-même mis à jour, il le dit et demande à être
relancé — la version qui vient de tourner était encore l'ancienne.

---

[← Annexe D](D-la-ligne-de-statut.md) · [Sommaire](README.md)
