# 11 — La révision et la fusion

[← Le travail](10-le-travail.md) · [Sommaire](README.md) · [Suivant : À plusieurs →](12-a-plusieurs.md)

Un chantier se termine par **une seule** pull request, de `dev/…` vers la
branche principale. C'est la réception des travaux, faite avant la fusion, sans
exception.

C'est la seconde des deux étapes qui refusent la confiance aveugle. Un code qui
tourne n'est pas un code accepté : il est accepté quand quelqu'un l'a lu, l'a
comparé au plan, a vu la suite verte et a audité ce qu'il expose.

## Le corps de la PR est un récit

L'agent le rédige à partir des commentaires de livraison et de l'historique de
la branche. Toujours la même structure :

| Bloc | Ce qu'il contient |
|------|-------------------|
| En-tête | Le jalon, le blueprint, le nombre d'issues fermées, la plage de numéros. |
| Ce que ça ajoute | Les fonctionnalités livrées, du point de vue de qui les utilise. |
| Ce qui disparaît | Les surfaces temporaires, le code remplacé, les fichiers retirés. |
| Ce que les tests ont trouvé | Les défauts que seuls les tests ont révélés, avec leur cause. |
| Corrections sur son propre travail | Les gardes trop faibles, les conventions mal transposées. |
| Ce qui reste ouvert | Ce que le chantier laisse au suivant. Les dettes y sont citées une à une. |
| Vérifications | Le décompte de la suite complète, le formateur, le build, le rendu confirmé. |

## La révision

- **Le diff est lu, pas seulement le récit.** Le récit dit où regarder ; il ne
  remplace pas la lecture.
- **Le code est comparé au blueprint.** Ce qui s'en écarte doit avoir son
  commentaire d'issue. Ce qui s'en écarte sans trace est renvoyé.
- **La suite complète est verte** sur la branche au moment de la révision, et le
  décompte figure dans la PR — dans la CI quand le projet lui donne autorité.
  Son absence se dit, plutôt qu'elle ne se remplace par un « c'est vert chez
  moi ».
- **Chaque test corrigé est révisé**, un à un.
- **Ce qui reste ouvert est nommé.** Une PR qui ne dit pas ce qu'elle laisse
  derrière elle n'est pas prête.

## L'audit de sécurité

Un passage dédié, **distinct de la lecture fonctionnelle**, en deux temps :
l'agent audite la branche avec une consigne explicite de sécurité et rend un
rapport, puis l'architecte lit ce rapport et vérifie lui-même ce que l'agent ne
peut pas juger — ce qui dépend du contexte métier et de ce que la fonctionnalité
a le droit d'exposer.

- **Autorisation** : chaque route ajoutée est derrière la garde attendue, et un
  test dérivé de la table de routage le prouve.
- **Entrées** : toute donnée venue de l'extérieur est validée et liée, jamais
  interpolée.
- **Sorties** : aucune donnée personnelle ne quitte une surface qui n'en a pas
  besoin, et un test de non-fuite couvre les surfaces publiques.
- **Secrets et configuration** : rien de sensible dans le dépôt, interrupteurs
  fermés par défaut, en-têtes de protection présents.
- **Redirections et limites** : les paramètres de retour sont bornés au site,
  les points d'entrée sensibles ont une limitation de débit.

Un écart trouvé à l'audit est une issue de suite, corrigée **avant** la fusion.
Un écart qui dépend de l'hébergeur ou d'un tiers est consigné par un test qui
grave l'état connu, pour qu'il soit lu et non oublié.

## La fusion

Elle ne se fait que **sur demande explicite**. L'agent ne la déclenche jamais de
lui-même, même une fois la révision faite — et le hook le lui refuse.

Après la fusion : le jalon est fermé, la branche est conservée sur le distant
comme référence, les blueprints amendés portent leur bloc, l'entrée de backlog
descend dans `delivered/`. Le chantier est clos, et l'état revient à `Repos`.

## Quand le plan ne tient pas

L'abandon est la seconde sortie, atteignable depuis Issues, Dettes ou Révision :
ce qu'on a construit montre que le plan ne tient pas. **C'est le développeur qui
le décide, jamais l'agent.**

Le blueprint passe au statut *Abandonné*, avec en tête où ses idées ont voyagé ;
il est conservé, jamais réécrit. Le jalon garde son titre — le renommer le
rendrait introuvable pour la garde d'idempotence — et son abandon se dit dans sa
description. Les issues se ferment en disant qu'elles n'ont pas été faites :
fermer sans raison les afficherait comme livrées, et un chantier abandonné
deviendrait indistinguable d'un chantier réussi.

Procédure : `/abandon`.

---

[← Le travail](10-le-travail.md) · [Sommaire](README.md) · [Suivant : À plusieurs →](12-a-plusieurs.md)
