# Le cycle

> Vient de HAL 9001 et se met à jour avec le kit. **Ne rien y écrire de propre
> au projet** : les commandes de l'outil de suivi et les pièges rencontrés ici
> vont dans `README.md`, à côté.

Chaque fonctionnalité non triviale suit ce cycle. Rien n'est construit avant
qu'un blueprint soit accepté ; rien n'est fusionné avant d'être révisé. Les
règles de travail de l'agent — sécurité, tests, mots-clés, tokens — sont dans
`methode.md` : ce fichier décrit le processus, la méthode décrit comment on y
travaille.

## Le cycle

Neuf états et deux sorties. Une seule façon de franchir un pas : **une décision
du développeur, que l'agent demande**. Aucune étape ne se ferme d'elle-même.
L'état courant s'écrit dans `workflow/etat.local.md`, que la ligne de statut
affiche. Tout ne passe pas par la table entière : le cadrage aiguille vers l'une
des trois voies, décrites juste après.

| État | Ce qui s'y fait | Ce que l'agent demande pour en sortir | Vers |
|---|---|---|---|
| **Repos** | Rien n'est ouvert. C'est l'état entre deux chantiers. | Rien : c'est le développeur qui amène un sujet. | Cadrage |
| **Cadrage** | On passe à l'agent les constats et décisions déjà pris. Il lit `backlog/` et signale ce qui touche au sujet, pose le périmètre — ce qu'on touche, ce qu'on ne touche pas — puis pèse le travail : décisions à figer, dépendances entre tâches, ce qui ne se défait pas. | « Voici ce que j'ai compris, et ce que cela touche. Est-ce la même chose que toi ? », puis « voici la voie que je propose, et pourquoi ». Procédure : `/cadrage`. | Blueprint, Courte, ou hors chantier ; reste au Cadrage tant qu'on ne s'entend pas |
| **Blueprint** | Rédigé depuis `core/templates/tpl-blueprint.md`, statut `Proposé`. Discuté, corrigé. | « Le plan est-il accepté ? » | Chantier si `Accepté` ; reste tant qu'il est discuté ; Repos s'il est abandonné |
| **Chantier** | Le script de milestone est écrit depuis son gabarit, et donné à relire. Procédure : `/chantier`. | « Je l'exécute ? » — le seul geste qui crée dans un système externe. | Branche une fois exécuté |
| **Branche** | Rien encore. | « Je crée `dev/<slug>` depuis `main` tiré à l'instant ? » | Issues |
| **Issues** | Prises dans l'ordre des dépendances, au régime convenu à l'entrée — une issue, une vague, une portion. Tests ciblés, un commit par issue, fermeture avec commentaire de livraison. Pas de push automatique. | À l'entrée : « par où, et jusqu'où ? ». Puis rien, tant que le mandat court. À la dernière : « toutes fermées, je relève les dettes ? » | Dettes |
| **Courte** | La voie sans blueprint ni milestone. Issues écrites à la main, branche `dev/<slug>`, un commit par issue, tests ciblés, fermeture avec commentaire de livraison. | « Toutes fermées, j'ouvre la PR ? » | Révision |
| **Dettes** | Une dette par fichier dans `debts/`, préfixée du numéro du blueprint. | « Est-ce complet ? J'ouvre la PR ? » | Révision |
| **Révision** | Une PR par chantier. Diff lu, code comparé au blueprint, suite complète verte — dans la CI quand le projet lui donne autorité, et son absence se dit plutôt qu'elle ne se remplace par un « c'est vert chez moi » —, tests corrigés revus un à un, audit de sécurité. | « Je fusionne ? » | Fusion ; retour aux Issues si la révision demande des corrections |
| **Fusion** | Fusion, puis milestone fermé, blueprints amendés, entrée de backlog déplacée dans `delivered/` s'il y a lieu. | Rien : le chantier est clos. | Repos |
| **Abandon** | La seconde sortie, atteignable depuis Issues, Dettes ou Révision : ce qu'on a construit montre que le plan ne tient pas. Procédure : `/abandon`. | « J'abandonne le chantier ? » — c'est le développeur qui le décide, jamais l'agent. | Repos |

**Les procédures nommées dans cette table sont des raccourcis, pas des
passages.** Le cycle se franchit par une décision énoncée, et les règles
s'appliquent qu'on tape quelque chose ou non : elles vivent dans `methode.md` et
dans ce fichier, tous deux chargés à chaque session. Taper `/nom` apporte deux
choses qu'une conversation n'a pas — l'état réel du dépôt, injecté au moment
utile, et une restriction d'outils pour le tour, ce qui fait passer un frein de
la consigne au fait. Aucune procédure ne peut être invoquée par l'agent
lui-même : elles appartiennent au développeur.

Deux mouvements ne sont pas des états, mais des retours en arrière qui peuvent
survenir à tout moment :

- **Dérive** — ce qu'on découvre en construisant et qui s'écarte du plan. On
  s'entend d'abord, puis commentaire d'issue. Le blueprint reste figé ; une
  vraie remise en cause devient un nouveau blueprint, et ramène au Cadrage.
- **Bug** — suspend l'issue en cours, se corrige sous son issue d'origine, puis
  la reprend. L'état ne change pas. Procédure : `/bug`.

Ce qui distingue un état d'un mouvement : l'état dure, le mouvement passe. C'est
la même règle qui décide quels mots entrent dans le vocabulaire de la ligne de
statut, et pourquoi ni la dérive ni le bug n'y figurent.

## Les trois voies

Tout travail ne demande pas le même appareil, et **le cadrage est ce qui trie**.
C'est le seul passage obligé : il ne coûte qu'une conversation, et sa sortie est
la voie. On ne demande donc à personne de deviner l'ampleur avant d'avoir
regardé — on regarde d'abord, et le regard décide.

**Le cadrage pose le périmètre avant de peser.** Ce que le travail touche, et ce
qu'il ne touchera pas : les fichiers, les dossiers, les surfaces. C'est ce qui
rend les trois mesures calculables — on ne compte pas des dépendances sans
savoir ce qu'on remue — et c'est aussi ce à quoi la règle « annoncer, et
attendre » se réfère ensuite. Un geste dans le périmètre s'énonce et se fait ;
un geste qui en sort s'arrête et se demande. Sans périmètre écrit, cette règle
n'a pas de référent hors d'un chantier, puisqu'il n'y a alors pas d'issue pour
le porter.

Le périmètre n'est pas un état du cycle : il ne dure pas, il se pose. Ce qui
dure, c'est la voie qu'il permet de choisir. Il s'élargit comme il se rétrécit,
mais jamais en silence : **le sortir du périmètre est exactement le geste qui
demande qu'on s'arrête**.

Trois mesures pèsent le travail, et elles sont indépendantes l'une de l'autre :

| Ce qu'on mesure | Ce que ça exige |
|---|---|
| **Combien de décisions il faut figer** | un blueprint — c'est un document de décision, rien d'autre |
| **Si des tâches dépendent d'autres tâches** | un milestone et son script, qui existe pour câbler ces liens |
| **Ce qui ne se défait pas** | une branche, une PR, une révision |

Ce qui ne mesure rien : le nombre de fichiers touchés, ni le temps passé. Un
renommage qui traverse tout le dépôt ne porte aucune décision une fois la
découpe admise.

D'où trois voies :

| Voie | Quand | Ce qu'elle emprunte |
|---|---|---|
| **Hors chantier** | Rien à figer, rien à coordonner, rien qui engage : la méthode elle-même, la documentation, les gabarits, les réglages, un correctif qui tient en un commit. | Rien du cycle. Commit direct, sujet nommant l'objet touché. L'état reste `Repos`. |
| **Courte** | Des décisions déjà prises, et **aucune tâche qui attende une autre**. | Issues écrites à la main depuis `core/templates/tpl-issue.md`, branche `dev/<slug>`, PR. Ni blueprint ni milestone. |
| **Chantier** | Des décisions à figer avant de construire, ou des dépendances à câbler. | Le cycle entier, de `Blueprint` à `Fusion`. |

**Le développeur tranche, toujours.** L'agent pèse et propose la voie avec son
motif, à la sortie du cadrage ; il ne la choisit jamais seul. Devant une
ambiguïté, il ne tranche pas non plus : il va chercher ce qui manque — lire le
code, compter les dépendances réelles — puis pose la question avec ce qu'il a
trouvé. Procédure : `/cadrage`.

**La voie retenue s'annonce, puis se voit.** Elle est dite à la sortie du
cadrage, et la ligne de statut la porte ensuite : `Courte · dev/faute-readme`.
Une session reprise à froid doit savoir dans quel régime elle travaille sans
avoir à le demander.

**Une voie se change en cours de route.** Un travail parti en voie courte qui
révèle une dépendance revient au cadrage : c'est la dérive, qui existe pour ça.
Ce qui a été commité reste, et la branche est déjà là.

## Les dépendances se lisent comme un chemin

Une liste de paires « bloquée par » ne se lit pas. Elle dit ce qui est interdit,
jamais par où commencer — et c'est pourtant la seule question qu'on se pose
devant un chantier qui s'ouvre.

**Partout où des dépendances sont énoncées, elles se rendent aussi comme un
ordre de travail** : les vagues, de la plus fondamentale à la plus dérivée,
chacune nommant ce qu'elle établit. Le tableau du blueprint, la sortie du script
de jalon, le passage de relais, la reprise à froid — tous en parlent, tous
doivent le montrer.

Quand plusieurs ordres sont valides — et il y en a presque toujours —, l'agent
en **recommande un, avec son motif**. Le motif se tire du risque, jamais du
confort : ce qui peut faire tomber le chantier se traite en premier, et ce qui
se prouve sans le reste vient avant ce qui en dépend. Un ordre recommandé sans
motif est un ordre numérique déguisé, et il n'apprend rien.

**Au moment d'attaquer**, deux choses se demandent ensemble, et une seule fois :

- **Par où** — la première issue de **chaque** chemin ouvert, pas seulement
  celle du chemin recommandé. Un chemin qu'on ne montre pas est un chemin qu'on
  ferme sans le dire.
- **Jusqu'où** — une issue, une vague entière, ou une portion nommée. Le second
  et le troisième sont des **mandats** : ils disent ce qu'ils couvrent et ce qui
  les interrompt, l'agent le rappelle quand il s'en sert, et ils meurent avec la
  tâche. Ce qu'aucun mandat ne couvre reste ce qu'il était — ce qui ne se défait
  pas.

La recommandation porte sur les deux, et se marque comme telle. Elle se règle
sur ce qui coûte cher à défaire, non sur ce qui va vite : une vague homogène
dont les issues se relisent ensemble se prend d'un bloc ; une vague qui touche
une migration, une garde ou un système externe se prend une issue à la fois. La
question se pose avec l'outil de choix quand il y en a un.

Cela vaut à l'entrée de l'état `Issues` comme en voie `Courte` : ce qui change
d'une voie à l'autre est d'où viennent les tâches, pas la façon de les attaquer.

## Statuts d'un blueprint

- `Proposé` — en discussion, mutable.
- `Accepté` — figé, source de vérité du chantier.
- `Remplacé par NNNN` — conservé, ne pas appliquer.
- `Abandonné` — conservé, avec en tête où ses idées ont voyagé.

## Nommage

- Blueprint : `blueprints/NNNN-kebab-title.md`, quatre chiffres, jamais réutilisé.
  Le numéro suit l'ordre d'exécution des chantiers.
- Backlog : `backlog/kebab-title.md`, sans numéro.
- Dette : `debts/NNNN-kebab-title.md`, NNNN = blueprint d'origine. **`0000` quand
  elle naît hors chantier** : aucun plan ne la porte, et un numéro emprunté à un
  blueprint la ferait chercher là où elle n'est pas.
- Script : `milestones/NNNN-kebab-title.sh`, même numéro et slug que le
  blueprint.
- Bibliothèque : `core/scripts/lib/forge.sh`, **quelle que soit la forge**. Le
  fichier livré parle à GitHub ; un projet sur une autre forge le réécrit sous
  le même nom et contre le même contrat, et rien d'autre ne bouge — ni le
  gabarit de script, ni les imports, ni le dépôt visé. Le nom dit le rôle, pas
  l'outil.
- Milestone : `MNNNN — Titre court`, les quatre chiffres du blueprint, zéros
  compris — `M0017`, pas `M17`. Un numéro tronqué ne se retrouve plus par
  recherche à partir du nom de fichier du blueprint.
- État courant : `workflow/etat.local.md`, hors Git. Il porte **l'étape**, seule
  chose que Git ne sait pas dire ; le chantier vient de la branche `dev/<slug>`,
  qui nomme le blueprint, et l'issue du sujet du dernier commit. Ce qu'on écrit
  dans le fichier l'emporte sur ce qui se déduit.
- Branche : `dev/kebab-title`.
- Commit de chantier : `#N: ce que le code fait maintenant`, ou `MNNNN #N: …`.
- Commit hors chantier : le sujet nomme l'objet touché, puis dit son état —
  `Blueprint 0017 : gestion des comptes, accepté`, `Méthode : …`, `M0017 : …`.
  Forme et contenu des deux : `core/templates/tpl-commit.md`.

## La ligne de statut

Le poste affiche en permanence où on en est : `Issues · M0002 · #13 ·
dev/lanceur-de-tests · 62% · Opus 5`. Elle se pose une fois, par le développeur :

```
bash workflow/core/scripts/setup.sh
```

Le script pose le réglage, crée `workflow/etat.local.md` et complète
`.gitignore`. L'agent tient ensuite le fichier d'état à jour ; la méthode l'y
oblige. Détail et cas limites : annexe E du document de référence.

## La garde des gestes irréversibles

`setup.sh` pose aussi un hook qui **refuse à l'agent `git push`, `git merge` et
`gh pr merge`**. Ce sont les gestes qu'un `git revert` ne défait pas, et le seul
endroit où la méthode passe d'une consigne à une contrainte : la règle existait
déjà, elle est maintenant vraie.

Le développeur, lui, n'est pas gêné — il pousse en tapant `! git push` dans sa
saisie, ce qui n'est pas un appel d'outil et ne passe pas par la garde.

Le hook vit dans `.claude/hooks/garde-poussee.sh` et vient du kit. Il ne lit que
la commande, en bash, sans dépendre de rien de plus que ce que le poste a déjà.

## Mettre à jour le kit

```
bash workflow/core/scripts/setup.sh --update           # montre l'écart, ne touche à rien
bash workflow/core/scripts/setup.sh --update --apply   # aligne ce qui est en retard
```

Le périmètre est `workflow/core/` et les deux dossiers de `.claude/`, `skills/`
et `hooks/` : ce qui vient de HAL 9001 et qu'un projet ne modifie jamais. Tout
le reste de `workflow/` appartient au projet et n'est jamais touché. C'est un
dossier plutôt qu'une liste de chemins, pour qu'un fichier ajouté en amont
arrive sans qu'on ait à modifier le script d'abord.

Un fichier qui diffère de l'amont est **en retard** ou **modifié ici**, et ce
n'est pas la même chose. Le script cherche si le contenu local a existé tel quel
en amont : si oui c'est un retard, sinon quelqu'un l'a adapté. `--apply`
n'aligne que les retards. **Ce qui a été modifié ici n'est jamais écrasé**, il
est listé avec la commande pour en voir le diff.

Le nouveau est signalé sans être imposé — une absence peut être une décision —
et ce qui n'existe pas en amont, comme les scripts de milestone du projet, n'est
jamais touché. Rien n'est commité : le diff se relit.

## Le dépôt visé

`workflow/repo.sh` porte le dépôt que les scripts de milestone
visent. Il vit **hors de `core/`**, et sa place le dit : l'amont ne le porte
pas, donc une mise à jour ne peut pas l'écraser. `setup.sh` le crée à partir du remote
`origin`, et la valeur se fait confirmer — un remote peut pointer un fork quand
les issues vivent en amont.

S'il manque, la bibliothèque échoue à l'import, bruyamment. C'est voulu : un
repli silencieux sur une valeur d'exemple ferait créer des issues dans le vide.

## Abandonner un chantier

Ce qu'on construit montre parfois que le plan ne tient pas, et le constat ne
peut souvent être fait qu'une fois le mécanisme en marche. L'abandon est alors
une sortie normale du cycle, pas un échec à cacher : ce qui compte est qu'on
puisse savoir, des mois plus tard, pourquoi on avait renoncé.

Le principe qui décide du sort de chaque pièce : **chacune dit la vérité sur
elle-même, et le récit du chantier vit dans la description du milestone.**

| Pièce | Sort |
|---|---|
| Blueprint | statut `Abandonné`, avec en tête où ses idées ont voyagé. Conservé, jamais réécrit. |
| Milestone | fermé, la description amendée en tête : qui, quand, pourquoi, où le problème a migré, où le travail vit. **Le titre ne change pas.** |
| Issues jamais faites | fermées avec la raison « non planifié » |
| Issues livrées | fermées « complété ». Leur travail existe et est commité : les dire non planifiées effacerait ce qui a été fait. |
| Branche | conservée, non fusionnée. Son nom est écrit dans la description du milestone, sans quoi le travail devient introuvable. |
| Entrée de backlog | revient au backlog, statut `Proposé`, amendée de ce que la tentative a appris. |

**Le titre du milestone ne change pas** : la garde d'idempotence des scripts
cherche par titre exact, et un « (abandonné) » ajouté ferait recréer le
milestone à la prochaine exécution. Renommer est sans danger pour la forge,
fatal pour le script.

**Abandonner un chantier n'est pas abandonner l'idée.** Une solution qui s'est
révélée surdimensionnée ne dit rien du besoin, qui tient toujours. L'entrée de
backlog retourne donc en `Proposé` ; `abandoned/` est pour l'idée qu'on renonce
à poursuivre, pas pour la tentative qui n'a pas marché.
