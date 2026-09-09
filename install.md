# Poser HAL 9001 sur ce dépôt

Ce fichier est un prompt. On le donne à un agent, dans le dépôt du projet où la
méthode doit s'installer — pas dans le dépôt de la méthode.

> **À lire avant de le donner à un agent.** C'est un texte qui pilote un agent
> dans votre dépôt : lisez-le en entier d'abord, comme vous liriez un script
> d'installation. Il ne supprime rien, n'écrase rien sans le dire, et s'arrête
> pour demander à chaque endroit qui engage. Si votre copie vient d'un fork,
> comparez-la à l'amont avant de vous en servir.

---

Tu installes HAL 9001 sur ce dépôt. La méthode tient en deux dossiers : `workflow/`, qui se lit, et `.claude/`, qui s'applique.

## Avant tout

Vérifie et rapporte en cinq lignes, sans rien modifier :

- l'arbre de travail est propre, ou ce qui traîne dedans ;
- `workflow/` ou `.claude/` existent déjà, ou non ;
- ce que `CLAUDE.md`, `AGENTS.md` et leurs semblables contiennent déjà —
  beaucoup de projets y ont accumulé l'architecture, la pile et les
  conventions ; c'est de la matière à déplacer, pas à redécouvrir ;
- le dépôt distant, d'après `git remote -v` : `<propriétaire>/<nom>`. C'est ce
  que `repo.sh` portera, écrit par `setup.sh` et à faire confirmer. S'il y a plusieurs remotes ou aucun,
  demande lequel plutôt que de choisir ;
- de quoi le projet est fait : langage, framework, gestionnaire de paquets,
  lanceur de tests s'il y en a un.

**Si l'arbre n'est pas propre, arrête-toi et dis-le.** L'étape suivante écrit
dans l'index ; on ne mélange pas une installation à du travail en cours.

## 1. Poser les deux dossiers

```sh
git remote add hal https://github.com/quebecstudio/hal-9001.git
git fetch hal
git checkout hal/main -- workflow/core workflow/README.md workflow/instructions.md .claude
git reset
```

Les chemins sont nommés un par un, et pas `workflow` en entier : le reste de
`workflow/` — blueprints, backlog, dettes, notes, scripts de jalon — est le
**travail** du dépôt amont, pas le kit. `setup.sh` crée ces dossiers vides à
l'arrivée.

`git reset` sort les fichiers de l'index sans y toucher : on les relit avant de
commiter.

Ce `checkout` apporte les procédures, dans `.claude/skills/` : `/question`,
`/idee`, `/bug`, `/amendement`, `/cadrage`, `/chantier`, `/abandon`, `/relais`,
`/reprise`.
Il n'y a rien
d'autre à installer pour elles — une skill est découverte par sa seule présence.
Vérifie qu'elles sont bien arrivées, et dis-le.

Il n'apporte **pas** `.claude/settings.json` : le réglage se fabrique à l'arrivée,
à l'étape suivante. `.claude/` transporte ce qui se copie, pas ce qui se produit.

**Si l'un des deux dossiers existait déjà**, ne lance pas le `checkout` tel quel.
Un fichier déjà rempli qu'on écrase est une perte sèche. Montre d'abord :

```sh
git diff hal/main -- workflow/core workflow/README.md workflow/instructions.md .claude
```

Puis descends au fichier : `git checkout hal/main -- <chemin>` accepte un
chemin précis. Prends ce qui manque, laisse ce qui existe, et liste au
développeur les fichiers où l'amont et le projet diffèrent vraiment. Le cas
courant est un `.claude/` déjà présent pour d'autres raisons : on y ajoute
`skills/`, on ne remplace pas le dossier.

Ne copie rien d'autre. `documentation/` reste dans le dépôt de la méthode.

## 2. Lancer le script d'installation

Tout ce qui est mécanique tient dans un script, idempotent — relancé, il ne
touche à rien de ce qui est déjà en place :

```sh
bash workflow/core/scripts/setup.sh
```

Il crée les dossiers manquants avec leur `.gitkeep`, complète `.gitignore` et
`.gitattributes`, pose la ligne de statut et son fichier d'état, liste les
procédures présentes, et **termine par ce qu'il ne sait pas faire** : les
sections en blanc, la constante de dépôt, les fichiers racine absents. Cette
dernière liste est ta feuille de route pour la suite.

**Propose de le lancer.** Le dialogue de permission demandera l'accord du
développeur, et cet accord est exactement l'autorisation qui manque pour écrire
dans les réglages. Si l'exécution t'est refusée malgré tout, ne contourne pas :
demande-lui de la lancer lui-même en tapant, dans sa saisie,

```
! bash workflow/core/scripts/setup.sh
```

Le préfixe `!` exécute la commande dans la session, et sa sortie te revient.

Rapporte ensuite ce que le script a listé sous « ce qui reste ».

## 3. Les fichiers racine

`CLAUDE.md` et `AGENTS.md` ne portent qu'un renvoi vers `workflow/` : un seul
endroit fait autorité.

**S'ils existent déjà, tu les ajustes — tu ne les écrases pas.** Ce sont souvent
les fichiers les plus travaillés du dépôt, et ce qu'ils contiennent a été écrit
pour une raison que tu ne connais pas. Alors :

- ajoute le renvoi près du début, là où il sera lu ;
- ne retire rien de ta propre initiative, ne réordonne rien, ne reformule rien ;
- ce qui **décrit le projet** — architecture, pile, conventions — a sa place
  dans `workflow/instructions.md`, pas ici. Recopie-le à l'étape 4, puis
  **propose** de l'ôter d'ici, en montrant les lignes concernées. Le
  développeur tranche. Tant qu'il n'a pas répondu, le texte reste aux deux
  endroits : un doublon se voit, une suppression non demandée ne se voit pas ;
- si une consigne existante **contredit** la méthode, ne tranche pas : signale la
  contradiction au développeur, cite les deux textes, et attends. C'est le seul
  cas où l'installation s'arrête sur une question de fond.

S'ils n'existent pas, crée-les sur le modèle de ceux du dépôt de la méthode : le
nom du projet, une phrase sur ce qu'il est, le renvoi. Rien d'autre.

Le renvoi lui-même dépend de l'agent. Pour celui qui lit les imports :

```
Lire `workflow/core/cycle.md` et `workflow/README.md` avant tout chantier.

@workflow/core/methode.md
@workflow/instructions.md
@workflow/instructions.local.md
```

Pour les autres, la même chose en clair : « Lire `workflow/core/methode.md` et
`workflow/instructions.md` avant tout travail et s'y conformer ; lire aussi
`workflow/instructions.local.md` s'il existe. »

## 4. Demander comment on travaille ici

Quatre questions, et pas une de plus. Chacune change un comportement vérifiable
de l'agent ; une question dont la réponse ne change rien est du temps volé.
**Pose-les avec l'interface de choix si tu en as une** — `AskUserQuestion` sous
Claude Code : ce qu'on lit dans un paragraphe se saute, ce qu'on clique se
prend. Sinon, en options écrites, chacune avec ce qu'elle implique.

**Les réponses ne créent aucun fichier.** Elles remplissent des sections qui
existent déjà, et c'est la condition pour que ce questionnaire serve à quelque
chose : un réglage rangé à part est un réglage que personne ne relit.

1. **Seul, ou à plusieurs sur ce dépôt ?** À plusieurs, la révision est une
   lecture par quelqu'un d'autre, le blueprint transmet à qui n'était pas là, et
   la frontière entre `instructions.md` et `instructions.local.md` compte. Seul,
   la révision reste — on se relit à froid — mais le plan sert surtout de
   mémoire, et le fichier local n'a plus grand sens.
2. **Le test précède-t-il le code ici ?** La méthode ne l'impose que pour un
   défaut : le test qui le reproduit s'écrit d'abord. Ailleurs, c'est au projet
   de dire, et la réponse va dans les Conventions.
3. **L'agent peut-il travailler sans surveillance sur une issue bornée ?** Oui,
   et une issue peut tourner seule, le commentaire de livraison et la PR faisant
   la vérification. Non, et l'architecte suit le travail pendant qu'il se fait,
   pour l'arrêter au premier détour. Il n'y a pas de bonne réponse universelle :
   elle dépend du domaine, du risque et de ce qu'on a déjà vu l'agent produire.
4. **Ces réponses valent-elles pour l'équipe, ou pour toi ?** Ce qui vaut pour
   l'équipe va dans `workflow/instructions.md`, versionné. Ce qui n'appartient
   qu'à un poste va dans `workflow/instructions.local.md`, hors Git. Poser la
   question une fois évite d'imposer à tous une préférence personnelle.

Écris les réponses sous **Règles du projet** — sauf la deuxième, qui va dans
**Conventions** — en une ligne chacune, à l'impératif. Puis montre ce que tu as
écrit et fais-le valider.

## 5. Remplir ce que la copie laisse en blanc

C'est la moitié qu'on oublie, et c'est celle qui demande de te lire le dépôt.
Tant que ces sections sont vides, tu inventeras — et différemment chaque fois.

**Commence par ce qui est déjà écrit.** Un projet existant a souvent accumulé
l'architecture, la pile et les conventions dans `CLAUDE.md`, dans un
`CONTRIBUTING.md`, dans un README. Ce texte-là a été relu et corrigé par des
humains : il vaut mieux que ce que tu déduirais du code. Reprends-le, quitte à
le réorganiser sous les sections de `workflow/instructions.md`, et ne scanne que
ce qui manque encore. Signale au passage ce que tu y trouves de **démenti par le code** — un
framework dont la version a bougé, une convention qui ne tient plus.

Puis, pour ce qui reste, parcours le dépôt et **propose** une version sans
l'écrire encore :

- `workflow/instructions.md`, section **Règles du projet** — les règles de
  conduite qui ne valent que sur ce dépôt : ce qu'on ne lance pas soi-même, ce
  qui demande l'accord du développeur, ce qu'une contrainte d'outillage
  interdit. Une règle qui vaudrait partout n'est pas là : elle remonte à la
  méthode.
- section **Architecture** — comment le dépôt est organisé, ce qui parle à quoi,
  les frontières qu'on ne traverse pas.
- section **Pile** — langages, frameworks, bibliothèques, versions exactes,
  telles que les fichiers de dépendances les donnent. Puis les lanceurs de
  tests avec leurs **commandes exactes** : les tests ciblés d'un fichier, et la
  suite complète. **La CI se déduit du dépôt** — `.github/workflows/`,
  `.gitlab-ci.yml`, `Jenkinsfile`, et `setup.sh` te dit ce qu'il a vu. Deux
  choses ne se déduisent pas et se demandent : la commande qui lit ses
  résultats, et si elle fait autorité pour fermer un chantier.

  **S'il n'y en a aucune, ne la réclame pas.** Beaucoup de projets vivent sans,
  et longtemps. Tu peux suggérer celle qui irait avec la forge et la pile — des
  actions GitHub sur un dépôt GitHub, par exemple — en disant ce qu'elle
  coûterait ; le développeur tranche, et « aucune, la suite locale fait foi »
  est une réponse complète, à écrire telle quelle dans la Pile.
- section **Conventions** — nommage, structure d'un fichier, forme d'un test,
  style de commentaire, formateur.
- `workflow/README.md`, section **Commandes** — les commandes exactes de
  l'outil de suivi. Ce fichier et `instructions.md` sont les deux seuls que le
  projet remplit ; tout ce qui est sous `workflow/core/` vient de l'amont et ne
  se modifie pas.
- **La bibliothèque de forge** — voir ci-dessous ; il n'y a de décision à
  prendre que si la forge n'est pas GitHub.
- **Le dépôt visé**, dans `workflow/repo.sh` que
  `setup.sh` a créé depuis le remote `origin`. Fais confirmer la valeur : un
  remote peut pointer un fork alors que les issues vivent en amont. Ce fichier
  vit hors de `core/`, et sa place le dit : l'amont ne le porte pas, donc une
  mise à jour ne peut jamais l'écraser.

Décris ce que tu **observes**, y compris ce qui a l'air d'une mauvaise habitude :
c'est au développeur de dire ce qu'on ne veut plus faire. Attends sa correction
avant d'écrire.

### La bibliothèque de forge

Le dépôt en livre une, `workflow/core/scripts/lib/forge.sh`, en bash. **Le
langage de l'outillage est imposé, la forge ne l'est pas** — et c'est la seule
chose à vérifier ici.

Bash est exigé au même titre que `git` : la méthode demandait autrefois de
porter la bibliothèque dans le langage du projet, et livrait donc deux
implémentations de la même forge. Celle qu'on croyait vivante portait un défaut
fatal que personne n'avait vu, parce que personne ne l'exécutait. Une seule
bibliothèque, exécutée par tous les projets, vaut mieux que deux dont chacune a
la moitié des yeux. Et bash ne s'installe pas : Git for Windows le livre là où
il pourrait manquer, macOS et Linux l'ont d'origine.

Le fichier livré parle à GitHub par `gh` — c'est ce que cette implémentation-là
exige du poste, et rien d'autre. Le transport ne fait pas partie du contrat.

**Si la forge n'est pas GitHub** — GitLab, Azure DevOps, Jira, autre chose —,
`forge.sh` est à réécrire, **sous le même nom, contre le même contrat**. Rien
d'autre ne bouge : ni le gabarit de script de milestone, ni le dépôt visé.
L'implémentation choisit alors ses outils — `glab`, du `curl` — et déclare ce
dont elle a besoin. Trois choses te disent quoi écrire :

- le **contrat** de l'annexe D — les neuf fonctions et leurs formes de retour ;
- les **garanties** — les cinq conditions de correction, chacune née d'un échec
  payé, à relire une par une avant la première exécution ;
- le **contrat de la forge** — les cinq capacités qu'elle doit porter. Si l'une
  manque, dis-le avant d'écrire une ligne : c'est une limite de la méthode sur
  cette forge, pas un détail d'implémentation.

Écris-la pour **bash 3.2**, celui que macOS livre encore : pas de tableaux
associatifs, qui sont de bash 4. Le gabarit de script montre comment s'en
passer.

Et **dis-le comme une dette, pas comme un livrable**. Une bibliothèque qui n'a
jamais parlé à l'API est juste sur le papier ; elle s'éprouve au premier script
de milestone, qui est relu avant d'être exécuté. Consigne-la dans `debts/` si le
dossier existe.

## 6. L'outil de suivi

Rapporte l'état, ne le change pas : les étiquettes par défaut à retirer, celles
du projet à poser, l'existence des types de tâche — sur GitHub ils se définissent
au niveau de l'organisation, pas du dépôt — et la disponibilité des dépendances
entre tâches. Ce ménage se fait dans le premier script de milestone, qui est relu
et commité.

## 7. Commiter

Un commit, une fois que le développeur a validé le contenu des sections :

```
Workflow : la méthode est posée sur le dépôt
```

Le corps dit ce qui a été rempli, et ce qui est resté en blanc faute d'information.

## Ce que tu ne fais pas

- Tu n'écris pas toi-même dans les réglages de l'agent : `setup.sh` s'en charge,
  et c'est le développeur qui l'autorise en approuvant son exécution.
- Tu n'écrases aucun fichier existant sans l'avoir montré et fait valider.
- Tu ne pousses pas, tu ne fusionnes pas.
- Tu n'écris pas de blueprint. Le premier chantier porte la première vraie
  fonctionnalité, jamais l'amorçage.
- Tu ne remplis pas une section en devinant. Une section vide se signale ; une
  section fausse se propage.

## Pour finir

Dis en cinq lignes : ce qui est posé, ce qui est rempli, ce qui reste en blanc
et pourquoi, ce que le développeur doit lancer lui-même, et ce qui a résisté.
