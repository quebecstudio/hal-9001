# 09 — Le chantier

[← Les dettes](08-les-dettes.md) · [Sommaire](README.md) · [Suivant : Le travail →](10-le-travail.md)

Un jalon par blueprint accepté : c'est le chantier. Même numéro, sur quatre
chiffres, et un titre court : `M0017 — Gestion des comptes`.

Les zéros de tête ne sont pas décoratifs : `M17` ne se retrouve plus par
recherche quand on part du nom de fichier `0017-…`. Sa description est un résumé
de ce qu'il livre, lisible des mois plus tard sans ouvrir le plan, avec la
référence au blueprint **en fin de texte** et non à sa place.

## Le découpage

Le tableau du blueprint donne, pour chaque issue : un titre, un type, des
labels, et la liste des issues qui la bloquent. Moins de vingt lignes — c'est la
mesure d'un chantier tenable.

Trois principes :

- **Les fondations d'abord.** Ce qui n'a aucune dépendance ouvre le chantier :
  un composant partagé, une action métier, une colonne.
- **Les données avant les écrans, les écrans avant les gestes.** Une trace
  d'audit précède les gestes qu'elle consigne, sans quoi les premiers livrés
  n'en laisseraient aucune.
- **Les gardes en dernier, mais dérivées du code.** Un test qui énumère la table
  de routage attrape ce qui a été ajouté entre-temps, ce qu'une liste écrite à
  la main au début ne ferait pas.

Les dépendances forment des vagues. Le blueprint les consigne à l'ouverture du
chantier, **avec les numéros réels** des issues créées.

| Vague | Issues | Ce qu'elle établit |
|-------|--------|--------------------|
| 1 — les fondations | #287, #288, #289 | Trois fils sans dépendance entre eux. |
| 2 — avant tout geste | #290, #291 | La trace, puis la colonne d'état et son refus d'authentification. |
| 3 — les écrans | #292, #293 | La liste et la fiche, socle des gestes. |
| 4 — les gestes | #294 à #299 | Six issues parallèles une fois la vague 3 posée. |
| 5 — les gardes | #302, #303, #304 | Les tests qui vérifient ce que les gestes ont laissé. |

Une vague dit ce qui **peut** se prendre, pas ce qu'on prend. À l'intérieur
d'une vague et souvent d'une vague à l'autre, plusieurs ordres restent valides :
l'agent en recommande un et dit son motif, tiré du risque. Ce qui peut faire
tomber le chantier se traite en premier — une extension de base de données dont
on ignore si l'hébergement la porte, une API dont le contrat n'est pas confirmé.
Sans ce motif, l'ordre recommandé est l'ordre numérique, qui n'apprend rien.

## Une issue : une tâche, ou un lot de petites tâches

Une issue décrit soit une tâche qui se suffit, soit un lot de petites tâches qui
n'ont de sens qu'ensemble — une migration, son modèle et sa factory.

La bonne taille est celle d'**une session de travail qui se termine par un
commit et des tests verts**. Trop petite, elle multiplie les commits sans
valeur ; trop grande, elle dérive.

Chaque issue est **autonome** : l'agent doit pouvoir la prendre sans relire le
blueprint. Toujours les mêmes quatre blocs — objectifs, critères d'acceptation,
fichiers, tests — et la référence au plan en fin. Le squelette est
`tpl-issue.md`.

## Les labels

Un jeu par corps de métier, créé par le premier script et jamais modifié à la
main : `frontend`, `backend`, `db`, `routing`, `auth`, `i18n`, `test`, `docs`,
`setup`.

Un label d'état peut s'y ajouter — `livré`, posé sur une issue dont le code est
sur la branche en attente de fusion. Le gabarit ne le crée pas : c'est au projet
de décider s'il le veut.

Le **type** d'issue (`feature`, `chore`, `bug`) est un champ natif de la forge,
pas un label.

## Le script de jalon

Une fois le blueprint accepté, la création du jalon, des issues et de leurs
dépendances est faite par un **script bash versionné**, un par blueprint, écrit
par l'agent. Il n'y a pas de générateur générique.

### Comment il naît

On demande à l'agent d'ouvrir le chantier. Il lit le tableau de découpage,
rédige le corps complet de chaque issue à partir des sections Décision et Tests,
puis produit le script.

**Le script est relu avant exécution.** C'est là que les titres, les corps et
les dépendances se corrigent — dans un fichier diffable, avant de devenir des
objets dans la forge.

Procédure : `/chantier`. Elle n'exécute aucun script sans accord, et s'arrête
d'elle-même si le blueprint visé n'est pas au statut *Accepté*.

### Sa forme

Toujours la même, et c'est ce qui le rend relisible en quelques minutes :

1. deux constantes — le titre du jalon et sa description ;
2. la **garde d'idempotence**, qui cherche le jalon par son titre et abandonne
   s'il existe ;
3. la création du jalon ;
4. la liste des issues, une entrée par ligne du découpage : clé courte, type,
   labels, titre, corps ;
5. la liste des dépendances, en paires de clés — bloquée puis bloquante,
   recopiées de la colonne « Bloquée par » ;
6. deux boucles : créer les issues en retenant numéro et identifiant, puis
   câbler les dépendances.

Le squelette est `tpl-milestone-script.sh`. Il est écrit pour **bash 3.2**,
celui que macOS livre encore : les tableaux associatifs sont de bash 4, et le
gabarit montre comment s'en passer.

### Versionné, ré-exécutable

- **Commité** dans le même commit que le blueprint accepté, ou juste après. Il
  sert de trace de ce qui a été créé, et permet de rejouer la séquence sur un
  fork.
- **Idempotent au niveau du jalon.** Un second lancement trouve le jalon et
  s'arrête. En conditions normales, il ne se lance qu'une fois.
- **Exécuté à la main**, par `bash workflow/milestones/NNNN-slug.sh`, après
  relecture. Sa sortie donne le numéro réel de chaque issue, que le blueprint
  reprend dans son tableau de vagues.
- **Les dépendances sont natives.** Le script utilise le champ « bloquée par »
  de la forge, pas un texte dans le corps.

> **Deux pièges de l'API, tous deux silencieux**, sont consignés au point
> d'appel dans `forge.sh` et exigés de toute autre implémentation
> ([annexe C](C-la-forge.md)) : la dépendance exige l'**identifiant interne** de
> l'issue bloquante, pas son numéro affiché, et ce champ doit être envoyé comme
> un **entier**.

## Définition de « terminé »

1. Toutes les issues du jalon sont fermées, chacune avec son commentaire de
   livraison, et les dettes ont chacune leur fichier.
2. La suite de tests **complète** est verte — toutes les suites que la Pile
   nomme, pas seulement celle qu'on a touchée.
3. La PR est rédigée, révisée, auditée pour la sécurité et fusionnée.
4. Le jalon est fermé par l'API, et les blueprints amendés portent leur bloc
   d'amendement.

---

[← Les dettes](08-les-dettes.md) · [Sommaire](README.md) · [Suivant : Le travail →](10-le-travail.md)
