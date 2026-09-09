# Annexe D — La ligne de statut

[← Annexe C](C-la-forge.md) · [Sommaire](README.md) · [Annexe E →](E-les-procedures.md)

Ce que l'agent affiche en permanence sous la zone de saisie. Tout vit dans le
dépôt : au clone, une commande suffit, et il n'y a rien à installer.

```
Issues · M0002 · #13 · dev/lanceur-de-tests · 62% · Opus 5
```

L'étape du cycle, le chantier, l'issue, la branche, le remplissage du contexte,
le modèle. La ligne par défaut donne déjà la branche ; ce qu'elle n'a pas, c'est
**où on en est dans le cycle**, qui est la question qu'on se pose vraiment en
cours de session.

Elle rend visibles d'un coup d'œil les dérives les plus faciles à commettre :
travailler sur `main`, écrire du code sans issue ouverte, ne plus savoir à
quelle étape on est. Chacune s'affiche en jaune.

> **Ce n'est qu'un affichage.** La ligne de statut n'entre pas dans le contexte
> de l'agent : y mettre un rappel de règle serait un rappel pour le développeur,
> pas une garantie sur la conduite de l'agent. Ce qui engage l'agent reste le
> cahier.

**Et seulement au terminal.** Quand on reprend la session depuis un téléphone ou
un navigateur, le processus tourne toujours sur la machine et le script
s'exécute — mais l'appareil distant affiche la conversation, pas le pied de page
du terminal. *Vérifié.* Qui suit de loin n'a donc ni l'étape, ni le chantier, ni
le remplissage du contexte. L'état, lui, reste lisible de partout : c'est un
fichier du dépôt.

## Les trois pièces

| Pièce | Où | Versionnée |
|-------|-----|-----------|
| Le script | `workflow/core/scripts/statusline.sh` | oui |
| Le réglage | `.claude/settings.json` | oui chez le projet — **produit** par `setup.sh`, pas livré par le kit |
| L'état courant | `workflow/etat.local.md` | non |

Le réglage tient en quatre lignes :

```json
{
  "statusLine": {
    "type": "command",
    "command": "bash \"$CLAUDE_PROJECT_DIR/workflow/core/scripts/statusline.sh\""
  }
}
```

`$CLAUDE_PROJECT_DIR` est la racine du projet : le chemin reste juste quel que
soit le répertoire d'où la commande est lancée, et quel que soit le poste.

## Poser la ligne

Elle s'installe avec le reste, par `bash workflow/core/scripts/setup.sh`. Il
écrit le réglage — ou l'ajoute au fichier existant, avec une copie de sauvegarde
—, crée le fichier d'état à `Repos`, et affiche un aperçu.

C'est le développeur qui l'exécute, ou qui l'autorise : écrire dans les réglages
est bloqué pour l'agent, et approuver l'exécution dans le dialogue de permission
est la voie normale. Si l'exécution est refusée, le développeur lance la
commande depuis sa propre saisie plutôt que de la contourner.

Sur un projet qui ne suit pas la méthode, l'étape et le chantier n'ont aucun
sens : c'est le script d'affichage qu'il faut alors reprendre, pas le fichier
d'état.

## Le fichier d'état

`workflow/etat.local.md`, une seule ligne, **et elle ne porte que l'étape** :

```
Issues
```

Le chantier et l'issue **se déduisent de Git** — la branche `dev/<slug>` nomme
le blueprint, dont le numéro est celui du jalon, et le sujet du dernier commit
porte le numéro d'issue. L'étape est la seule chose que Git ne sait pas dire.

Ce qu'on écrit **en plus** l'emporte sur ce qui se déduit, pour les cas où Git
se tait : `Issues M0002 #13` fonctionne. Mais ce qui se déduit ne ment pas ; ce
fichier, tenu à la main, a menti une session entière.

Le reste de la ligne est ignoré : `Issues — figer la navigation` fonctionne
aussi bien. Un chantier écrit court est complété à quatre chiffres à
l'affichage. Au `Blueprint`, faute de chantier ouvert, le numéro du plan tient
lieu de repère : `Blueprint 0003`.

**Les mots reconnus ne sont pas listés ici.** Ils vivent dans `statusline.sh`,
qui est le seul à les lire, et `setup.sh` les y prend pour écrire l'en-tête
commenté du fichier d'état — là où celui qui le tient les a sous les yeux. Une
liste recopiée à un troisième endroit aurait vieilli comme les autres.

Ce qui les gouverne, en revanche, se dit ici : **un mot désigne un état durable
du poste.** Un geste n'en est pas un — écrire un passage de relais achève la
session, et plus personne ne regarde la ligne — ni une suspension de quelques
heures : un mot pour le traitement d'un bug obligerait à réécrire le fichier
deux fois par incident, et un fichier qu'on tient trop souvent finit par mentir.
C'est ce critère qui ferme la liste, et non sa longueur.

**L'étape est déclarée, jamais devinée.** La déduire demanderait d'interroger le
dépôt distant, et cette ligne se recalcule à chaque rafraîchissement.

Le suffixe `.local.md` la garde hors de Git : c'est un état de poste, pas un
état de projet. Deux développeurs sur le même dépôt ne sont pas à la même étape.

**C'est l'agent qui le tient à jour**, à chaque franchissement d'étape ; le
cahier l'y oblige, et sa règle est écrite pour rester inerte là où le fichier
n'existe pas. Laissé au développeur, il ment dès qu'on l'oublie — et une ligne
de statut qui ment est pire qu'une absente.

## Le remplissage du contexte

Le seul chiffre de la ligne qui **annonce une échéance** au lieu de décrire un
état. Le cahier demande à l'agent de proposer le moment d'un relais parce qu'un
contexte saturé oublie en silence : ce pourcentage est ce qui rompt le silence.

L'agent le fournit déjà calculé — il n'y a rien à mesurer. Quatre paliers, qui
suivent la règle du relais plutôt qu'une graduation régulière : l'alerte doit
arriver assez tôt pour qu'une tâche en cours puisse encore se terminer.

| Palier | Ce qu'il dit |
|--------|--------------|
| moins de 50 % | en gris, presque effacé — il n'y a rien à décider |
| 50 à 74 % | lisible, sans alerte |
| 75 à 89 % | **jaune** — poser le relais à la fin de la tâche en cours |
| 90 % et plus | **rouge** — le relais devient l'urgence |

Le champ est nul avant le premier appel de la session, et de nouveau après un
`/compact`. Le pourcentage disparaît alors de la ligne : c'est un état normal,
pas une panne, et rien ne le signale — **une absence n'est pas une anomalie**.

Il prévient le développeur, pas l'agent, qui ne verra jamais ce chiffre. Ce
qu'on gagne est de pouvoir demander le relais avant qu'il le propose — conforme
à la règle, puisqu'elle veut que le moment revienne au développeur.

Le même JSON expose la dépense de la session et la consommation des quotas. Ils
n'ont pas leur place ici : le quota n'existe que pour certains abonnements, et
une ligne qui affiche ce qui manque parfois apprend à être ignorée.

## Vérifier que ça marche

Le script se teste sans l'agent, en lui donnant sur son entrée standard le JSON
qu'il recevrait. Les cas limites :

| Fichier d'état | Sortie |
|----------------|--------|
| `Issues` | `Issues · M0002 · #13 · dev/… · 62% · Opus 5` — chantier et issue déduits de Git |
| `Cadrage` | `Cadrage · main · Opus 5` — ni chantier ni issue, et c'est normal à cette étape |
| `Blueprint 0003` | `Blueprint · 0003 · main · Opus 5` |
| `M02 #19` | `étape inconnue · M0002 · #19 · …` |
| ligne inintelligible, ou fichier absent | `étape inconnue · hors chantier · …` |
| hors dépôt Git | `… · hors dépôt · Opus 5` |

## Avant de la reprendre ailleurs

- **Le script ne doit jamais échouer.** Il sort en 0 en toute circonstance :
  hors dépôt Git, sans `git`, sans fichier d'état, avec un JSON incomplet. Une
  ligne de statut qui plante gêne à chaque frappe.
- **Aucune dépendance externe.** Pas de `jq` : il était absent du premier poste
  où ce script a tourné, et son absence ne se voyait pas — le nom du modèle
  disparaissait simplement, sans erreur.
- **bash est nécessaire.** Sur Windows, celui de Git Bash. Le dépôt force la fin
  de ligne LF sur les `.sh` : en CRLF, Git Bash refuse le fichier avec une
  erreur sur le retour chariot.
- **Une alerte ne doit crier que sur une anomalie.** « Hors chantier » ne
  s'affiche pas au Cadrage ni au Blueprint : à ces étapes, n'avoir ni jalon ni
  issue est l'état normal. Une alerte qui se déclenche sur un état normal cesse
  d'être lue, et emporte les autres avec elle.
- **Un seul emplacement**, et **aucun secret** : ce qu'elle affiche est visible
  de quiconque regarde l'écran ou une capture.

---

[← Annexe C](C-la-forge.md) · [Sommaire](README.md) · [Annexe E →](E-les-procedures.md)
