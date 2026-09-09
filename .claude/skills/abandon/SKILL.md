---
name: abandon
description: Ferme un chantier auquel on renonce, en conservant ce qui permettra de savoir plus tard pourquoi. C'est la seconde sortie du cycle, à côté de la fusion.
disable-model-invocation: true
argument-hint: [pourquoi on renonce]
---

## Pourquoi on renonce

$ARGUMENTS

## Où on en est

!`cat workflow/etat.local.md 2>/dev/null || echo "(pas de fichier d'état)"`

!`git status --short --branch`

## Le statut des blueprints

!`grep -H '^status:' workflow/blueprints/*.md 2>/dev/null || echo "(aucun blueprint)"`

## La date du jour

!`date +%F`

## Ce qu'il faut faire

**L'abandon se décide, il ne se propose pas.** Si le développeur n'a pas dit
qu'il renonce, arrête-toi et demande — c'est la seule chose à faire ici.

Un chantier abandonné n'est pas un échec à cacher. Ce qui compte est qu'on
puisse savoir, des mois plus tard, pourquoi on avait renoncé, et retrouver le
travail déjà fait. Le principe qui décide de tout le reste : **chaque pièce dit
la vérité sur elle-même, et le récit du chantier vit dans la description du
milestone.**

### Dans l'ordre

1. **Établir ce qui a été livré.** Les issues fermées avec un commentaire de
   livraison le sont pour de bon ; les autres ne se feront pas. Liste les deux
   groupes et fais-les confirmer avant de toucher à quoi que ce soit.
2. **Fermer les issues jamais faites** avec la raison « non planifié » —
   `closeIssue(numéro, "not_planned")`. Sans la raison, la forge les affiche
   comme complétées, et un chantier abandonné devient indistinguable d'un
   chantier réussi.
3. **Laisser les issues livrées en « complété ».** Leur travail existe, il est
   commité : les dire non planifiées effacerait ce qui a été fait.
4. **Fermer le milestone en amendant sa description** —
   `closeMilestone(numéro, description)`. En tête : qui, quand, pourquoi, où le
   problème a migré s'il a migré, et **le nom de la branche** où le travail vit.
   Sans ce nom, le travail devient introuvable.
   **Ne touche pas au titre** : la garde d'idempotence des scripts cherche par
   titre exact, et un « (abandonné) » ajouté ferait recréer le milestone à la
   prochaine exécution du script.
5. **Passer le blueprint à `Abandonné`**, avec en tête où ses idées ont voyagé.
   Le corps n'est jamais réécrit.
6. **Laisser la branche**, non fusionnée. Elle porte le travail livré.
7. **Rendre l'entrée de backlog au backlog**, statut `Proposé`, amendée de ce
   que la tentative a appris. Abandonner un chantier n'est pas abandonner
   l'idée : une solution surdimensionnée ne dit rien du besoin, qui tient
   toujours. `abandoned/` est pour l'idée qu'on renonce à poursuivre.
8. **Écrire l'état** : `Repos`, si `workflow/etat.local.md` existe.

## Ce que tu ne fais pas

- Tu ne supprimes rien — ni la branche, ni les issues, ni le milestone. Un
  abandon qui efface ses traces empêche de savoir plus tard pourquoi on avait
  renoncé.
- Tu ne renommes pas le milestone.
- Tu ne réécris pas le corps du blueprint.
- Tu n'exécutes aucun appel à la forge sans l'avoir annoncé et attendu la
  réponse : fermer une issue avec la mauvaise raison se corrige, mais seulement
  si quelqu'un s'en aperçoit.
