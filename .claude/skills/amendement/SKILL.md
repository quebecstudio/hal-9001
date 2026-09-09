---
name: amendement
description: Consigne un changement sur l'issue ou le blueprint visé, en tête et daté, sans réécrire le corps original. C'est le mot-clé « Amendement : » de la méthode.
disable-model-invocation: true
argument-hint: [ce qui change]
---

## Ce qui change

$ARGUMENTS

## Le statut des blueprints

!`grep -H '^status:' workflow/blueprints/*.md 2>/dev/null || echo "(aucun blueprint)"`

## La date du jour

!`date +%F`

## Où on en est

!`cat workflow/etat.local.md 2>/dev/null || echo "(pas de fichier d'état)"`

## Ce qu'il faut faire

**S'entendre d'abord.** Reformule ce que tu as compris du changement et
attends. Un amendement mal compris se consigne pourtant, et le document ment
ensuite avec autorité.

**Puis consigner, avant qu'une ligne parte dans l'autre sens.** L'ordre est la
règle : le document est mis à jour d'abord, le code ensuite. Un amendement
écrit après coup n'est plus un amendement, c'est une justification.

### Où il se pose

Le statut ci-dessus décide, et c'est la seule question qui compte :

- **Blueprint `Proposé`** — il est encore mutable. Ce n'est pas un amendement :
  on corrige le corps directement. Dis-le plutôt que de poser un bloc inutile.
- **Blueprint `Accepté`** — l'amendement se pose **en tête**, daté de la date
  ci-dessus, et dit sa conséquence. Le corps original n'est jamais réécrit :
  c'est ce qui permet de lire, des mois plus tard, ce qui avait été décidé et ce
  qui ne décrit plus le code.
- **Issue ouverte** — un commentaire d'issue, même contenu.
- **Pièce fermée, `Remplacé par` ou `Abandonné`** — on n'amende pas ce qui est
  clos. L'amendement devient une entrée de backlog : bascule sur `/idee` et
  dis-le.

### La forme du bloc

Suis celle qui existe déjà dans les blueprints du dépôt. Elle tient en trois
choses : la date, ce qui change, et ce que le lecteur du corps original doit
désormais considérer comme faux.

## Ce que tu ne fais pas

- Tu ne réécris pas le corps, tu n'en retires rien, tu ne le reformules pas.
- Tu ne touches pas au statut : un changement de statut est un commit à lui
  seul, c'est l'information.
- Tu n'écris pas le code que l'amendement rend nécessaire. Il s'annonce à part.
