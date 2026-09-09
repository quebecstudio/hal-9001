---
name: reprise
description: Reprend le chantier laissé par une session précédente en lisant workflow/handoff.md, supprime le fichier, et signale l'écart entre son ancre et l'état réel.
disable-model-invocation: true
allowed-tools: Bash(git status *), Bash(git log *), Bash(git branch *), Bash(rm workflow/handoff.md)
---

## Le passage de relais

!`cat workflow/handoff.md 2>/dev/null || echo "ABSENT"`

## L'état du dépôt maintenant

!`date "+%F %H:%M"`

!`git status --short --branch`

!`git log -1 --format='%h — %s (%ad)' --date=short`

!`cat workflow/etat.local.md 2>/dev/null || echo "(pas de fichier d'état)"`

## Ce qu'il faut faire

Si le relais est `ABSENT`, le dire et s'arrêter : il n'y a rien à reprendre, et
il ne faut surtout pas en inventer le contenu.

Sinon, dans cet ordre :

1. **Lire les fichiers que le relais nomme.** Le blueprint aux sections
   indiquées, les fichiers de code cités, l'issue en cours. Le relais est un
   index, pas le contexte lui-même.
2. **Supprimer `workflow/handoff.md`.** Une fois lu, il n'a plus de raison
   d'être : il ne sert qu'à traverser la frontière entre deux sessions. Ce qui
   devait durer était ailleurs avant d'être écrit ici.
3. **Résumer en trois lignes** : où en est le chantier, ce qui vient ensuite,
   ce qu'il ne faut pas refaire. Ouvrir par l'avertissement d'ancre s'il y en
   a un.
4. **Attendre la confirmation du développeur** avant de modifier le dépôt.

## L'écart d'ancre

Le relais porte une ancre — heure d'écriture, branche, HEAD, distant, arbre.
La comparer à l'état ci-dessus, et **avertir en bloc de citation** dès qu'une
ligne diverge :

- **La branche a changé.** Le dire avant tout le reste : le relais décrit un
  autre travail que celui sous la main.
- **HEAD a avancé.** Donner l'écart en commits — quelqu'un a travaillé depuis.
- **Le délai.** Au-delà de quelques jours, les issues et le distant ont pu
  bouger sans que le relais le sache.
- **L'arbre.** Des modifications non commitées absentes du relais sont soit un
  travail interrompu, soit un reste dont personne ne veut.

Un relais sans ancre est un relais qu'on ne peut pas dater : le signaler comme
tel, et le lire avec la même prudence qu'un relais périmé.

Les issues restent à vérifier auprès de l'outil de suivi, qui fait foi sur ce
que le relais croyait fermé.
