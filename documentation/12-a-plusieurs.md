# 12 — À plusieurs

[← La révision](11-la-revision.md) · [Sommaire](README.md) · [Annexe A →](A-le-dossier.md)

La méthode est décrite avec un architecte et un agent. À plusieurs, **rien ne
change dans le cycle** ; ce qui change est que `workflow/` devient un espace
partagé, et qu'il faut dire comment on s'y déplace sans se marcher dessus.

## Le workflow se synchronise par Git, et par rien d'autre

Le dossier `workflow/` est du code au sens de Git : il vit sur les branches, il
se fusionne, il se relit en diff. **La branche principale est la seule vérité
partagée.** Ce qui n'y est pas encore n'existe que pour celui qui l'a écrit.

- **Tout chantier part d'un tronc tiré à l'instant.** C'est ce qui garantit que
  chacun lit le même cahier, les mêmes blueprints acceptés, le même backlog et
  les mêmes dettes.
- **Un blueprint accepté est fusionné avant que son chantier s'ouvre.** Il prend
  son numéro à ce moment, sur un tronc à jour, et personne d'autre ne peut
  prendre le même.
- **Le script de jalon s'exécute depuis ce tronc, une fois, par une seule
  personne.** La garde d'idempotence protège contre le second lancement, pas
  contre deux lancements simultanés.
- **Une branche par chantier, un chantier par personne à la fois.** Deux
  personnes sur le même blueprint se partagent ses issues par les dépendances,
  sur la même branche, et l'une d'elles tient la révision.

## Amender un blueprint à plusieurs

Un blueprint a un auteur : celui qui l'a cadré et rédigé avec l'agent.

Tant qu'il est *Proposé*, il se discute par une PR vers le tronc — les collègues
commentent le diff, l'auteur intègre. **Accepter, c'est fusionner cette PR.** La
discussion d'équipe a ainsi une trace, au même endroit que le code.

Une fois *Accepté*, personne ne modifie le corps, pas même l'auteur. Trois
gestes restent possibles :

- **une dérive** en cours de chantier se convient, puis s'écrit dans l'issue par
  un commentaire signé et daté ; le blueprint n'est pas touché ;
- **un amendement**, quand un blueprint postérieur change ce que celui-ci
  décrit, s'ajoute en tête. Il est écrit par l'auteur du nouveau plan, dans la
  PR de celui-ci, pour que l'ancien auteur le voie passer ;
- **une remise en cause** devient un nouveau blueprint ; l'ancien passe à
  *Remplacé* dans la même PR.

> **La règle qui tient tout : on n'édite jamais en silence ce qu'un collègue a
> fait accepter.** Un changement qu'il découvre en relisant le plan six mois
> plus tard est une trahison de la méthode, même s'il est juste.

## Le backlog et les dettes appartiennent à tous

N'importe qui ajoute une entrée de backlog ou un fichier de dette, sans
demander : c'est précisément pour ça qu'ils existent. Deux pratiques gardent
l'ensemble lisible.

- **On bonifie, on ne réécrit pas.** Un collègue qui a quelque chose à ajouter à
  une idée qui n'est pas la sienne ajoute une note datée et signée à la fin. Le
  texte d'origine reste, et le cadrage futur lit les deux.
- **Avant d'ajouter, on cherche.** Une idée voisine existe peut-être déjà. On la
  bonifie plutôt que d'ouvrir un doublon, et si les deux méritent de vivre,
  chacune cite l'autre.

Faire passer une idée de *Proposé* à *Accepté* est une décision d'équipe, prise
au cadrage qui la reprend ou dans une PR dédiée — jamais par une modification
directe sur le tronc.

## Passer le relais à un collègue

Le passage de relais entre deux sessions sert aussi entre deux personnes. Celui
qui quitte un chantier demande le sommaire habituel et le donne au suivant.

Le commentaire de livraison de chaque issue fermée fait le reste : **un chantier
bien tenu se reprend sans conversation**, parce que tout ce qui compte est déjà
écrit là où le suivant regardera.

## Comment une règle atteint toute l'équipe

Une règle ajoutée sur la branche d'un chantier n'existe que là. Un collègue qui
travaille sur un autre blueprint ne la voit pas tant que ce chantier n'est pas
fusionné, et deux personnes codent alors sous deux cahiers différents.

Une branche réservée aux instructions ne réglerait rien : elle séparerait la
règle du commit qui l'a motivée, et ajouterait un endroit à surveiller. Trois
règles de circulation suffisent :

- **La règle voyage avec son chantier** et atteint le tronc à la fusion de
  celui-ci, avec le code qu'elle a corrigé.
- **Tout chantier part d'un tronc à jour.** C'est une étape du cycle, pas un
  conseil.
- **Une règle qui ne peut pas attendre** — une règle de sécurité, une convention
  que tout le monde viole en ce moment — fait l'objet d'une petite PR à part,
  cahier seul, révisée et fusionnée sur-le-champ. Les branches en cours ramènent
  ensuite le tronc chez elles.

---

La méthode tient en une phrase : **rien n'entre dans le code sans un cadrage et
un plan avant, une issue pendant, et une révision avec audit après.** L'agent
fait le gros du travail entre ces points. Les points eux-mêmes restent ceux de
l'architecte, et c'est ce qui rend la méthode éprouvée plutôt que rapide.

---

[← La révision](11-la-revision.md) · [Sommaire](README.md) · [Annexe A →](A-le-dossier.md)
