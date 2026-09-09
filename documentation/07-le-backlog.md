# 07 — Le backlog

[← Le blueprint](06-le-blueprint.md) · [Sommaire](README.md) · [Suivant : Les dettes →](08-les-dettes.md)

Des idées arrivent pendant qu'on travaille sur autre chose. Elles ne doivent pas
interférer avec le chantier en cours, mais ne pas les consigner, c'est les
perdre. Le backlog est l'endroit prévu : une entrée dans `workflow/backlog/`, au
statut *Proposé*.

## Une entrée n'est pas un blueprint

C'est le point de départ d'un futur cadrage. Elle a donc son propre gabarit,
plus court : le problème ou l'envie, l'idée en quelques lignes, pourquoi elle
vaudrait la peine, ce qu'elle toucherait, les questions ouvertes.

**Assez pour rouvrir la conversation six mois plus tard, pas plus.**

## On la détaille sans quitter le travail en cours

Une idée qui surgit au milieu d'une issue se dicte en quelques phrases. L'agent
la met en forme, la dépose, la commite, et le chantier reprend où il était. Rien
n'est décidé, mais rien n'est oublié.

C'est ce que fait le mot-clé « Idée : », et sa procédure `/idee` pré-approuve
le dépôt et le commit — restreints à `workflow/backlog/`. S'arrêter pour
demander l'autorisation de commiter casserait précisément ce que le mot-clé
protège.

## Deux états, aucun numéro

*Proposé* : consignée, pas tranchée. *Accepté* : décidée, elle attend seulement
son cadrage et son chantier.

Aucune des deux n'a de numéro : le numéro appartient au blueprint, et le
blueprint n'existe pas encore. Les références citent une entrée **par son
chemin**, jamais par un numéro.

Le jour où l'idée passe par un cadrage, le blueprint qui en sort prend le
prochain numéro libre, cite l'entrée, et celle-ci descend dans `delivered/`.

| Emplacement | Ce qu'on y trouve |
|-------------|-------------------|
| `backlog/` | Ce qui attend encore, et qu'on peut ouvrir en chantier. |
| `backlog/delivered/` | Ce qui a été réalisé, par un ou plusieurs blueprints qui le citent. |
| `backlog/abandoned/` | Ce qui ne sera pas fait dans cette forme. Le document reste, avec en tête ce qui a été livré ailleurs. |

**Rien n'est supprimé.** Un fichier déplacé casse les liens qui le citent, et
ces liens sont repris dans le même commit, y compris dans des plans clos.

## Pourquoi pas un simple fichier d'idées

Beaucoup tiennent un `IDEAS.md`, une note dans un carnet, une liste dans l'outil
de suivi. Ça garde les idées, et c'est mieux que rien. Ce que ça ne fait pas,
c'est les rendre **utilisables par un cadrage futur**, surtout celui d'un
collègue.

Une entrée par fichier, avec un gabarit, un statut et un chemin stable, permet
trois choses qu'une liste ne permet pas :

- l'agent la lit au cadrage et la signale — personne ne redécouvre une idée
  déjà consignée ni n'en ouvre une en double ;
- un blueprint la cite par son chemin — on sait d'où vient une décision ;
- n'importe qui peut la bonifier en passant, y ajouter un constat, une
  contrainte, un lien.

Une idée dans une liste appartient à celui qui l'a notée. Une idée dans le
workflow appartient au projet.

## Le backlog est lu à chaque cadrage

Avant d'écrire un blueprint, l'agent parcourt les idées et signale celles qui
touchent au sujet. Une idée *acceptée* et liée entre dans le cadrage. Une idée
seulement *proposée* est mentionnée, et l'architecte tranche sur-le-champ : on
l'approuve et elle entre, ou elle reste au backlog.

C'est ce qui empêche le fichier d'idées de devenir un cimetière.

---

[← Le blueprint](06-le-blueprint.md) · [Sommaire](README.md) · [Suivant : Les dettes →](08-les-dettes.md)
