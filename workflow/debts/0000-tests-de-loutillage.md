---
title: L'outillage n'a aucune suite de tests
blueprint: 0000        # hors chantier
date: 2026-09-09
kind: provisoire
---

# L'outillage n'a aucune suite de tests

## Ce qui a été fait, à la place de quoi

Trois défauts de l'outillage ont été corrigés — `signale()` appelée avant sa
définition dans `setup.sh`, le corps d'issue tronqué par `read` dans
`tpl-milestone-script.sh`, la garde tenue pour branchée dès qu'une clé `hooks`
existe. Chacun a été prouvé par une exécution de session : un poste privé d'un
outil, un corps d'issue de quatorze lignes avec tableau Markdown, deux
`settings.json` portant une clé `hooks` avec et sans la garde.

Ces exécutions ne sont conservées nulle part. À la place d'une suite qui les
rejoue, il n'y a que ce fichier.

La Pile de `workflow/instructions.md` ne déclare aucune surface de test, donc
aucune commande à lancer. La méthode interdit d'y suppléer par un script de
vérification jetable ; elle demande cette dette.

## Pourquoi

Les trois défauts partagent une cause unique : **rien n'exécute l'outillage**.
Aucun d'eux n'était visible à la lecture, et tous trois sont apparus à la
première exécution. Deux vivaient dans le chemin critique depuis l'origine.

Installer un framework et écrire ces tests est un chantier à part entière — il
demande de choisir l'outil, de déclarer la Pile, de poser une CI ou de décider
qu'il n'y en a pas. Le faire dans le même geste que trois correctifs aurait
mélangé une réparation et une décision d'architecture.

## Ce que ça coûte tant que ça dure

Les trois correctifs peuvent régresser sans que personne le voie : ils sont
justes aujourd'hui, et rien ne le vérifiera demain. Le coût réel n'est pas le
défaut connu, c'est le prochain — l'outillage est du bash sans filet, et sa
partie la plus dangereuse est celle qui crée dans un système externe et
qu'aucun revert ne défait.

Le dépôt demande par ailleurs qu'un défaut se prouve avant d'être réparé et
qu'une garde porte un test qui échoue quand on la retire. Tant que cette dette
court, il exige des projets installés ce qu'il ne s'applique pas.

## Ce qui déclenche le remboursement

Le premier chantier qui touche à `setup.sh`, à `forge.sh` ou au gabarit de
script de jalon. Ces trois fichiers ont déjà montré qu'ils échouent en silence ;
les rouvrir sans filet, c'est repayer.

## Ce qu'il faudrait pour rembourser

Un framework qui exécute du bash — `bats` est le candidat évident, il
s'installe sans dépendance lourde et tourne là où le kit tourne. Puis déclarer
la surface dans la Pile, avec ses deux commandes, ciblée et suite.

Les comportements à prouver, tels qu'ils se posent aujourd'hui :

**`setup.sh`**
- Un outil absent du poste est signalé, et le script poursuit jusqu'au bilan.
- Le compteur `reste` retient ce qui a été signalé avant le bilan.
- Une clé `hooks` étrangère à la garde est signalée comme telle.
- Une clé `hooks` qui porte la garde ne déclenche aucun signalement.
- Un `settings.json` absent reçoit la ligne de statut et la garde.
- Relancé sur un dépôt complet, le script ne modifie rien.
- Une clé `statusLine` qui pointe un script inexistant est signalée.
- Le bilan compte les sections encore entre chevrons, et pas le chapeau des
  fichiers.

**`tpl-milestone-script.sh`**
- Un corps d'issue de plusieurs lignes arrive entier à `createIssue`.
- Un corps contenant des `|`, des accents et des apostrophes arrive intact.
- Un corps non défini arrête le script en nommant la variable attendue.
- Une dépendance est câblée avec l'identifiant interne de la bloquante et le
  numéro de la bloquée.
- Le jalon déjà existant fait sortir le script sans rien créer.

**`forge.sh`** — contre les garanties de l'annexe C, avec une forge bouchonnée.
- `findMilestoneByTitle` sort en 1 sur un titre absent, et rend le numéro sur un
  titre exact.
- Un titre portant un tiret cadratin et des espaces se compare correctement.
- `createIssue` rend `numéro⇥identifiant`.
- `closeIssue` sans raison ferme en « complété ».
- L'absence de `workflow/repo.sh` fait échouer l'import, bruyamment.

**`garde-poussee.sh`**
- `git push`, `git merge` et `gh pr merge` sont refusés.
- Les options intercalées — `git -C dir push`, `git --no-pager merge` — sont
  refusées aussi.
- Une commande qui contient le mot sans être le geste n'est pas refusée.
- La garde porte un test qui échoue quand on la retire : c'est la règle du
  cahier, et c'est la seule contrainte réelle de la méthode.

**`statusline.sh`** — les cas limites sont déjà tabulés à l'annexe D, ils se
reprennent tels quels.

Ordre de grandeur : un chantier court. Le gros du travail est le choix de
l'outil et les bouchons de forge, pas les assertions.

## Règlement

<À remplir à la fermeture.>
