# 04 — Le cahier d'instructions

[← Le cycle](03-le-cycle.md) · [Sommaire](README.md) · [Suivant : Le cadrage →](05-le-cadrage.md)

Avant la première ligne de code, l'agent reçoit ses instructions. Ce sont des
**fichiers**, versionnés ou personnels, jamais un long message tapé au début de
chaque session. Ensemble, ils forment le cahier d'instructions : ce qui vaut
pour tous les chantiers, et que le blueprint n'a donc pas à répéter.

## Où il vit

| Fichier | Qui l'écrit | Ce qu'il porte |
|---------|-------------|----------------|
| `workflow/core/methode.md` | Le kit. Un projet le reçoit, il ne l'écrit pas. | Les règles de travail : générales, devant un outil externe, les mots-clés, les jetons. |
| `workflow/instructions.md` | Le projet, et lui seul. | Ses règles propres, son architecture, sa pile, ses conventions. |
| `workflow/instructions.local.md` | Un développeur. Hors Git. | Ce qui n'appartient qu'à lui : la langue, le degré de détail, un chemin qui n'existe que chez lui. |

À la racine, chaque agent trouve le fichier qu'il attend — `CLAUDE.md`,
`AGENTS.md` — **réduit à un renvoi**. Si le cahier vivait dans ces fichiers, il
serait dupliqué sous chaque nom, et les copies divergeraient.

Deux règles bornent le fichier local : il **ajoute**, il ne contredit pas ; et
rien de ce qui touche à la sécurité ne s'y décide. Un développeur qui voudrait y
assouplir une règle a en réalité une règle à discuter avec l'équipe.

> **Pourquoi deux fichiers de règles.** La frontière est celle de la
> propagation. Une correction faite à l'amont arrive au projet à la prochaine
> mise à jour ; ce que le projet écrit n'est jamais écrasé. Tant que les deux
> vivaient dans un seul fichier, ce fichier était exclu de la mise à jour —
> puisqu'un projet y écrit — et les règles communes ne partaient donc jamais.

## Ce qu'il contient

Pas seulement des consignes. Quatre choses :

- **Les instructions** : ce que l'agent fait et ne fait pas, la sécurité par
  défaut, quand il s'interrompt, comment il teste et commite.
- **L'architecture** : comment le dépôt est organisé, où vivent les modules, ce
  qui parle à quoi, les frontières qu'on ne traverse pas.
- **La pile** : langages, frameworks, versions exactes, et **les commandes de
  test**, pour que l'agent code contre ce qui est installé et non contre ce
  qu'il a appris.
- **Les conventions** : nommage, structure d'un fichier, forme d'un test, style
  de commentaire, formateur.

La pile et les conventions n'ont pas à s'écrire à la main : les serveurs MCP et
les skills des écosystèmes savent les produire et les tenir à jour. Le
développeur n'écrit alors que ce que l'outil ne peut pas savoir.

### Le général et le spécifique

Les instructions générales — commenter, tester, commiter, s'interrompre — ne
dépendent d'aucune pile et suivent le développeur de projet en projet. Les
spécifiques vivent avec le code. Cette séparation fait du cahier un outil
réutilisable : un nouveau projet s'ouvre en une heure au lieu d'une semaine de
corrections.

### La sécurité en est la pierre angulaire

Donner des préférences de code implique d'abord qu'elles soient sûres : une
convention qui produit du code élégant mais exposé n'est pas une convention,
c'est une faille reproduite à chaque issue.

La sécurité n'est donc pas une rubrique parmi d'autres. Elle est **le critère
contre lequel chaque autre règle est vérifiée avant d'être ajoutée**. L'agent
n'a pas de jugement propre sur ce qui est dangereux ; il a les règles qu'on lui
a écrites, et c'est au cahier de faire en sorte que les suivre suffise à
produire du code sûr.

## Quelques règles, et pourquoi

La liste qui fait foi est dans `workflow/core/methode.md`. Celles-ci sont celles
dont la raison ne se devine pas à la lecture.

- **Sûr par défaut.** Toute route derrière une garde, toute entrée validée et
  liée, aucune donnée personnelle hors d'une surface qui en a besoin, aucun
  secret dans le dépôt, tout interrupteur fermé par défaut. Toute autre règle
  lui est subordonnée.
- **S'interrompre quand on voit plus solide.** L'agent s'arrête **avant
  d'écrire**, dit ce qu'il voit, propose. Il ne l'applique pas seul. On tire de
  la valeur d'une interruption, jamais d'un écart silencieux.
- **Une garde se prouve.** Toute garde posée ou modifiée porte un test qui
  échoue quand on la retire — sans quoi « sûr par défaut » est une intention et
  non un fait.
- **Un défaut se prouve avant d'être réparé.** Le test qui le reproduit s'écrit
  d'abord, et il échoue.
- **Un plan ne porte pas de condition invérifiable.** Un blueprint qui écarte un
  outil retire la condition de complétion qui en dépend. Une case qu'on ne peut
  pas cocher finit cochée quand même.
- **On éprouve avant d'écarter, quand l'épreuve est bon marché.** Une option
  écartée par un jugement — non par un fait, non par une règle — ne se départage
  pas en discutant. Si l'éprouver coûte moins qu'une issue, on l'éprouve.
- **Décider ce qui se déduit, demander ce qui s'arbitre.** Tout demander détruit
  la valeur de l'agent ; ne rien demander laisse le développeur devant un fait
  accompli.
- **Une question se pose en options, pas en page blanche.** Les possibilités
  réelles, ce que chacune coûte, et celle qu'on recommande avec son motif.
- **Annoncer, et attendre quand le geste engage.** Dans le périmètre ouvert :
  énoncer et faire. Ailleurs, ou pour ce qui ne se défait pas : énoncer,
  **s'arrêter, attendre**. Annoncer puis faire dans la même réponse est un
  compte rendu, pas une annonce.
- **Une autorisation vaut pour le geste qu'elle nomme.** Elle ne s'étend pas à
  ce qui l'entoure et ne se reconduit pas d'un tour au suivant — sauf mandat,
  qui dit alors ce qu'il couvre et ce qui l'interrompt.
- **Un commit hors chantier dit l'incident qui l'a provoqué.** Sans la
  circonstance, on lit ce qui a changé et jamais pourquoi : la règle paraîtra
  arbitraire dans six mois, et sera contournée.
- **Ne pas commenter l'historique.** Le code décrit ce qui **est**, pas ce qui a
  changé. L'historique vit dans Git et dans les blueprints.
- **Ce qui documente ne recopie pas.** Pointer le fichier, ou l'inclure par un
  mécanisme qui le régénère — jamais un copier-coller.

### Devant un outil externe

Un outil externe échoue rarement en nommant sa cause. Ces règles décrivent des
manières de se tromper, pas des outils.

- **Un texte qui compte passe par un fichier.** Jamais un argument ni un
  heredoc : ce qui traverse la ligne de commande perd ses accents, et l'échec
  est silencieux.
- **On ne se relit pas dans une liste.** Vérifier l'objet lui-même : une liste
  retarde, et fait croire à un échec qui n'a pas eu lieu.
- **Un échec dont le message ne nomme pas la cause s'arrête.** Pas de second
  essai à l'aveugle.
- **Tout appel externe passe par la bibliothèque.** Jamais la commande en direct
  dans un script de chantier.
- **Ne pas s'appuyer sur ce que l'environnement déduit.** Nommer la branche, le
  dépôt, le distant.

## Les mots-clés

Le cahier contient une section de mots-clés. Ce ne sont pas des mécaniques : ce
sont des **conventions de conversation**. Un mot en tête de message vaut un
paragraphe de cadrage.

**Le mot-clé et le marqueur sont deux choses.** Le mot-clé est **le mot** que le
développeur écrit en tête de son message — `Question :`, `Idée :`, `Bug :`. Le
marqueur est **l'emoji** par lequel l'agent ouvre sa réponse, suivi du mot. Le
premier va dans un sens, le second dans l'autre.

La conversation devient ainsi relisible d'un coup d'œil : on retrouve où une
idée a été versée au backlog, où un défaut a été corrigé, où l'agent s'est
arrêté pour proposer autre chose.

| Mot-clé | Marqueur | Ce que ça veut dire | Ce que l'agent fait |
|---------|:--------:|---------------------|---------------------|
| `Question :` | ❓ | Ni une demande de changement, ni un reproche. | Il répond et **ne modifie rien**. Sa réponse s'ouvre par la question telle qu'il l'a comprise. |
| `Idée :` | 💡 | Une idée à consigner, sans rapport obligé avec le travail en cours. | Il la met en forme, la dépose au backlog, la commite, et reprend la tâche en cours. |
| `Bug :` | 🐛 | Un problème à corriger avant de poursuivre. | Il suspend l'issue, **reproduit par un test**, corrige, teste, consigne dans le commentaire de livraison, reprend. |
| `Amendement :` | ✏️ | Un changement au plan décidé en cours de route. | Il s'entend d'abord, puis consigne sur l'issue ou le blueprint **avant** qu'une ligne parte dans l'autre sens. Le corps original n'est jamais réécrit. |
| `Attention :` | ⚠️ | Une règle du cahier a été omise. | Il relit la règle, corrige ce qu'il vient de produire, vérifie le reste de l'issue. Si la règle manquait, il l'ajoute. |
| `Relais :` | 🔁 | La session se termine. | Il écrit le passage de relais dans `workflow/handoff.md`, hors Git, ancré sur la branche, le HEAD et l'heure. |
| `Reprise :` | 🔄 | Une session commence sur un travail en cours. | Il lit le relais et les fichiers qu'il nomme, **supprime le fichier**, résume en trois lignes, avertit de tout écart avec l'ancre, et attend avant de modifier le dépôt. |
| *aucun* | 🔴 | **Interruption.** *Part de l'agent* : il voit plus solide. | Il s'arrête avant d'écrire et propose. Il n'applique pas. |
| *aucun* | 🧩 | **Conseil.** *Part de l'agent.* | Une recommandation qu'on ne lui a pas demandée. |

Les deux derniers n'ont pas de mot-clé, et c'est cohérent : ils partent de
l'agent. Sept mots-clés, donc, pour neuf marqueurs.

**Neuf marqueurs, et pas un de plus** — au-delà, plus rien ne se repère. Le
marqueur vaut aussi quand le mot-clé n'a pas été écrit : c'est la nature du
message qui le décide, non sa forme.

Un projet qui aurait besoin d'un dixième l'écrit dans **ses propres**
instructions, jamais dans `methode.md` que la mise à jour réécrit — et il sait
alors qu'il sort du vocabulaire commun.

### Le marqueur de clôture

Les neuf **ouvrent** une réponse ; un dixième la **ferme**, unique et
invariable.

> 👉 **Une réponse se termine par ce qu'on attend du développeur.** Dernière
> ligne, en gras : la décision à prendre, la question qui reste ouverte, ou —
> quand rien n'est attendu — ce qui vient d'être fait et ce qui suit.

Chaque mot-clé a sa procédure `/nom`, décrite à l'[annexe E](E-les-procedures.md).
Une procédure ne redit pas la règle : elle la joue.

## Des règles vivantes

Le cahier **grandit**, il ne bouge pas. Quand l'agent prend une habitude qu'on
ne veut pas, on ajoute une règle — dans le même commit que la correction du
code, y compris au milieu d'un chantier.

Modifier ou retirer une règle existante est l'exception : chaque règle en place
a déjà été appliquée dans du code, et la changer rend ce code non conforme. On
le fait quand le gain dépasse ce coût.

Une règle arrive toujours après quelque chose : un défaut qu'on a payé, une
confusion entre deux personnes, un geste que l'agent a pris sans demander. **Le
message de commit le raconte.** C'est ce qui fait du journal Git la mémoire de
la méthode : une règle dont on connaît la circonstance se conteste au lieu
d'être contournée.

---

[← Le cycle](03-le-cycle.md) · [Sommaire](README.md) · [Suivant : Le cadrage →](05-le-cadrage.md)
