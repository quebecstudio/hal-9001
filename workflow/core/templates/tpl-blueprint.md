---
blueprint: NNNN
title: <Titre court de la fonctionnalité>
status: Proposé   # Proposé | Accepté | Remplacé par NNNN | Abandonné
proposé: AAAA-MM-JJ
accepté:  # à remplir au passage du statut ; une ligne par transition franchie
milestone: # à remplir une fois créé, ex. "M0012 — Titre court"
backlog: # chemin de l'entrée de backlog d'origine, s'il y en a une
---

# Blueprint NNNN — <Titre>

## Contexte

<Le problème, les contraintes, pourquoi maintenant. Les éléments de domaine
non évidents depuis le code. Ce que les blueprints antérieurs ont déjà tranché
et qui ne se rediscute pas ici.>

## Ce qu'on sait avant de planifier

<Ce que le cadrage a trouvé en regardant, avant qu'un plan existe. Quelques
lignes par bloc : c'est un sommaire, pas une étude. Ce qui manque ici se
redécouvre à chaque issue, et différemment chaque fois.>

**Ce que la tâche demande** — <paquet à installer, API à appeler, code existant
à réutiliser, fonctionnalité dont s'inspirer, croquis à suivre. Le chemin ou le
lien, jamais le contenu.>

**Périmètre** — <ce qu'on touche, ce qu'on ne touche pas. En sortir est
exactement le geste qui demande qu'on s'arrête et qu'on redemande.>

**Impacts** — <ce que le reste du système ressent : ce qui appelle ce qu'on
change, les surfaces voisines, et **les tests existants qui vont bouger**. C'est
d'ici que sortent les tests à ajuster ; la section Tests, plus bas, ne dit que
ceux à créer.>

**Pièges connus** — <ceux du README du processus qui touchent ce chantier, et ce
que ce coin du code a déjà fait payer.>

## Décision

<Ce qu'on fait, en une dizaine de points au plus. Au-delà, c'est deux
fonctionnalités.>

### Modèle de données

<Tables, colonnes, relations, index — ou N/A.>

### Flows

<Parcours, séquences, cas limites — ou N/A.>

### Surface API / UI

<Routes, écrans, composants, commandes — ou N/A.>

### Choix techniques

<Bibliothèques, patterns, ce qui vient des instructions du projet et n'a pas
à être répété ici.>

### Sécurité

<Quelles données personnelles, qui a le droit de quoi, ce qui ne doit jamais
sortir. Ces réponses deviennent des critères d'acceptation.>

## Alternatives considérées

<Chaque option écartée, et **la nature de la raison qui l'écarte** : un fait —
mesure, contrainte technique, comportement observé —, une règle du cahier ou
d'un blueprint antérieur, ou un jugement non vérifié. Les trois sont
recevables ; seule la troisième doit se dire comme telle, parce qu'elle seule
peut être fausse sans qu'on s'en aperçoive.>

- **<A>** — écartée, fait : <ce qu'on a mesuré ou observé>
- **<B>** — écartée, règle : <laquelle, et où elle est écrite>
- **<C>** — écartée, jugement non vérifié : <ce qu'on croit, et ce qui le
  confirmerait>

<L'option la moins chère se traite en premier. Écartée par un jugement non
vérifié, et si l'éprouver coûte moins qu'une issue, elle s'éprouve avant qu'on
propose l'acceptation : le résultat remplace alors le jugement. Sinon le
jugement reste, et remonte dans les Risques sous son nom.>

## Conséquences

- **Positives :**
- **Négatives / coûts :**
- **Risques :** <y compris les jugements non vérifiés qui ont écarté une option,
  repris de la section précédente : ce sont eux qui font abandonner un chantier
  à mi-parcours.>

## Ce que ce blueprint ne tranche pas

<Ce qui est laissé à un autre chantier, et par quelle porte.>

## Découpage en issues

<Moins de vingt lignes. Chaque issue : une session de travail qui finit par
un commit et des tests verts.>

| # | Titre | Type | Labels | Bloquée par |
|---|-------|------|--------|-------------|
| 1 | … | feature | backend | — |
| 2 | … | feature | backend | 1 |
| 3 | … | chore | test | 1, 2 |

<Puis les mêmes issues en **vagues**, ce que le tableau ne montre pas : chaque
vague est ce qui peut se prendre une fois la précédente posée, et dit ce qu'elle
établit. Les numéros réels s'y reportent à l'ouverture du chantier.>

| Vague | Issues | Ce qu'elle établit |
|-------|--------|--------------------|
| 1 | … | … |
| 2 | … | … |

<Et l'**ordre recommandé**, en une ligne, avec son motif — tiré du risque, non
du confort. Plusieurs ordres sont presque toujours valides ; celui qu'on
recommande traite en premier ce qui peut faire tomber le chantier.>

## Tests

<Les **comportements à prouver**, un par ligne — pas des noms de fichiers de
test. « Un utilisateur sans droit ne voit pas la fiche d'un autre », et non
« test_acl ». Un comportement se traduit en un test, en trois, ou en aucun s'il
est déjà prouvé ailleurs : c'est en voyant le code qu'on le sait, pas ici.>

- <comportement à prouver>
- <…>
- <la garde, s'il y en a une : le test doit échouer quand on la retire>

<**Cette liste est indicative.** Elle dit ce qu'on croit devoir prouver au
moment du plan, avant d'avoir écrit une ligne. L'agent la bonifie ou l'ignore
selon le travail réellement fait, et **ce qu'il écarte se dit dans le
commentaire de livraison** de l'issue concernée. Pas de cases à cocher ici :
une liste qu'on coche se remplit de tests écrits pour honorer la liste, ce que
la méthode interdit par ailleurs.>

<Puis ce qui ne se déduit pas des comportements : les jeux de données, ce qui se
teste au niveau fonctionnel plutôt qu'unitaire, ce qui demande un navigateur.
Les tests à **ajuster** sont dans « Impacts », plus haut.>

Conditions de complétion :
- [ ] Toutes les issues fermées avec leur commentaire de livraison.
- [ ] Suites complètes vertes — toutes celles que la Pile nomme, et dans la CI
      quand le projet lui donne autorité.
- [ ] Dettes consignées dans `debts/`.
- [ ] PR révisée et auditée.

## Références

- Code : …
- Docs externes : … (avec la date de consultation)
- Blueprints liés : …
- Pièces du cadrage : … (croquis, comparaisons, rangés dans `notes/`)
