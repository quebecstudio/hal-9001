---
name: chantier
description: Ouvre le chantier d'un blueprint accepté — script de milestone, relecture, exécution, branche de développement.
disable-model-invocation: true
argument-hint: [numéro du blueprint]
---

## Le blueprint visé

$ARGUMENTS

## Les blueprints du dépôt

!`ls workflow/blueprints/ 2>/dev/null`

## Les scripts déjà écrits

!`ls workflow/milestones/ 2>/dev/null`

## L'état du dépôt

!`git status --short --branch`

## Ce qu'il faut faire

**Rien n'est exécuté sans accord.** Ce chemin crée un milestone et des issues
dans un système externe : une erreur ne se défait pas par un `git revert`.
Annonce chaque geste avant de le poser.

### 1. Vérifier que le blueprint est prêt

Le lire. Son statut doit être `Accepté` — un blueprint `Proposé` n'ouvre pas de
chantier, et si c'est le cas, s'arrêter et le dire. Vérifier que son tableau de
découpage tient en moins de vingt lignes et que la colonne « Bloquée par » est
remplie.

Lire aussi ses **Alternatives considérées**. Chaque option écartée doit dire la
nature de sa raison — fait, règle, ou jugement non vérifié. Si l'option la moins
chère est écartée par un jugement non vérifié, s'arrêter et le dire : ouvrir le
chantier est le geste après lequel se tromper coûte cher, et un jugement
s'éprouve avant, pas après.

### 2. Écrire le script

`workflow/milestones/NNNN-kebab-title.sh`, même numéro et même slug que
le blueprint, à partir de `core/templates/tpl-milestone-script.sh`. Lire le gabarit :
c'est lui qui fixe la forme.

Le titre du milestone porte les quatre chiffres du blueprint —
`M0017 — Titre court`, jamais `M17`. Sa description résume ce qu'il livre, de
façon lisible des mois plus tard sans ouvrir le plan, la référence au blueprint
en fin de texte et non à sa place.

Les issues et leurs dépendances viennent du tableau du blueprint, sans rien y
ajouter. Une issue qui manque au tableau manque au plan : le dire plutôt que de
la fabriquer.

### 3. Faire relire

Montrer le script et **s'arrêter**. C'est la seule relecture avant que les
issues existent pour de bon.

### 4. Exécuter, une fois

Après accord seulement. La garde d'idempotence du gabarit protège d'un double
passage, mais elle ne protège pas d'un script faux exécuté une fois.

Reporter dans le blueprint les numéros réels rendus par la sortie.

### 5. Montrer le chemin

Les tâches existent, et leur liste ne dit pas par où commencer. Rendre le graphe
tel qu'il a été câblé — les vagues, chacune nommant ce qu'elle établit —, puis
les ordres de travail valides, puis **celui qu'on recommande et pourquoi**. Le
motif se tire du risque : ce qui peut faire tomber le chantier se traite en
premier, ce qui se prouve sans le reste vient avant ce qui en dépend.

Vérifier le câblage sur la forge avant de le rendre — `listBlockedBy` sur une
tâche au moins. Un graphe dessiné depuis le blueprint plutôt que depuis ce que
la forge porte vraiment donnerait un chemin juste sur un câblage faux.

Puis proposer l'attaque : la première issue de **chaque** chemin ouvert, et le
régime — une issue, une vague, ou une portion nommée. Marquer la recommandation
et son motif. Les deux derniers régimes sont des mandats : dire ce qu'ils
couvrent et ce qui les interrompt. `cycle.md` porte la règle.

### 6. La branche

`dev/kebab-title`, créée depuis `main` tiré à l'instant. L'annoncer avant.

### 7. L'état courant

Si `workflow/etat.local.md` existe, y écrire `Issues` — **l'étape, et elle
seule**. Le chantier se déduit de la branche, l'issue du dernier commit.

## Ce que tu ne fais pas ici

Tu n'écris pas de code. Ouvrir le chantier et prendre la première issue sont
deux gestes distincts, et le second s'annonce à part.
