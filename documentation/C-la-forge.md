# Annexe C — La forge

[← Annexe B](B-les-gabarits.md) · [Sommaire](README.md) · [Annexe D →](D-la-ligne-de-statut.md)

`workflow/core/scripts/lib/forge.sh` est la bibliothèque que tous les scripts de
jalon importent. Elle est écrite pour GitHub et parle à l'API par `gh`, mais son
**contrat** tient en onze fonctions : c'est ce contrat qu'on réécrit pour une
autre forge, et les scripts ne changent pas.

Le nom du fichier est stable quelle que soit la forge. Elle ne gère aucun
secret : l'authentification est celle du CLI, déjà réglée sur le poste.

> **Tout appel externe passe par elle.** Jamais la commande en direct dans un
> script de chantier.

## Le contrat

Ce que les scripts demandent, et rien de plus. Une implémentation pour GitLab,
Azure DevOps ou Jira expose les mêmes noms avec les mêmes formes de retour.

| Fonction | Ce qu'elle fait | Ce qu'elle rend |
|----------|-----------------|-----------------|
| `listMilestones` | Liste les jalons, tous états confondus. Passe ses options à l'outil. | La réponse de l'API. |
| `findMilestoneByTitle <titre>` | Cherche un jalon par son titre **exact**. | Le **numéro**, ou sort en 1 s'il n'existe pas. C'est la garde d'idempotence. |
| `createMilestone <titre> <description>` | Crée le jalon. | Son numéro. |
| `closeMilestone <numéro> [description]` | Ferme le jalon. La description, facultative, sert à fermer en expliquant pourquoi — c'est là que se raconte un chantier abandonné. | Rien. |
| `upsertLabel <nom> <couleur> [description]` | Crée ou met à jour une étiquette. | Rien. |
| `deleteLabel <nom>` | Supprime une étiquette. Tolère l'absence. | Rien. |
| `createIssue <jalon> <titre> <type> <labels> <corps>` | Crée une tâche rattachée au jalon. | `numéro⇥identifiant` : le numéro pour l'affichage, l'identifiant interne pour les dépendances. |
| `commentIssue <numéro> <corps>` | Ajoute un commentaire. Sert aux commentaires de livraison et aux dérives. | Rien. |
| `closeIssue <numéro> [raison]` | Ferme une tâche. La raison décide de ce que la forge affiche : livrée, ou jamais faite. Par défaut, livrée. | Rien. |
| `block <numéro bloqué> <identifiant bloquant>` | Déclare que la première tâche est bloquée par la seconde. | Rien. |
| `listBlockedBy <numéro>` | Liste ce qui bloque une tâche. Sert à vérifier le câblage après exécution. | La réponse de l'API. |

Le script de jalon n'en importe que quatre : `findMilestoneByTitle`,
`createMilestone`, `createIssue` et `block`. **Une autre forge se porte en
réécrivant ces quatre-là d'abord.**

Toute fonction sort en erreur si l'appel échoue : un script de jalon ne doit
jamais continuer sur un appel raté.

## Les garanties

Le contrat dit les noms et les formes ; celles-ci disent ce qu'une
implémentation doit **assurer** pour être correcte. Chacune vient d'un échec
payé sur GitHub, mais aucune n'en dépend : ce sont des façons dont une forge se
dérobe, et la prochaine s'y dérobera autrement.

Une bibliothèque écrite pour une autre forge ou un autre langage se relit contre
cette liste **avant sa première exécution**.

- **Un corps de texte ne traverse jamais la ligne de commande.** `createIssue`,
  `commentIssue` et `closeMilestone` transportent des paragraphes entiers.
  Passés en argument ou par un heredoc, ils perdent accents et apostrophes, et
  le geste échoue sans le dire — parfois en ne créant rien du tout. Ils passent
  par un fichier, ou l'entrée standard. *Payé quatre fois.*
- **Les types partent tels que la forge les attend.** `block` désigne la tâche
  bloquante par son identifiant interne, et l'envoie comme un **entier**. En
  chaîne, l'API répond en nommant la propriété, jamais le type : on cherche
  alors du côté de la valeur, qui est juste.
- **Après une écriture, on relit l'objet, pas la liste.** Une liste retarde :
  une tâche fermée à l'instant y figure encore, et un script qui vérifie son
  propre travail conclut qu'il a échoué, puis refait. Là où la liste est le seul
  chemin — `findMilestoneByTitle`, puisque aucune forge n'indexe les jalons par
  leur nom — le retard est un risque connu.
- **Ce que la forge ne sait pas dire se signale.** Certaines propriétés ne sont
  pas lisibles là où on les pose : le type d'une tâche se définit au niveau de
  l'organisation, et le dépôt répond 404 quand on le lui demande. La fonction
  échoue en le disant, plutôt que de rendre une valeur par défaut qui ferait
  passer pour vérifié ce qui ne l'a pas été.
- **Aucun repli sur une valeur d'exemple.** Le dépôt visé vient de
  `workflow/repo.sh`, hors du kit ; s'il manque, l'import échoue bruyamment. Un
  repli silencieux créerait les tâches d'un chantier dans le vide, et personne ne
  s'en apercevrait avant de les chercher.

## Trois pièges consignés dans le fichier

Ils sont écrits **au point d'appel**, là où ils se déclenchent, et l'essentiel
de la bibliothèque est en commentaires pour cette raison.

- **La garde d'idempotence compare le titre à l'exact.** Renommer un jalon est
  sans danger pour la forge, fatal pour le script : il ne le retrouve plus et en
  crée un second. C'est pourquoi un chantier abandonné garde son titre, et dit
  son abandon dans sa description.
- **L'identifiant d'une dépendance n'est pas le numéro affiché**, et il doit
  partir comme un entier. En chaîne, l'API répond 422 sans que rien d'autre ne
  le signale.
- **Fermer une tâche sans dire pourquoi la fait afficher comme livrée.** Un
  chantier abandonné devient alors indistinguable d'un chantier réussi.

## Le contrat du transport

Le transport — `gh`, `glab`, du `curl` — ne fait pas partie du contrat, mais il
n'est pas libre pour autant. Cinq choses doivent rester possibles :

- **envoyer un paramètre typé**, entier contre chaîne ;
- **passer un texte long** sans le faire traverser la ligne de commande ;
- **lire la réponse** et y accéder par nom de champ, sans écrire un parseur ;
- **distinguer l'échec du succès**, et rendre le message de l'API avec lui — un
  422 qui passe pour un succès fait continuer un script sur un câblage absent ;
- **s'authentifier** sans qu'un secret entre dans le dépôt.

> **Pourquoi bash, alors que le shell avait été écarté.** L'argument tenait :
> bash ne sait ni produire du JSON typé ni manipuler du Markdown multi-ligne
> sans un échappement manuel dont chaque oubli est silencieux. Ce qui a changé
> n'est pas le langage : c'est que la bibliothèque **ne produit plus de JSON du
> tout**. Elle délègue les cinq points ci-dessus à l'outil de forge, dont `-F`
> type les paramètres, `-F champ=@fichier` passe les textes longs et `--jq` lit
> les réponses avec un moteur embarqué. Ni `curl` ni `jq` à installer.
>
> Le dépôt s'en tient à **une seule** bibliothèque. La méthode a longtemps
> invité à la porter dans le langage du projet, et en livrait donc deux pour la
> même forge : celle qu'on croyait vivante portait un défaut fatal que personne
> n'avait vu, faute de l'exécuter, tandis que le portage jamais lancé était
> juste. Une bibliothèque exécutée par tous vaut mieux que deux dont chacune a
> la moitié des yeux.
>
> Elle est écrite pour **bash 3.2**, celui que macOS livre encore. Un script qui
> emploie les tableaux associatifs de bash 4 fonctionne sur le poste où on
> l'écrit et échoue partout ailleurs, avec un message qui ne nomme pas la cause.

## Le contrat de la forge

Les deux contrats précédents disent ce que la bibliothèque expose et ce que le
transport doit savoir faire. Celui-ci dit ce que **la plateforme** doit porter —
et il manquait : la méthode répétait que l'outillage se remplace par ses
équivalents, sans jamais nommer ce qui n'est pas remplaçable.

Cinq capacités. Les quatre premières sont des objets, la cinquième est un lieu —
et c'est elle qui décide.

- **Des tâches**, avec un état ouvert ou fermé, et une **raison** de fermeture.
  La distinction entre livré et jamais fait n'est pas cosmétique : c'est elle
  qui rend un chantier abandonné lisible des mois plus tard.
- **Des jalons qui les regroupent, cherchables par titre exact.** La garde
  d'idempotence repose dessus. Une forge qui n'indexe pas ses jalons par nom
  oblige à tenir une correspondance ailleurs, et cette correspondance sera
  fausse un jour.
- **Un lien « bloquée par », réel et interrogeable.** Pas une convention de
  texte : le script le pose, et doit pouvoir le relire pour vérifier son propre
  travail.
- **Des commentaires horodatés attachés à une tâche.** C'est là que vivent le
  commentaire de livraison et les dérives convenues.
- **Un lieu de révision, sur un diff, où la vérification automatique répond.**
  La plus dure à remplacer, et la seule qui ne soit pas un objet de suivi. Une
  forge qui n'a pas d'équivalent ramène la révision à un `git diff` lu à deux,
  sans trace et sans checks — et c'est l'étape que la méthode protège le plus.

GitLab, Azure DevOps et Jira portent les cinq, sous d'autres noms. **Un dossier
de fichiers dans le dépôt porte les quatre premières — et pas la cinquième.**
C'est la raison pour laquelle la méthode suppose une forge plutôt qu'un fichier
plat, et non un attachement à GitHub.

## Porter la bibliothèque ailleurs

Ce qui change d'une forge à l'autre, et qu'il faut vérifier avant d'écrire une
ligne :

- **Ce qui tient lieu de jalon.** Le titre doit rester cherchable.
- **Ce qui tient lieu de dépendance.** Un lien réel, interrogeable.
- **Ce que renvoie la création d'une tâche.** Certaines API rendent une clé
  plutôt qu'un numéro. Ce qui compte est que `block` reçoive la forme attendue.
- **Le type de tâche.** Champ natif chez GitHub, il devient un type de work item
  ailleurs, ou une étiquette quand la forge n'en a pas.

Le premier chantier d'un projet sur une nouvelle forge est le bon moment pour
écrire cette bibliothèque : on la teste sur un vrai découpage, et ses pièges
rejoignent le `README` du processus.

---

[← Annexe B](B-les-gabarits.md) · [Sommaire](README.md) · [Annexe D →](D-la-ligne-de-statut.md)
