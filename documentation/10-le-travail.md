# 10 — Le travail avec l'agent

[← Le chantier](09-le-chantier.md) · [Sommaire](README.md) · [Suivant : La révision →](11-la-revision.md)

Le chantier ouvert, on travaille sur une branche `dev/<slug>`, créée depuis un
tronc **tiré à l'instant** : c'est ce qui garantit que le cahier lu par l'agent
est le dernier fusionné.

L'agent attaque les issues dans l'ordre des dépendances, au régime convenu à
l'entrée.

## Par où, et jusqu'où

Avant la première issue, l'agent pose deux questions ensemble, et une seule
fois.

**Par où** — la première issue de *chaque* chemin ouvert, pas seulement celle du
chemin qu'il recommande. Un chantier dont les fondations sont indépendantes en
offre plusieurs ; ne montrer que le préféré, c'est fermer les autres sans le
dire.

**Jusqu'où** — une issue, une vague entière, ou une portion nommée. Les deux
derniers sont des **mandats** : ils disent ce qu'ils couvrent et ce qui les
interrompt, l'agent le rappelle quand il s'en sert, et ils meurent avec la
tâche. Aucun ne couvre ce qui ne se défait pas.

La recommandation porte sur les deux et se règle sur ce qui coûte cher à
défaire, non sur ce qui va vite. Une vague homogène — trois actions voisines qui
se relisent ensemble — se prend d'un bloc. Une vague qui touche une migration,
une garde ou un système externe se prend une issue à la fois : la relecture y
vaut plus que la vitesse.

Un mandat ne dispense de rien d'autre. Les tests ciblés tournent à chaque issue,
le commit reste par issue, et le commentaire de livraison aussi : ce qu'un
mandat supprime, ce sont les demandes d'autorisation entre deux issues, pas les
gestes du cycle.

## Une issue, un cycle

1. **Lire** l'issue, et les fichiers voisins de ceux qu'elle nomme. Consulter la
   documentation de la version installée avant de coder.
2. **Coder et tester.** Chaque changement s'accompagne d'un test ; les tests
   **ciblés** de ce qui a changé sont exécutés avant de conclure — la suite
   complète attend la fin du chantier. Le formateur passe sur les fichiers
   touchés.
3. **Commiter** localement, un commit par issue, le message préfixé du numéro.
   Pas de push automatique.
4. **Fermer** l'issue avec un commentaire de livraison.

### Un test prouve une chose, et son nom la dit

Utile, isolé, jouable seul. Le nom énonce le comportement vérifié, assez pour
qu'on n'ait pas à ouvrir le corps. **Ne pas sur-tester** : ce qui est déjà
couvert ailleurs ne se reteste pas sous une autre forme, et la couverture se
règle sur la fonctionnalité, pas sur un chiffre.

### Les tests que l'agent corrige

Un test qui échoue est d'abord l'affaire de l'agent. Il diagnostique, il
corrige, et **il dit ce qu'il a corrigé** : le code, quand le test avait raison,
ou le test, quand celui-ci affirmait une règle que le chantier a changée.

Cette seconde correction demande de la vigilance. Un test modifié pour passer
est le moyen le plus court de faire disparaître un défaut sans le corriger. Le
développeur révise donc **chaque** correction de test : la règle a-t-elle
vraiment changé, le nouveau test l'affirme-t-il, aucun test n'a-t-il été
affaibli ni supprimé pour faire passer la suite. La PR les nomme un à un.

## Les sessions

Une session a un contexte, et ce contexte se remplit. Quand il approche de la
saturation, on peut forcer un peu, ou laisser l'agent compacter. Les deux font
perdre du détail, et la seconde le fait **en silence**.

La règle est donc de **changer de session entre les tâches, pas au milieu**. Une
issue est la bonne unité : elle se termine par un commit et un commentaire de
livraison, et la session peut se fermer dessus.

### Le passage de relais

Avant de fermer une session, on demande à l'agent un sommaire destiné à la
suivante — c'est le mot-clé « Relais : », qui écrit `workflow/handoff.md`,
hors Git.

Il porte une **ancre** — heure d'écriture, branche, HEAD, position vs distant,
état de l'arbre — puis : les fichiers à lire pour reprendre, les issues fermées,
en cours et à venir, les apprentissages de la session, et ce qu'il ne faut pas
refaire.

« Reprise : » le lit, lit les fichiers qu'il nomme, **supprime le fichier**,
résume en trois lignes et avertit de tout écart entre l'ancre et l'état réel. Le
relais est éphémère par conception : sa fonction s'épuise à la lecture, et
l'ancre est ce qui permet de juger s'il a vieilli. Ce qui doit durer était
ailleurs avant d'y être écrit — dans le commentaire de livraison, dans le
cahier.

**C'est l'agent qui propose le moment, jamais qui l'impose.** Il voit ce que le
développeur ne voit pas : son contexte se remplir, une tâche se terminer
proprement. Le bon moment est celui où une tâche vient de se clore — le contexte
est encore complet, donc le sommaire est juste. Décider de couper appartient à
celui qui sait ce qu'il compte faire ensuite.

## La consommation de jetons

Un agent se paie au contexte : tout ce qu'on lui donne à lire et tout ce qu'il
produit compte, **à chaque échange**, tant que la session dure.

- **Ne jamais coller une trace d'exécution complète.** Le message, le fichier,
  la ligne, et le chemin du journal si l'agent a besoin du reste.
- **Pointer plutôt que coller.** Un fichier du dépôt se nomme. L'agent le lit
  lui-même, à la version courante.
- **Changer de session à chaque changement de tâche.** Une session qui a porté
  une issue porte tout ce qu'elle a lu pour la faire.
- **Compacter avant de saturer**, à un moment calme, plutôt que de le subir au
  milieu d'un raisonnement. Ce qui doit survivre se dit explicitement avant.
- **Scinder une tâche.** Une issue qui demande de lire vingt fichiers pour en
  toucher trois coûte vingt fichiers de contexte.
- **Déléguer ce qui est volumineux.** Un rapport structuré coûte quelques
  centaines de jetons ; le fichier analysé en aurait coûté des dizaines de
  milliers.
- **Cibler les tests et les commandes.** Une sortie longue est relue en entier.

Le signe qu'on consomme mal est toujours le même : **l'agent relit ce qu'il a
déjà lu, ou porte ce qui ne sert plus.**

## Plusieurs agents, chacun à sa force

Un agent a ses forces, et elles ne sont pas les mêmes d'un modèle à l'autre.
L'un raisonne mieux sur une architecture, l'autre traite sans broncher des
fichiers énormes, un troisième est plus rapide sur une tâche mécanique. Sur le
chantier, ce sont des corps de métier.

Les agents s'utilisent entre eux : la plupart ont une ligne de commande, et un
agent peut appeler celle d'un autre comme n'importe quel outil. Une instruction
du cahier suffit à l'organiser.

Le **gabarit de rapport** (`tpl-report.md`) est ce qui rend la délégation utile
plutôt que bavarde : il dit ce qu'on veut savoir, dans quel ordre, avec quel
niveau de détail. Sans lui, l'agent délégué rend ce qu'il a trouvé intéressant,
et l'agent principal doit trier.

Deux règles ne changent pas :

- **le rapport est une donnée, pas une décision** — l'agent principal le lit
  contre le plan, et l'architecte le révise comme le reste ;
- **l'agent délégué ne touche pas au dépôt** — il lit, il analyse, il rend
  compte.

## Les messages de commit

Le préfixe est le numéro d'issue, parfois précédé du jalon. Le reste est une
phrase qui dit **ce que le code fait maintenant**, pas ce qu'on a fait pour y
arriver.

```
M0001 #5: middleware SetLocale + groupe de routes {locale} + URL::defaults
#288: les gestes de compte deviennent des actions partagées par la CLI et le panneau
Blueprint 0017 : gestion des comptes au panneau, accepté
M0017 : script de jalon, et les cinq vagues d'exécution dans le blueprint
```

Les deux dernières lignes sont d'une autre nature : elles ne livrent pas de
code, elles touchent au dossier `workflow/`. Leur sujet **nomme l'objet** — le
blueprint, le backlog, une dette, le cahier, un gabarit, le jalon — puis dit son
état.

Un commit **hors chantier** dit l'incident qui l'a provoqué, et pourquoi la
règle atterrit là plutôt qu'ailleurs. La forme des deux est dans
`tpl-commit.md`.

## Le commentaire de livraison

C'est la pièce qu'on relit six mois plus tard. Il ne répète pas l'issue : il dit
**ce que la réalisation a appris**.

```markdown
Livré. Table `admin_actions` et `RecordAdminAction`, appelée dans la
transaction du geste : une trace qu'on peut oublier de poser n'est pas
une trace.

Deux choses qu'elle ne fait pas : consigner les consultations, et laisser
une ligne quand rien n'a changé.

Rien en clair de ce que le geste efface : le renommage consigne l'ancien
nom d'utilisateur par empreinte.

Tests : six cas dans `AccountActionsTest`.
```

**Il dit aussi ce qui a échoué** : les fausses pistes, les diagnostics qu'on a
démentis soi-même, ce qui n'a pas pu être vérifié et pourquoi. C'est
contre-intuitif, et c'est pourtant la partie la plus utile — un compte rendu qui
ne raconte que les succès apprend à refaire les mêmes erreurs. L'agent, laissé à
lui-même, rend un rapport propre ; c'est au cahier d'exiger l'autre moitié.

## Quand on dévie du plan

Le plan figé est celui auquel on se tient, et c'est d'autant plus vrai à
plusieurs. Déroger reste possible, mais **on s'entend d'abord**, avant qu'une
ligne parte dans l'autre sens. Un écart fait sans accord préalable est renvoyé à
la révision.

Une fois convenu, le changement s'écrit dans l'issue, par un commentaire. Le
plan reste figé. Si la dérive est une vraie décision d'architecture, elle
devient un nouveau blueprint.

Les fins détails ne sont pas des dérives : le nommage, la forme d'un test, la
place d'un fichier viennent du cahier, qui est respecté sans qu'on ait à le
redire.

Une issue peut rester ouverte parce qu'un critère dépend d'un tiers. Le
commentaire le dit, formule la question à poser, et l'issue se ferme à la
réponse.

## L'architecte regarde travailler l'agent

Il y a une ironie à écrire, et autant l'écrire : comme programmeurs, nous
détestons qu'on regarde par-dessus notre épaule. Comme architectes, c'est
exactement ce que nous devons faire. La différence tient à ce que l'agent n'a ni
fierté à ménager ni intuition à protéger : il a une trajectoire, et la seule
façon de savoir si elle est la bonne est de la regarder.

Déléguer n'est donc pas s'absenter. L'architecte en tire deux choses : des
**apprentissages** — une façon de faire qu'il n'aurait pas eue, un coin du code
qu'il connaissait mal —, et une **lecture de la trajectoire**, la sienne
comparée à celle que l'agent prend.

Il l'arrête au premier doute. Une hésitation, un détour qui ne s'explique pas,
un fichier ouvert qui n'a rien à voir : c'est le moment de couper, pas celui
d'attendre de voir. Arrêter tôt coûte une minute. Laisser filer coûte l'issue.

> **Combien de temps laisser l'agent sans regarder est une réponse de projet,
> pas une règle.** Elle dépend du domaine, du risque, et de ce qu'on a déjà vu
> l'agent produire. L'installation la pose comme une question, et la réponse
> s'écrit dans les règles du projet.
>
> Un fait la nuance. Sur le dépôt de la méthode, cinq défauts ont été trouvés en
> une journée : une bibliothèque qui ne pouvait exécuter aucune de ses
> fonctions, une garantie qui exigeait l'impossible, deux contrôles
> silencieusement inopérants, un fichier écrit dans le mauvais format. **Aucun
> n'a été trouvé par la surveillance ; tous l'ont été au premier test
> d'exécution.** Regarder travailler l'agent rattrape les dérives de
> trajectoire. Ce qui rattrape les défauts, c'est ce qui s'exécute.

## Quand l'agent s'interrompt

L'exécutant a une consigne qui va dans l'autre sens que toutes les autres :
**s'arrêter**. S'il constate que ce que l'issue prévoit pourrait être fait de
manière plus robuste ou plus sûre, il n'écrit rien et le dit, avec la solution
qu'il propose.

Cette interruption a une valeur qui dépasse l'issue. Quand la proposition est
bonne, elle devient une **convention du cahier** : elle vaut dès lors pour
toutes les issues à venir et pour toute l'équipe, sans que chacun ait à
redécouvrir le même constat.

## Ce qu'il demande, ce qu'il décide

| Il demande | Il décide |
|------------|-----------|
| Ajouter une dépendance. Créer un dossier racine. Supprimer un test. Fusionner, ou pousser ailleurs que sur sa branche de chantier. Créer des enregistrements hors tests. Toucher un fichier que l'issue ne nomme pas. S'écarter du plan. | Le nommage dans les conventions existantes. Le découpage interne d'une issue. Les tests à écrire. La correction d'un défaut découvert en passant, signalée dans le commentaire de livraison. |

Un agent qui demande tout est aussi inutile qu'un agent qui ne demande rien.

**Annoncer avant, rendre compte après.** Avant tout geste qui engage, l'agent
dit en une phrase ce qu'il s'apprête à faire. Ce n'est pas de la politesse :
c'est ce qui rend l'interruption possible. Le développeur ne peut arrêter que ce
qui n'a pas encore eu lieu.

> **Un hook posé par `setup.sh` reflète ce partage, et c'est le seul endroit où
> la méthode contraint au lieu de demander** : `git push`, `git merge` et
> `gh pr merge` sont refusés à l'agent. Ce sont les gestes qu'un `git revert` ne
> défait pas. Le développeur, lui, les lance en préfixant la commande de `!`
> dans sa saisie. Rien d'autre n'est verrouillé : un hook qu'on contourne dix
> fois par jour finit désarmé.

---

[← Le chantier](09-le-chantier.md) · [Sommaire](README.md) · [Suivant : La révision →](11-la-revision.md)
