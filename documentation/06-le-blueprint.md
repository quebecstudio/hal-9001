# 06 — Le blueprint

[← Le cadrage](05-le-cadrage.md) · [Sommaire](README.md) · [Suivant : Le backlog →](07-le-backlog.md)

Le blueprint est la définition sommaire du travail à faire pour une
fonctionnalité. Il vit dans le dépôt, à côté du code, versionné comme lui.

L'agent en écrit le premier jet à partir du gabarit et du cadrage ; on le lit,
on le corrige, on le fait réécrire jusqu'à satisfaction, puis on l'accepte.
Quand le chantier s'ouvre, ce qu'il doit livrer a déjà été lu, discuté et
approuvé : **rien n'y est décidé en cours de route.**

## Ce qu'il est, et ce qu'il doit rester

- **Un plan, une fonctionnalité.** Un sujet qui déborde en fait deux, et le
  second attend au backlog ou prend son propre numéro.
- **Une fonctionnalité tient en dix points.** Ce qu'elle permet, ce qu'elle
  touche, ce qu'elle refuse. Au-delà, ce sont deux chantiers, le second bloqué
  par le premier. Une dépendance entre chantiers n'est pas un défaut ; un
  chantier qu'on ne peut plus tenir dans la tête en est un.
- **Il se scinde en moins de vingt tâches.** Le test de taille se fait au
  découpage, et un plan trop gros se coupe **avant** d'ouvrir le chantier. Ces
  nombres sont des repères, pas des seuils : le mot d'ordre est *digeste* — un
  plan qu'on lit d'une traite, un chantier qu'on tient dans la tête, une issue
  qu'on suit sans décrocher.
- **Sommaire, pas exhaustif.** Il dit ce qu'on fait et pourquoi, à la précision
  nécessaire pour découper. Les conventions viennent du cahier, le détail
  d'exécution vient des issues.
- **Lisible d'une traite.** Quelqu'un qui arrive sur le projet doit comprendre
  la fonctionnalité sans ouvrir le code.
- **Complet pour qui commence.** Une section sans objet porte « N/A » plutôt que
  d'être retirée : l'absence est alors une décision, pas un oubli.
- **Révisé et accepté avant le premier commit.** Figé ne veut pas dire
  intouchable : il peut changer, mais on s'y tient par défaut, et une dérogation
  se convient **avant** d'être codée.

## À quoi il sert

- **Fixer la décision hors de la tête de quelqu'un.** Six mois plus tard,
  « pourquoi a-t-on fait ça ? » a une réponse écrite, avec les options qu'on
  avait et ce qui les a fait écarter.
- **Donner à l'agent un cadre qu'il ne peut pas dériver.** Il code contre le
  plan, pas contre son idée du moment.
- **Produire le découpage.** Son tableau d'issues est ce que le script de jalon
  lit. Sa section Tests fixe la définition de « terminé » avant que le code
  existe.
- **Absorber le désaccord au bon moment.** Un plan se conteste en minutes tant
  qu'il est *Proposé*. C'est là que la discussion coûte le moins.

## Pourquoi dans le dépôt, et pas dans l'outil de suivi

Les plans sont des fichiers versionnés avec le code ; l'outil de suivi n'en
contient que des références. Quatre raisons :

- **Les issues restent concises.** Une issue dit ce qu'elle fait et renvoie au
  blueprint pour le pourquoi. Sinon, vingt copies d'un même raisonnement
  divergeraient à la première correction.
- **L'agent lit le plan depuis sa copie de travail.** Pas besoin de l'API pour
  comprendre ce qu'il construit. Le plan est à côté du code, à la même version.
- **Un plan se relit en diff.** Une modification est un commit, avec son
  message, son auteur et sa date. Un champ de description modifié dans une
  interface n'a rien de tout cela.
- **Le dépôt survit à l'outil.** Changer de forge emporte les issues et les
  jalons, ou les abîme. Les plans suivent le code, et les scripts recréent les
  tâches ailleurs.

L'outil de suivi garde ce qu'il fait bien : l'état des tâches, leur ordre, la
conversation autour de chacune, la révision du diff. Le dépôt garde ce qui doit
durer : **les décisions**.

## Pourquoi avant le code

Parce que l'agent produit du code plus vite qu'on ne peut le juger. Sans plan
écrit, il fait des choix d'architecture implicites à chaque issue, et on les
découvre dans le diff, quand ils sont déjà tissés dans dix fichiers.

Avec un blueprint, ces choix sont faits **une fois**, à l'écrit, révisés, puis
imposés à chaque issue. Le découpage devient mécanique, la révision a une
référence, et les alternatives écartées ne sont pas reproposées à l'issue
suivante.

## Quand en écrire un

Chaque fonctionnalité non triviale. Un correctif isolé, un ajustement de style
ou une issue de suite n'en demandent pas. Le test est simple : **si le travail
mérite un chantier, il mérite un plan.** Les [trois mesures](03-le-cycle.md#les-trois-voies)
du cadrage tranchent le reste.

## Le gabarit

`tpl-blueprint.md` ([annexe B](B-les-gabarits.md)). En-tête de métadonnées —
numéro, titre, statut, dates, jalon, entrée de backlog d'origine — puis :
contexte · ce qu'on sait avant de planifier · décision (modèle de données,
flows, surface, choix techniques, sécurité) · alternatives considérées ·
conséquences · ce que le blueprint ne tranche pas · découpage en issues · tests
et conditions de complétion · références.

Trois sections font le travail en aval :

- **Alternatives considérées.** Chaque option écartée, et **la nature de la
  raison qui l'écarte** : un fait, une règle, ou un jugement non vérifié. Les
  trois sont recevables ; seule la troisième doit se dire comme telle, parce
  qu'elle seule peut être fausse sans qu'on s'en aperçoive. Si l'éprouver coûte
  moins qu'une issue, on l'éprouve avant de faire accepter le plan.
- **Découpage en issues.** Le tableau que le script de jalon lira.
- **Tests.** Les **comportements à prouver**, un par ligne — « un utilisateur
  sans droit ne voit pas la fiche d'un autre », et non « test_acl ». La liste
  est indicative : elle dit ce qu'on croit devoir prouver avant d'avoir écrit
  une ligne, et ce que l'agent en écarte se dit dans le commentaire de
  livraison. Pas de cases à cocher : une liste qu'on coche se remplit de tests
  écrits pour honorer la liste.

## Le cycle de vie

| Statut | Ce qu'il veut dire |
|--------|--------------------|
| **Proposé** | En discussion, mutable. Le document se réécrit librement. |
| **Accepté** | Figé. Source de vérité du chantier. Une dérogation se convient d'abord, puis passe par un commentaire d'issue ou un nouveau blueprint. |
| **Remplacé par NNNN** | Conservé pour l'historique. Ne pas appliquer. |
| **Abandonné** | Écarté, conservé pour mémoire, avec un bandeau en tête qui dit où ses idées ont voyagé. |

Le changement de statut est un commit à lui seul : c'est l'information.

## Les amendements

Quand un blueprint postérieur change ce qu'un blueprint accepté décrit, l'ancien
reçoit un bloc d'amendement **en tête**, daté, qui pointe vers le nouveau. Le
corps original n'est pas réécrit. Le lecteur d'un vieux plan sait immédiatement
ce qui ne décrit plus le code.

```markdown
> **Amendement du 2026-07-27 — cycle de vie du compte (blueprint 0008, M0008).**
>
> Ce document décrit la table `users` telle qu'elle a été posée en M0001.
> Deux points ne décrivent plus l'état du code : …
```

Procédure : `/amendement`.

---

[← Le cadrage](05-le-cadrage.md) · [Sommaire](README.md) · [Suivant : Le backlog →](07-le-backlog.md)
