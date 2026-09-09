# 03 — Le cycle

[← Installer](02-installer.md) · [Sommaire](README.md) · [Suivant : Le cahier →](04-les-instructions.md)

> La table qui fait autorité — pour chaque état, ce qui s'y fait, la question
> que l'agent pose et les états qu'elle ouvre — est dans
> `workflow/core/cycle.md`. Ce qui suit l'explique.

## Une étape ne se ferme jamais d'elle-même

Le cycle est une machine à états dont **les transitions sont des décisions du
développeur**, et c'est l'agent qui les demande : il dit ce qu'il a produit,
nomme la décision qu'il attend et l'état qu'elle ouvrirait, puis s'arrête.

« C'est fait » n'est pas une fin d'étape.

L'état courant s'écrit dans `workflow/etat.local.md`, que la ligne de statut
affiche ([annexe D](D-la-ligne-de-statut.md)).

## Neuf états et deux sorties

```
Repos
  └─ Cadrage ......................... jusqu'à compréhension commune
       ├─ Blueprint · Proposé ........ on écrit, on ajuste
       │    └─ Blueprint · Accepté ... figé, source de vérité
       │         └─ Chantier ......... le script de jalon, relu puis exécuté
       │              └─ Branche ..... dev/<slug>, depuis un tronc tiré à l'instant
       │                   └─ Issues . ordre des dépendances, un commit par issue
       │                        └─ Dettes ..... une par fichier
       │                             └─ Révision (PR) ... diff, suite verte, audit
       │                                  └─ Fusion ..... sur demande explicite
       ├─ Courte ..................... issues à la main, puis Révision
       └─ hors chantier .............. commit direct, l'état reste Repos

    dérive en cours de route ......... commentaire d'issue, le plan reste figé
    remise en cause .................. un nouveau blueprint remplace l'ancien
    le plan ne tient pas ............. Abandon, décidé par le développeur
```

Le jalon est l'unité de livraison. Il naît d'un blueprint accepté, se remplit
d'issues créées par script, se développe sur sa propre branche, et se ferme par
une révision.

## Les trois voies

Tout ne passe pas par la table entière. Le cadrage pèse le travail et aiguille.

Trois mesures, indépendantes l'une de l'autre :

| Ce qu'on mesure | Ce que ça exige |
|-----------------|-----------------|
| Combien de décisions il faut figer | un blueprint — c'est un document de décision, rien d'autre |
| Si des tâches dépendent d'autres tâches | un jalon et son script, qui existe pour câbler ces liens |
| Ce qui ne se défait pas | une branche, une PR, une révision |

Ce qui ne mesure rien : le nombre de fichiers touchés, ni le temps passé. Un
renommage qui traverse tout le dépôt ne porte aucune décision une fois la
découpe admise.

| Voie | Quand | Ce qu'elle emprunte |
|------|-------|---------------------|
| **Hors chantier** | Rien à figer, rien à coordonner, rien qui engage : la méthode, la documentation, les gabarits, un correctif qui tient en un commit. | Rien du cycle. L'état reste `Repos`. |
| **Courte** | Des décisions déjà prises, et aucune tâche qui attende une autre. | Issues écrites à la main, branche `dev/<slug>`, PR. Ni blueprint ni jalon. |
| **Chantier** | Des décisions à figer, ou des dépendances à câbler. | Le cycle entier, de `Blueprint` à `Fusion`. |

**Le développeur tranche, toujours.** L'agent pèse et propose la voie avec son
motif ; il ne la choisit jamais seul.

**Une voie se change en cours de route.** Un travail parti en voie courte qui
révèle une dépendance revient au cadrage. Ce qui a été commité reste, et la
branche est déjà là.

## Pourquoi cette méthode rend efficace

L'efficacité ne vient pas de la vitesse de l'agent. Elle vient de ce que la
méthode **supprime** : le re-briefing, le code écrit deux fois, la planification
quotidienne, la révision diffuse.

- **Le contexte est écrit une fois.** Chaque session démarre au bon niveau sans
  qu'on réexplique le projet, et deux sessions à un mois d'écart produisent le
  même style de code.
- **Décider avant de bâtir coûte moins que démolir.** Corriger une phrase dans
  un plan coûte des minutes ; le même changement d'avis après implémentation
  coûte une réécriture, des tests à refaire et un historique brouillé.
- **Une issue autonome, c'est une session courte.** Un contexte petit, c'est
  moins de jetons, moins d'erreurs de cadrage, une qualité plus stable qu'une
  longue session qui dérive.
- **L'ordre est calculé une fois.** Les dépendances remplacent la question
  quotidienne « par quoi je continue ? » et empêchent de livrer un écran avant
  la donnée qu'il affiche.
- **Le découpage est un fichier diffable.** Un script relu en quelques minutes
  crée un chantier entier, sans un clic dans l'interface.
- **La traçabilité est gratuite.** Un commit et un commentaire de livraison par
  issue produisent le récit de la révision sans effort supplémentaire.
- **Le test est le critère de fin.** Un changement sans test n'est pas terminé :
  l'agent a un critère objectif pour s'arrêter.
- **L'attention humaine est dépensée là où elle vaut.** L'architecte décide au
  plan, tranche à l'imprévu, reçoit à la révision.
- **Les dérives ne bloquent pas, et ne se perdent pas.** Un écart devient un
  commentaire d'issue ; une vraie remise en cause devient un nouveau blueprint.
- **Les idées n'immobilisent pas l'exécution.** Une proposition sans échéance
  vit au backlog, sans numéro, et prend sa place le jour où elle est prête.
- **Chaque correction de comportement n'est faite qu'une fois.** Une habitude
  indésirable devient une règle du cahier, pas une remarque répétée.
- **La sécurité n'est pas une phase de fin.** Elle vit dans le cahier, donc dans
  chaque issue, et un audit ferme chaque chantier.
- **La fusion est un acte, pas un accident.** Le tronc reste toujours livrable,
  et un chantier raté se jette avec sa branche.

Le gain net : le temps d'un chantier se passe presque entièrement à **décider**
et à **réviser**, deux activités où l'humain apporte quelque chose.

---

[← Installer](02-installer.md) · [Sommaire](README.md) · [Suivant : Le cahier →](04-les-instructions.md)
