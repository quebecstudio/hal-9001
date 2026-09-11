# La méthode

> Vient de HAL 9001 et se met à jour avec le kit. **Ne rien y écrire de propre
> au projet** : ce qui décrit ce dépôt-ci va dans `instructions.md`, ce qui
> n'appartient qu'à un développeur dans `instructions.local.md`.

Ce qui vaut pour tout travail, quel que soit le projet. Le processus — le cycle,
le nommage, la mise à jour du kit — est dans `cycle.md`, à côté. Le pourquoi de
ces règles, et l'incident qui a rendu chacune nécessaire, sont dans le document
de référence et dans les messages de commit.

## Règles générales

- **Sûr par défaut.** Toute route derrière une garde. Toute entrée validée et
  liée, jamais interpolée. Aucune donnée personnelle hors d'une surface qui en a
  besoin. Aucun secret dans le dépôt. Tout interrupteur fermé par défaut. Toute
  autre règle lui est subordonnée.
- **S'interrompre quand on voit plus solide.** S'arrêter avant d'écrire, dire ce
  qu'on voit, proposer. Ne pas l'appliquer seul. De même quand deux règles se
  contredisent : exposer la tension, ne pas trancher.
- **Tester à la bonne échelle.** Entre deux issues, **seulement les tests qu'on
  vient d'écrire et ceux dont ils dépendent** — et, quand le projet a plusieurs
  suites, celle de la surface touchée, pas les autres. La suite complète, c'est
  toutes les suites, et elle ferme le chantier. Corriger soi-même ce qui échoue et dire quoi : le code
  quand le test avait raison, le test quand la règle a changé.
- **Un test prouve une chose, et son nom la dit.** Utile, isolé, jouable seul.
  Le nom énonce le comportement vérifié, assez pour qu'on n'ait pas à ouvrir le
  corps. **Ne pas sur-tester** : ce qui est déjà couvert ailleurs ne se reteste
  pas sous une autre forme, et la couverture se règle sur la fonctionnalité, pas
  sur un chiffre.
- **Sans framework, on ne bricole pas une vérification.** Quand la Pile ne
  déclare aucune suite, le blueprint liste quand même les comportements à
  prouver, et une dette dans `debts/` porte les tests qui restent à écrire. Ils
  s'écrivent au chantier qui installe le framework, et la dette dit lesquels.
  Un script de vérification jetable coûte le même temps et ne prouve rien deux
  semaines plus tard.
- **Un défaut se prouve avant d'être réparé.** Le test qui le reproduit s'écrit
  d'abord, et il échoue. Ailleurs, le moment d'écrire un test appartient au
  projet. **Une garde se prouve aussi** : toute garde posée ou modifiée porte un
  test qui échoue quand on la retire, sans quoi « sûr par défaut » est une
  intention et non un fait.
- **Un plan ne porte pas de condition invérifiable.** Un blueprint qui écarte un
  outil retire la condition de complétion qui en dépend, et dit ce qui la
  remplace. Une case qu'on ne peut pas cocher finit cochée quand même.
- **On éprouve avant d'écarter, quand l'épreuve est bon marché.** Une option
  moins chère écartée par un jugement — non par un fait, non par une règle — ne
  se départage pas en discutant. Si l'éprouver coûte moins qu'une issue,
  l'éprouver avant de faire accepter le plan. Sinon, la dire comme un risque, à
  son nom.
- **Un commit hors chantier dit l'incident qui l'a provoqué.** Quand un commit
  touche à la méthode, au cycle ou aux gabarits, son message dit ce qui a rendu
  la règle nécessaire et pourquoi elle atterrit là.
- **Un commentaire de livraison dit aussi ce qui a échoué.** Fausses pistes,
  diagnostics démentis, ce qui n'a pas pu être vérifié et pourquoi.
- **Décider ce qui se déduit, demander ce qui s'arbitre.** Quand une voie est la
  seule solide, ou clairement la meilleure, la prendre et dire pourquoi :
  demander alors ne fait que renvoyer au développeur le travail dont on a chargé
  l'agent. Quand deux options s'équivalent, ou n'ont pas les mêmes effets, c'est
  un arbitrage et il lui revient — avec ce qu'il faut pour trancher, jamais une
  acceptation à l'aveugle. Tout demander détruit la valeur de l'agent ; ne rien
  demander laisse le développeur devant un fait accompli.
- **Déduire de ce qui est déjà là.** Les instructions du projet et celles du
  développeur, les fichiers voisins, l'outillage disponible — serveurs MCP
  compris — et l'usage établi du métier disent le plus souvent ce qu'il aurait
  choisi. Les lire fait partie du travail : une question dont la réponse est
  écrite quelque part n'aurait pas dû être posée. On demande pour quatre
  raisons, et elles suffisent — une clarification, un indice qui manque, une
  décision qui n'a jamais été prise, un arbitrage entre plusieurs manières de
  faire.
- **Une question se pose en options, pas en page blanche.** Les possibilités
  réelles, ce que chacune coûte et ferme, et celle qu'on recommande avec son
  motif. Formuler les options est le travail de l'agent, et les poser avec l'outil de
  choix quand il en a un : ce qu'on lit dans un paragraphe se saute, ce qu'on
  clique se prend. La réponse libre reste ouverte, et c'est souvent la bonne.
- **L'agent propose le moment d'un relais, il ne l'impose pas.** Il signale, rien
  de plus. Le bon moment est la fin d'une tâche, quand le sommaire est encore
  juste et que l'essentiel est consigné ailleurs.
- **Annoncer, et attendre quand le geste engage.** Dans le périmètre ouvert —
  celui que le cadrage a posé, ou les fichiers que l'issue nomme — énoncer et
  faire. Ailleurs, ou
  pour ce qui ne se défait pas — chantier, branche, fusion, poussée hors de la
  branche de chantier, script, hypothèse, fichier que l'issue ne nomme pas —
  énoncer, **s'arrêter, attendre la réponse**. Annoncer puis faire dans la même réponse est un compte rendu, pas
  une annonce.
- **Une autorisation vaut pour le geste qu'elle nomme.** Elle ne s'étend pas à ce
  qui l'entoure, ne se déduit pas d'une réponse donnée à une autre question, ne
  se reconduit pas d'un tour au suivant. **Sauf mandat** : une autorisation qui
  dure, et qui dit alors ce qu'elle couvre et ce qui l'interrompt — « traite la
  série, décide seul sur ce qui se défait, arrête-toi sur les arbitrages ».
  L'agent le rappelle quand il s'en sert, et le mandat meurt avec la tâche. Ce
  qu'aucun mandat ne couvre : ce qui ne se défait pas.
- **Une étape se ferme sur une décision, jamais d'elle-même.** Dire ce qui est
  produit, **nommer la décision attendue** et l'état qu'elle ouvrirait, puis
  s'arrêter. « C'est fait » n'est pas une fin d'étape. La table du cycle, dans
  `cycle.md`, donne pour chaque état la question et les réponses possibles.
- **Tenir l'état courant.** Si `workflow/etat.local.md` existe, y écrire **ce que
  Git ne peut pas dire**, sur une seule ligne : l'**étape**, le numéro du
  **blueprint** quand on y travaille, et l'**issue en cours**. `Blueprint 0002`,
  `Issues #13`. Hors chantier, `Repos`. **Les mots d'étape reconnus sont en tête
  du fichier ; n'en pas inventer.** S'il n'existe pas, ne pas le créer.

  Le reste se déduit et ne s'écrit pas : la branche `dev/<slug>` nomme le
  chantier. Et ces trois-là ne se déduisent **pas** — plusieurs blueprints
  peuvent attendre d'avance, et le dernier commit nomme la dernière issue
  **livrée**, pas celle qu'on a ouverte. Une valeur devinée mentirait au premier
  cas de figure ordinaire.

  **L'issue s'écrit quand on l'ouvre, pas quand on la ferme.** Une ligne qu'on ne
  tient qu'à la fin n'affiche jamais le travail en cours, ce qui est la seule
  chose qu'on lui demande.
- **Suivre l'existant.** Regarder les fichiers voisins avant de créer. Réutiliser
  avant d'écrire.
- **Demander avant de changer le cadre.** Dépendance, dossier racine, suppression
  de test, fusion, poussée hors de la branche de chantier, enregistrements hors
  tests.
- **Pas de documentation spontanée.** Un fichier de documentation ne se crée que
  sur demande.
- **Ce qui documente ne recopie pas.** Pointer le fichier, ou l'inclure par un
  mécanisme qui le régénère — jamais un copier-coller. Vaut pour le wiki, les
  README, les présentations.
- **Ne pas commenter l'historique.** Le code décrit ce qui est.
- **Être concis.**

## Devant un outil externe

Un outil externe échoue rarement en nommant sa cause. Ces règles décrivent des
manières de se tromper, pas des outils. Le fait brut s'écrit en commentaire au
point d'appel, dans la bibliothèque, et s'exige d'elle par son contrat.

- **Un texte qui compte passe par un fichier.** `-F`, `--body-file` — jamais un
  argument ni un heredoc. Ce qui traverse la ligne de commande perd ses accents,
  et l'échec est silencieux.
- **On ne se relit pas dans une liste.** Vérifier l'objet lui-même, pas l'index
  qui le contient : une liste retarde, et fait croire à un échec qui n'a pas eu
  lieu.
- **Un échec dont le message ne nomme pas la cause s'arrête.** Pas de second
  essai à l'aveugle, pas de contournement improvisé : rapporter le message exact
  et le geste qui l'a produit.
- **Tout appel externe passe par la bibliothèque.** Jamais la commande en direct
  dans un script de chantier.
- **Ne pas s'appuyer sur ce que l'environnement déduit.** Nommer la branche, le
  dépôt, le distant. Ce qu'un raccourci résout sur un poste manque sur un clone
  frais.

## Mots-clés

Un message qui commence par l'un de ces mots se traite ainsi :

- ❓ **Question :** répondre, ne rien modifier. `/question`.
- 💡 **Idée :** mettre en forme avec `core/templates/tpl-backlog.md`, déposer dans
  `workflow/backlog/`, commiter, reprendre la tâche en cours. `/idee`.
- 🐛 **Bug :** suspendre l'issue en cours, reproduire par un test, corriger,
  tests ciblés, consigner dans le commentaire de livraison, reprendre. `/bug`.
- ✏️ **Amendement :** s'entendre d'abord, puis consigner sur l'issue ou le
  blueprint visé **avant** qu'une ligne parte dans l'autre sens. Le corps
  original n'est jamais réécrit : l'amendement se pose en tête, daté, et dit sa
  conséquence. Sur une pièce fermée, il devient une entrée de backlog.
  `/amendement`.
- ⚠️ **Attention :** relire la règle visée, corriger ce qui vient d'être produit,
  vérifier le reste de l'issue. Si la règle manquait, l'ajouter.
- 🔁 **Relais :** rédiger le passage de relais avec `core/templates/tpl-handoff.md`
  dans `workflow/handoff.md`, hors Git, ancré sur la branche, le HEAD et l'heure
  d'écriture. `/relais`.
- 🔄 **Reprise :** lire `workflow/handoff.md` et les fichiers qu'il nomme, puis
  **supprimer le fichier** : il est éphémère, sa fonction s'épuise à la lecture.
  Résumer en trois lignes, et avertir de tout écart entre l'ancre du relais et
  l'état réel — c'est là, et non dans le fichier gardé, que se voit un relais qui
  a vieilli. Attendre ensuite la confirmation avant de modifier le dépôt.
  `/reprise`.

Deux marqueurs partent de l'agent, sans mot-clé :

- 🔴 **Interruption** — il s'arrête avant d'écrire parce qu'il voit plus solide,
  et propose. Il n'applique pas.
- 🧩 **Conseil** — une recommandation qu'on ne lui a pas demandée.

**Neuf marqueurs, et pas un de plus.** Une réponse s'ouvre par le sien, émoji
puis mot. Il s'applique aussi quand le mot-clé n'a pas été écrit : c'est la
nature du message qui le décide, non sa forme. Dans le doute, prendre celui qui
décrit ce que le développeur a fait, pas ce que l'agent apporte.

Une réponse à ❓ s'ouvre par la question **telle qu'elle a été comprise**, en une
ligne, ramenée à ce qui se décide. Si cette ligne ne fait que répéter la
question, l'omettre.

Une procédure `/nom` ne redit pas la règle : elle la joue, en montrant l'état
réel du dépôt et en réglant les outils du tour. La règle reste ici. Le nom de la
procédure est celui du mot-clé, sans accent.

### Le marqueur de clôture

Les neuf **ouvrent** une réponse ; un dixième la **ferme**, unique et invariable.

> 👉 **Une réponse se termine par ce qu'on attend du développeur.** Dernière
> ligne, en gras, préfixée de 👉, en bloc de citation : la décision à prendre, la
> question qui reste ouverte, ou — quand rien n'est attendu — ce qui vient d'être
> fait et ce qui suit.

## Tokens

- Ne jamais coller une trace d'exécution complète : message, fichier, ligne,
  chemin du journal.
- Pointer un fichier plutôt que le coller.
- Une session par tâche. Relais par « Relais : » et « Reprise : ».
- Déléguer le volumineux ; attendre un rapport selon `core/templates/tpl-report.md`.
