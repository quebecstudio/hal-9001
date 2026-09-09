# Instructions du projet

<Ce que les outils ne peuvent pas savoir de ce dépôt-ci. Les règles de travail
qui valent partout sont dans `methode.md`, qui vient du kit et ne se modifie
pas ici. Ce qui n'appartient qu'à un développeur va dans
`instructions.local.md`, qui ajoute sans contredire.>

## Règles du projet

<Les règles de conduite qui ne valent que sur ce dépôt : ce qu'on ne lance pas
soi-même, ce qui demande l'accord du développeur, ce qu'une contrainte
d'outillage interdit. Les règles qui valent partout sont dans `methode.md` et
ne se recopient pas ici.>

## Architecture

<Comment le dépôt est organisé, où vivent les modules, ce qui parle à quoi,
les frontières qu'on ne traverse pas. Ce que les outils ne peuvent pas savoir.>

## Pile

<La pile est libre — n'importe quel langage, n'importe quels outils. **La forme
de cette section ne l'est pas** : les règles de la méthode s'appuient dessus
pour savoir quoi lancer, et une prose se lit différemment d'un projet à l'autre.
Les clés ci-dessous sont obligatoires. Une clé sans objet s'écrit quand même,
avec sa raison — « aucune », jamais un blanc, qui se lit comme un oubli.

Chaque valeur qui est une commande s'écrit **exacte et copiable**, entre
backticks. « On lance vitest » n'est pas une commande. Un agent qui ne trouve
pas la commande ici ne l'invente pas : il s'arrête et la demande.>

**Langage** · <versions exactes, telles que les fichiers de dépendances les donnent>
**Paquets** · <le gestionnaire, un par langage>

<Puis une surface par bloc. Une surface est un périmètre qu'on peut tester seul :
le serveur, le client, le navigateur. Les nommer est ce qui permet à une issue
de ne lancer que la sienne — « suite complète » veut dire toutes les suites.>

**Surface <nom>** · <l'outil>
  ciblé · `<la commande pour un fichier>`
  suite · `<la commande pour toute la surface>`

**Formateur** · `<la commande>`
**CI** · <l'outil et ce qu'il lance, et **s'il fait autorité pour fermer un
chantier** — ou « aucune, la suite locale fait foi ». La commande qui lit ses
résultats va dans les Commandes du README. S'il n'y en a pas encore, c'est le
cas courant au début : elle s'ajoutera comme n'importe quel travail, et cette
section se met à jour dans le même commit que la configuration.>

<Ce que les clés ne couvrent pas se dit en dessous, en prose : frameworks,
bibliothèques notables, ce qu'un outil de l'écosystème génère et tient à jour.>

## Conventions

<Nommage, structure d'un fichier, forme d'un test, style de commentaire,
formateur. Généré ou tenu à jour par les outils de l'écosystème.>
