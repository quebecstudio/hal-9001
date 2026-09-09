# 05 — Le cadrage

[← Le cahier](04-les-instructions.md) · [Sommaire](README.md) · [Suivant : Le blueprint →](06-le-blueprint.md)

Le cadrage n'est pas la discussion d'équipe. Celle-ci a lieu **avant**, entre
humains — avec le client, le chargé de projet, les collègues — et elle produit
des constats et des décisions. Le cadrage est ce qui vient ensuite : on passe
ces constats à l'agent, pour qu'il en ait la même compréhension que nous avant
d'écrire quoi que ce soit.

Ça commence par une conversation, pas par un document. L'agent reformule, pose
des questions, relève ce qui manque ou ce qui contredit l'existant. Plusieurs
allers-retours suivent.

C'est la première des deux étapes qui refusent la confiance aveugle. Celui qui
improvise tape une phrase et regarde ce qui sort. Ici, rien ne sort tant que les
deux parties ne peuvent pas décrire la même chose : **l'agent ne reçoit pas une
commande, il reçoit une compréhension partagée.**

## Ce qu'on cherche à établir

- **Le problème**, dit avec les mots du domaine, et pourquoi il se pose
  maintenant.
- **Le périmètre** : ce qui entre dans cette fonctionnalité, et ce qui
  appartient à une autre. C'est ici qu'un sujet trop large se coupe en deux. Le
  périmètre sert ensuite tout le travail : c'est à lui que se réfère la règle
  « annoncer, et attendre quand le geste engage ».
- **Les contraintes de l'existant** : une table qu'on ne peut pas casser, une
  règle métier en place, une décision d'un blueprint antérieur.
- **Les inconnues** : ce qui ne peut pas se décider sans un tiers, un essai ou
  une donnée qu'on n'a pas.
- **Ce qui touche à la sécurité** : quelles données personnelles, qui a le droit
  de quoi, ce qui ne doit jamais sortir. Ces réponses deviennent des critères
  d'acceptation, pas des vœux.
- **Ce que le backlog en dit déjà.** L'agent lit les idées consignées et signale
  celles qui touchent au sujet. Une idée oubliée qui revient sous un autre nom
  est le gaspillage le plus courant.

## Ce qu'on met sur la table

Le cadrage ne se fait pas de mémoire. On y apporte des pièces, et on les
**donne** à l'agent au lieu de les lui décrire.

- **Croquis et maquettes** : un écran dessiné à la main, un flux sur un tableau
  blanc, une capture d'un produit dont on veut s'inspirer.
- **La définition venue du cahier des charges** : le passage exact convenu avec
  le client, plutôt qu'un souvenir. C'est la pièce qui borne le périmètre.
- **Des exemples** : une fonctionnalité comparable ailleurs, un extrait de code
  qu'on aime ou qu'on ne veut surtout pas reproduire.
- **Les briques imposées** : la documentation d'une API à consommer, la
  bibliothèque à employer, le service avec lequel le chantier doit parler.
- **Des éléments à analyser** : deux bibliothèques à départager, un jeu de
  données, un journal d'erreurs. L'agent examine et rend compte **avant** le
  blueprint, et son analyse alimente la section des alternatives.

> **Un échantillon de données réelles s'anonymise avant d'être donné à
> l'agent.** Un export contient souvent des noms, courriels, adresses,
> identifiants. Ce qu'on donne à un agent quitte le poste, et peut être conservé
> hors du cadre auquel ces personnes ont consenti. On remplace les valeurs par
> des valeurs fictives de même forme, ou on fabrique l'échantillon avec les
> factories du projet.

## Ce que le cadrage rend

Quatre blocs courts, et c'est ce qui nourrit la suite :

1. **Ce que la tâche demande** — paquet, API, code à réutiliser, fonctionnalité
   dont s'inspirer, croquis. Le chemin ou le lien, jamais le contenu.
2. **Le périmètre** — ce qu'on touche, ce qu'on ne touche pas.
3. **Les impacts** — ce qui appelle ce qu'on change, et **les tests existants
   qui vont bouger**.
4. **Les pièges connus** — ceux du `README` du processus qui touchent ce travail.

Vers un blueprint, ils deviennent sa section « Ce qu'on sait avant de
planifier ». En voie courte, ils vont dans l'issue. Ce qui change d'une voie à
l'autre est **où ils atterrissent**, pas s'ils existent.

## Quand le cadrage s'arrête

Quand le développeur et l'agent peuvent chacun résumer la fonctionnalité en
quelques phrases, et que les deux résumés disent la même chose. L'agent propose
alors la voie — hors chantier, courte ou chantier — avec le motif tiré des
[trois mesures](03-le-cycle.md#les-trois-voies), et **le développeur tranche**.

Un blueprint rédigé sur une compréhension floue se réécrit trois fois, et chaque
réécriture emporte des sections déjà validées.

Le cadrage lui-même **n'est pas conservé** : ce qu'il a produit passe dans le
blueprint, qui en est la conclusion. Une nuance qui mérite de survivre a sa
place dans la section Contexte du plan.

Procédure : `/cadrage`. Elle retire les outils d'écriture pour le tour — un
cadrage ne produit rien qu'une décision.

---

[← Le cahier](04-les-instructions.md) · [Sommaire](README.md) · [Suivant : Le blueprint →](06-le-blueprint.md)
