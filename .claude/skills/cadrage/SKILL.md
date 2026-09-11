---
name: cadrage
description: Ouvre le cadrage d'un sujet — ce qu'on a compris, ce que le backlog en dit, et la voie proposée. Rien n'est écrit ; la sortie est une décision.
disable-model-invocation: true
disallowed-tools: Edit, Write, NotebookEdit
argument-hint: [le sujet]
---

## Le sujet

$ARGUMENTS

## Ce que le backlog contient déjà

!`ls workflow/backlog/ 2>/dev/null`

## Les chantiers passés

!`ls workflow/blueprints/ 2>/dev/null`

## L'état du dépôt

!`git status --short --branch`

## L'étape, posée avant le tour

!`f=workflow/etat.local.md; if [ -f "$f" ]; then { grep '^[[:space:]]*#' "$f"; echo Cadrage; } > "$f.tmp" && mv "$f.tmp" "$f" && echo "Cadrage"; else echo "(pas de fichier d'état)"; fi`

## Ce qu'il faut faire

Le cadrage ne produit **aucun fichier du dépôt** : les outils d'édition dédiés
sont retirés pour ce tour. Bash reste, pour lire et interroger — l'historique, la
forge, le code, les dépendances — parce que peser le travail demande de regarder.
Il ne sert pas à écrire. Le cadrage produit deux décisions, et s'arrête sur elles.

### 1. Dire ce qu'on a compris

Reformuler le sujet en ce qui se décide, pas en ce qui a été dit. Nommer les
contraintes déjà posées, ce que les chantiers passés ont tranché et qui ne se
rediscute pas, et **ce que le backlog contient sur le sujet** — une entrée
oubliée qui revient sous un autre nom est le gaspillage le plus courant.

Demander : « est-ce la même chose que toi ? » Tant que la réponse n'est pas oui,
on reste là.

### 2. Poser le périmètre

Ce que le travail touche, et ce qu'il ne touchera pas : fichiers, dossiers,
surfaces. Le nommer avant de peser, parce qu'on ne compte pas des dépendances
sans savoir ce qu'on remue — et parce que c'est à lui que la règle « annoncer,
et attendre » se réfère ensuite, pendant tout le travail.

Le faire valider en même temps que la compréhension : c'est la même question.

### 3. Peser le travail, puis proposer la voie

Trois mesures, indépendantes l'une de l'autre. Les peser en regardant le dépôt,
pas en devinant :

- **Combien de décisions il faut figer** — s'il n'y en a aucune, il n'y a rien à
  écrire dans un blueprint.
- **Si des tâches dépendent d'autres tâches** — c'est ce que le script de
  milestone câble, et sa seule raison d'être.
- **Ce qui ne se défait pas** — ce qui décide de la branche, de la PR et de la
  révision.

Puis proposer **hors chantier**, **courte** ou **chantier**, avec le motif tiré
de ces trois mesures. `core/cycle.md` les décrit.

**Devant une ambiguïté, ne pas trancher et ne pas deviner : aller chercher ce
qui manque.** Lire le code concerné, compter les dépendances réelles, ouvrir le
blueprint qu'on croit voisin. Revenir avec ce qu'on a trouvé, puis poser la
question.

**Poser la question avec l'outil de choix** — `AskUserQuestion` — plutôt qu'en
prose : les voies deviennent des options à cliquer, chacune avec ce qu'elle
coûte et ce qu'elle ferme. Un choix qu'on lit dans un paragraphe se saute ; un
choix qu'on clique se prend. La réponse libre reste possible, et corrige souvent
la question au lieu d'y répondre.

### 4. Rendre le sommaire

Ce que le cadrage a trouvé se rend en quatre blocs courts, et c'est ce qui
nourrit la suite : **ce que la tâche demande** — paquet, API, code à réutiliser,
fonctionnalité dont s'inspirer, croquis —, **le périmètre**, **les impacts** —
ce qui appelle ce qu'on change, et les tests existants qui vont bouger —, et
**les pièges connus**, ceux du README du processus qui touchent ce travail.

Vers un blueprint, ils deviennent sa section « Ce qu'on sait avant de
planifier ». En voie courte, ils vont dans l'issue, sous Objectifs, Fichiers et
Tests. Ce qui change d'une voie à l'autre est où ils atterrissent, pas s'ils
existent.

### 5. Annoncer l'état, une fois la voie retenue

Le développeur tranche, jamais l'agent. Après sa réponse seulement, annoncer
l'état que la voie ouvre — `Blueprint`, `Tâche`, ou `Repos` si c'est hors
chantier — et ce qui vient ensuite.

**L'étape `Cadrage` est déjà posée** — le bloc en tête l'a écrite avant le tour,
sans passer par l'agent. Ce qui reste à écrire est l'étape **suivante**, celle
que la voie retenue ouvre, et elle s'écrit au premier tour outillé : les outils
d'édition sont retirés ici. Ne pas l'annoncer comme faite tant qu'elle ne l'est
pas.
