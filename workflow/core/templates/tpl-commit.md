# Le message de commit

<Deux formes, selon qu'on livre du travail de chantier ou qu'on touche au
dossier `workflow/`. Le sujet dit l'état obtenu, jamais la manœuvre : « le tri
des sections est numérique », pas « correction du tri ». Le corps explique ce
que le sujet ne peut pas porter.>

## Commit de chantier

```
MNNNN #N: ce que le code fait maintenant

<Le comportement obtenu, au présent. Le lecteur doit comprendre ce que le code
fait désormais sans ouvrir le diff.>

<Ce qui a été décidé autrement que le plan ne le prévoyait, et pourquoi. Une
dérive convenue se dit ici comme sur l'issue.>

<Le piège qu'on a payé, s'il y en a un : la contrainte externe, le comportement
inattendu d'une bibliothèque, la raison d'un choix contre-intuitif.>
```

Un commit par issue, sauf travaux qu'on ne peut pas livrer séparément. Un défaut
trouvé pendant une issue se corrige sous **son** issue d'origine, avec son propre
commit et son propre `MNNNN #N`.

## Commit hors chantier

Le sujet nomme l'objet touché, puis dit son état.

```
Blueprint NNNN : <titre court>, accepté
Backlog : <ce que l'entrée propose>
Méthode : <la règle, telle qu'elle s'applique désormais>
Cycle : <ce que le processus demande désormais>
Instructions : <ce qui est vrai de ce dépôt-ci>
Dette NNNN : <ce qu'on a consigné>
Gabarit : <ce que le modèle fixe>
MNNNN : script de milestone
```

```
<L'objet et son état>

<L'incident qui l'a provoqué. Une règle sans sa circonstance paraîtra
arbitraire dans six mois, et sera contournée.>

<Pourquoi elle atterrit là plutôt qu'ailleurs : `cycle.md` décrit le processus,
`methode.md` dit comment on y travaille, `instructions.md` ce qui n'est vrai que
sur ce dépôt, les gabarits donnent la forme.>
```

Le changement de statut d'un blueprint est un commit à lui seul : c'est
l'information.

## Ce qu'un message ne fait pas

- Il ne raconte pas l'historique : pas de « avant c'était X », pas de récit du
  correctif. Le code décrit ce qui est.
- Il ne recopie pas le blueprint ni l'issue. Il les suppose lus, et cite leur
  numéro.
- Il ne colle pas de trace d'exécution. Un fichier, une ligne, un message.
- Il ne s'excuse pas et ne se félicite pas.
