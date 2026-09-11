# Annexe B — Les gabarits

[← Annexe A](A-le-dossier.md) · [Sommaire](README.md) · [Annexe C →](C-la-forge.md)

Un gabarit par type de document, dans `workflow/core/templates/`. L'agent part
toujours de l'un d'eux : c'est ce qui rend deux blueprints, deux dettes ou deux
rapports comparables d'une fois à l'autre, et ce qui lui évite d'inventer une
structure à chaque fois.

Le gabarit d'un document dit aussi, **par ses sections**, ce qu'on attend de lui
— ce qui tient lieu de consigne sans qu'on ait à la répéter.

Ce sont des gabarits **proposés**, un point de départ à adapter. Ce qu'une
équipe change, elle le change une fois, et l'agent part ensuite de sa version.
Tout est indépendant du langage ; ce qui est entre chevrons se remplace, et la
langue suit celle du projet.

## Les huit gabarits

| Gabarit | Ce qu'il produit | Ce qu'il contient |
|---------|------------------|-------------------|
| `tpl-blueprint.md` | Un blueprint | Contexte, ce qu'on sait avant de planifier, décision, alternatives, conséquences, découpage — tableau, vagues, ordre recommandé —, tests, références. |
| `tpl-backlog.md` | Une entrée de backlog | Le problème ou l'envie, l'idée, pourquoi elle vaudrait la peine, ce qu'elle toucherait, les questions ouvertes, le sort. |
| `tpl-debt.md` | Une dette | Le blueprint d'origine, ce qui a été fait à la place de quoi, ce que ça coûte, ce qui déclencherait le remboursement. |
| `tpl-issue.md` | Le corps d'une issue | Objectifs, critères d'acceptation, fichiers, tests, référence au plan. C'est ce que le script de jalon remplit pour chaque ligne du découpage. |
| `tpl-milestone-script.sh` | Un script de jalon | La garde d'idempotence, le jalon, les issues, les dépendances, les deux boucles. Il ne reste qu'à remplir les constantes. |
| `tpl-handoff.md` | Le passage de relais | L'ancre, les fichiers à lire, les issues et les vagues qui restent, ce qu'on a appris, ce qu'il ne faut pas refaire. Se jette une fois repris. |
| `tpl-report.md` | Le rapport d'un agent | Ce qui a été examiné, ce qui a été trouvé, ce qui est proposé avec son coût, ce qui reste incertain. |
| `tpl-commit.md` | Un message de commit | Les deux formes, de chantier et hors chantier, et ce que le corps doit porter. |

## Où les lire

**Les fichiers ne sont pas recopiés ici.** Ils l'ont été, et la copie a divergé :
l'annexe montrait un README à neuf étapes numérotées quand le fichier en
décrivait huit états, et le cahier recopié avait huit commits de retard le jour
où on l'a vérifié.

Un document qui reproduit un fichier du dépôt en diverge à la première
correction, et c'est la copie qu'on lit. La méthode l'interdit ; cette
documentation lui applique sa propre règle.

Chaque nom ci-dessus se lit dans `workflow/core/templates/`, tel qu'il est
aujourd'hui. Ce que cette documentation garde, c'est ce qu'aucun fichier ne dit
de lui-même : **à quoi il sert, et pourquoi il a cette forme.**

## Les deux fichiers de règles

| Fichier | Section | Ce qu'elle contient |
|---------|---------|---------------------|
| **`core/methode.md`**<br>*du kit* | Règles générales | Ce qui vaut pour tout travail, la sécurité en tête et subordonnant le reste. |
| | Devant un outil externe | Cinq manières de se tromper avec un outil qui n'annonce pas sa cause. |
| | Mots-clés | Les neuf marqueurs, le dixième qui ferme une réponse, et la procédure qui joue chacun. |
| | Jetons | Ce qu'on ne colle jamais, ce qu'on pointe, quand on délègue et quand on passe le relais. |
| **`instructions.md`**<br>*au projet* | Règles du projet | Ce qui ne vaut que sur ce dépôt. Une règle qui vaudrait partout remonte à la méthode. |
| | Architecture | Comment le dépôt est organisé, ce qui parle à quoi, les frontières. |
| | Pile | Langages, versions exactes, et **une surface par bloc** avec ses commandes — ciblée et suite. |
| | Conventions | Nommage, structure d'un fichier, forme d'un test, style de commentaire, formateur. |

La **forme** de la section Pile n'est pas libre, même si la pile l'est : les
règles de la méthode s'appuient dessus pour savoir quoi lancer. Chaque valeur
qui est une commande s'écrit exacte et copiable. Une clé sans objet s'écrit
quand même, avec sa raison — « aucune », jamais un blanc, qui se lit comme un
oubli. Un agent qui ne trouve pas la commande ne l'invente pas : il s'arrête et
la demande.

## Un exemple de section Pile

```markdown
**Langage** · PHP 8.3, Node 22
**Paquets** · composer, npm

**Surface serveur** · Pest
  ciblé · `php artisan test --filter=NomDuTest`
  suite · `php artisan test`

**Surface client** · Vitest
  ciblé · `npm run test -- chemin/du/fichier`
  suite · `npm run test`

**Formateur** · `npm run format`
**CI** · aucune ; la suite locale fait foi.
```

Le choix des outils appartient au projet. Ce qui ne change pas, c'est qu'ils
soient **nommés, avec leurs commandes, avant le premier chantier** — sinon deux
chantiers ne testent pas de la même façon.

---

[← Annexe A](A-le-dossier.md) · [Sommaire](README.md) · [Annexe C →](C-la-forge.md)
