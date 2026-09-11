# Annexe A — Le dossier `workflow`

[← À plusieurs](12-a-plusieurs.md) · [Sommaire](README.md) · [Annexe B →](B-les-gabarits.md)

Tout ce qui relève de la méthode vit dans un seul dossier : les blueprints, le
backlog, les dettes, les notes, les scripts de chantier, et les fichiers de
règles. Un nouveau venu, humain ou agent, n'a qu'un dossier à ouvrir pour
comprendre comment le projet se conduit.

Un second l'accompagne, `.claude/`, versionné lui aussi. **La séparation est
celle de la lecture : `workflow/` se lit, `.claude/` s'applique.**

## L'arborescence

```
workflow/
  core/                        # tout ce qui vient de HAL 9001, et rien d'autre
    methode.md                 # les règles de travail
    cycle.md                   # le processus : états, statuts, nommage, voies
    templates/
      tpl-blueprint.md
      tpl-backlog.md
      tpl-debt.md
      tpl-issue.md
      tpl-milestone-script.sh
      tpl-handoff.md           # le passage de relais entre deux sessions
      tpl-report.md            # le rapport d'un agent délégué
      tpl-commit.md            # la forme des messages de commit
    scripts/
      setup.sh                 # pose tout ce qui est mécanique
      statusline.sh            # étape, chantier, issue, branche, contexte, modèle
      lib/forge.sh             # la forge : contrat de l'annexe C, GitHub par gh
  README.md                    # les commandes de la forge et les pièges d'ici
  instructions.md              # règles du projet, architecture, pile, conventions
  instructions.local.md        # préférences d'un développeur, hors Git
  handoff.md                   # le passage de relais en cours, hors Git
  etat.local.md                # l'étape courante, hors Git
  repo.sh                      # le dépôt visé ; hors de core/, une mise à jour ne l'écrase pas
  milestones/
    0001-fondations.sh         # un script par blueprint, même numéro, même slug
  blueprints/
    0001-fondations.md         # un blueprint par fonctionnalité, numéro = jalon
  backlog/                     # propositions sans numéro, Proposé ou Accepté
    delivered/                 # réalisées par un ou plusieurs blueprints
    abandoned/                 # écartées, conservées pour ce qui a voyagé
  debts/                       # une dette par fichier, préfixée du blueprint
    settled/                   # remboursées, avec la référence du blueprint
  notes/                       # documentation technique qui n'est pas une décision
```

```
.claude/
  settings.json                # ligne de statut et garde ; produit par setup.sh, pas livré
  hooks/
    garde-poussee.sh           # refuse merge, gh pr merge, et tout push hors de dev/<slug>
  skills/                      # les neuf procédures
    question/  idee/  bug/  amendement/  attention n'en a pas
    cadrage/  chantier/  abandon/  relais/  reprise/
```

Les noms de dossiers sont une proposition, pas une exigence. Ce qui compte est
qu'il existe un endroit unique pour les plans, un pour les propositions en
attente, un pour les dettes, et que les scripts vivent à côté des plans qu'ils
réalisent.

## Le kit et le travail

La frontière traverse `workflow/`, et elle décide de ce qui se propage.

| | Ce que c'est | Ce qui arrive à une mise à jour |
|---|---|---|
| `workflow/core/` et `.claude/` | **Le kit.** Il vient de l'amont, un projet ne l'écrit pas. | Aligné par `setup.sh --update`. |
| `workflow/README.md`, `instructions.md` | Livrés **en blanc**, remplis par le projet. | Jamais écrasés. |
| `blueprints/`, `backlog/`, `debts/`, `notes/`, `milestones/` | **Le travail** du projet. | Jamais touchés — l'installation ne les copie même pas. |

C'est pourquoi l'installation nomme ses chemins un par un plutôt que de copier
`workflow` en entier : sans cela, les blueprints et le backlog du dépôt amont
partiraient dans chaque projet installé.

## Ce qui reste hors Git

Tout le dossier est versionné, à deux exceptions : ce qui n'appartient qu'à un
développeur, et ce qui ne sert qu'à passer d'une session à la suivante.

```gitignore
workflow/instructions.local.md
workflow/handoff.md
workflow/*.local.md
```

La troisième ligne couvre `etat.local.md` et d'avance tout fichier local qu'une
équipe ajouterait sur le même modèle. **Rien d'autre n'est exclu** : les
blueprints, le backlog, les dettes, les notes et les scripts sont précisément ce
qui doit durer et se partager.

## Numérotation

`NNNN-titre-en-kebab.md`, compteur à quatre chiffres, **jamais réutilisé**.

Le numéro suit l'ordre d'exécution des chantiers : le jalon `M0008` correspond
au blueprint `0008`, et son script à `milestones/0008-….sh`. Un plan rédigé mais
non exécuté ne réserve donc pas de numéro.

Les dettes portent le numéro du blueprint qui les a créées, en préfixe. Les
entrées de backlog n'ont pas de numéro et se citent par leur chemin.

## Le README du processus

`workflow/README.md` porte ce que **seul ce dépôt** peut dire de sa forge : les
commandes exactes — créer un jalon, une issue, une dépendance, fermer un jalon —
et les pièges qu'on a payés ici. S'il y a une CI, la commande qui lit ses
résultats sur une PR.

Il est livré en blanc. Le processus lui-même — le cycle, les statuts, le
nommage, les voies — est dans `core/cycle.md`, et ne se recopie pas.

---

[← À plusieurs](12-a-plusieurs.md) · [Sommaire](README.md) · [Annexe B →](B-les-gabarits.md)
