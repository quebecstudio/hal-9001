# Annexe D — La ligne de statut

[← Annexe C](C-la-forge.md) · [Sommaire](README.md) · [Annexe E →](E-les-procedures.md)

Ce que l'agent affiche en permanence sous la zone de saisie. Tout vit dans le
dépôt : au clone, une commande suffit, et il n'y a rien à installer.

```
🔨 Tâches · M0002 #13 · 💻 dev/lanceur-de-tests ⇡2 · 🧠 62% · 💪 high · 🤖 Opus 5
```

L'étape du cycle, le travail en cours, la branche, les commits qui n'ont pas
quitté le poste, le remplissage du contexte, le modèle et son niveau d'effort.
La ligne par défaut donne déjà la branche ; ce qu'elle n'a pas, c'est **où on en
est dans le cycle**, qui est la question qu'on se pose vraiment en cours de
session.

Elle rend visibles d'un coup d'œil les dérives les plus faciles à commettre :
travailler sur `main`, écrire du code sans issue ouverte, ne plus savoir à
quelle étape on est, oublier de pousser. Chacune s'affiche en jaune.

## La grammaire

Deux vocabulaires, et ils ne disent pas la même chose.

**La couleur dit le niveau d'inquiétude**, jamais la nature : jaune « fais
attention », rouge « alarme », vert « tu es où tu dois être », gris « rien à
voir ». C'est pourquoi il n'y a **pas** de jeu de couleurs par étape — onze états
pour six couleurs utilisables, et le jaune cesserait de vouloir dire quelque
chose.

**L'emoji marque le champ** : 💻 « ici, la branche », 🧠 « ici, le contexte »,
💪 « ici, l'effort », 🤖 « ici, le modèle ». Ce qui appartient à un champ reste
**dans** son segment : l'avance sur le distant se colle à la branche, parce que
c'est d'elle qu'elle parle. Un `·` à l'intérieur d'un segment serait le même
glyphe que celui qui les sépare, et l'œil y lirait une frontière qui n'existe
pas.

L'étape fait exception, et c'est la seule qui la mérite :
une branche est une chaîne, un pourcentage un nombre, un modèle un nom, mais une
étape est une **catégorie** — le seul champ dont la valeur se reconnaît avant
d'être lue.

| | | | |
|---|---|---|---|
| 💤 Repos | 🧭 Cadrage | 📐 Blueprint | 🚧 Chantier |
| 🌱 Branche | 🔨 Tâches | ⚡ Tâche simple | 🧾 Dettes |
| 🔍 Révision | 🔀 Fusion | ❌ Abandon | ❔ inconnue |

Deux contraintes sur ces glyphes, et elles ont chacune coûté une correction :
aucun des neuf marqueurs de la méthode — 📐 conviendrait à Blueprint et lui **a
été repris**, le marqueur Conseil étant devenu 🧩 —, et aucun sélecteur de
variante, ⚙️ et 🗺️ portant un `U+FE0F` dont la largeur est instable selon le
terminal.

Le mot affiché n'est pas toujours le mot écrit : l'étape `Issues` s'affiche
« Tâches », et `Tâche` s'affiche « Tâche simple ». Le vocabulaire garde le mot de
la forge, la ligne parle français.

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

`workflow/etat.local.md`, une seule ligne, et elle porte **ce que Git ne peut pas
dire** :

```
Issues #13
```

Trois choses, et pas une de plus : l'**étape**, le numéro du **blueprint** quand
on y travaille — `Blueprint 0003` —, et l'**issue en cours**.

**Une seule chose se déduit** : le jalon, par la branche `dev/<slug>` qui nomme
le blueprint dont le numéro est celui du milestone. Ce qui se déduit ne ment pas ;
ce fichier, tenu à la main, a menti une session entière.

**Le numéro d'issue, lui, ne se déduit surtout pas.** Il l'a été, du sujet du
dernier commit — et ce commit nomme la dernière issue **livrée**, pas celle qu'on
vient d'ouvrir. Une fois `#11` commitée, la ligne affichait `#11` toute la
soirée. Un fait passé présenté comme un fait présent est pire qu'un champ vide.
D'où la règle qui l'accompagne : **l'issue s'écrit quand on l'ouvre, pas quand on
la ferme.**

Le numéro de blueprint ne se déduit pas non plus, pour une raison voisine :
plusieurs plans peuvent attendre d'avance, et le seul candidat plausible n'est
pas forcément celui sur lequel on travaille.

Le reste de la ligne est ignoré : `Issues #13 — figer la navigation` fonctionne
aussi bien. Un chantier écrit court est complété à quatre chiffres à
l'affichage.

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

Une exception, et elle vient d'un incident : `/cadrage` **écrit son étape
lui-même**, par un bloc exécuté avant le tour. La procédure retire les outils
d'édition, donc l'agent ne pouvait pas l'écrire pendant ; il l'écrivait « au tour
suivant », c'est-à-dire dans un tour dont le sujet était autre chose, et un jour
il ne l'a pas fait — puis a annoncé une étape qu'il n'avait pas lue.

## L'avance sur le distant

`💻 dev/essai ⇡2` : deux commits n'ont pas quitté le poste. Rien quand il n'y a
rien, comme tout le reste de la ligne.

Le compte est **collé à la branche**, dans son segment — c'est d'elle qu'il parle
—, mais il garde son **jaune** même quand la branche est verte : sur un
`dev/<slug>`, il dirait sinon « tout va bien » alors qu'il rappelle qu'il reste
quelque chose à faire.

**Une flèche, et une seule.** L'avance se compte sans réseau ; le retard
demanderait un `fetch` à chaque frappe, ce qui est disqualifié pour une ligne qui
se recalcule à chaque rafraîchissement. Sans amont — une branche jamais poussée —
le champ reste vide, ce qui est honnête : on ne sait pas ce qui manque au distant
tant qu'on ne lui a rien dit.

Ce champ n'est pas là par symétrie. Dans la session qui l'a fait naître, cinq
tours se sont terminés par « tu as des commits non poussés » : l'information
était gratuite et manquait.

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

Il expose aussi `effort.level`, `fast_mode` et `thinking.enabled`. **Le niveau
d'effort a son propre marqueur**, 💪, plutôt que de suivre le modèle : il se
règle séparément de lui. Les deux autres restent disponibles et non pris.

Deux clés du JSON portent un nom trop commun pour être cherchées dans tout le
document : `used_percentage` existe aussi sous `rate_limits`, et `level` sous
n'importe quel objet à venir. Le script isole d'abord le segment. C'est le genre
de piège qui ne se voit pas : il afficherait un chiffre juste, pris au mauvais
endroit.

## Vérifier que ça marche

Le script se teste sans l'agent, en lui donnant sur son entrée standard le JSON
qu'il recevrait. Les cas limites :

| Fichier d'état | Sortie |
|----------------|--------|
| `Issues #13`, sur `dev/lanceur-de-tests` avec son blueprint | `🔨 Tâches · M0002 #13 · 💻 dev/… · 🧠 62% · 🤖 Opus 5` — le jalon seul est déduit |
| `Cadrage` | `🧭 Cadrage · 💻 main · 🧠 62%` — ni chantier ni issue, et c'est normal à cette étape |
| `Blueprint 0003` | `📐 Blueprint 0003 · 💻 main · 🧠 62%` — le numéro se colle à l'étape, il n'y a pas encore de jalon |
| `Tâche #9`, sur une branche sans blueprint | `⚡ Tâche simple · #9 · 💻 dev/… ` — voie courte, pas de jalon, **et pas d'alerte** |
| `Révision`, sur `main` | `🔍 Révision · hors chantier · 💻 main · ⇡2` — là, l'alerte a raison |
| `M02 #19` | `❔ étape inconnue · M0002 #19 · …` |
| ligne inintelligible, ou fichier absent | `❔ étape inconnue · hors chantier · …` |
| hors dépôt Git | `… · 💻 hors dépôt · 🤖 Opus 5` |

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

  **Elle se tait aussi en voie courte, à toutes les étapes**, et cette condition
  se déduit de la branche : un `dev/<slug>` sans blueprint à son nom est une voie
  courte, où n'avoir pas de chantier est la définition même. Lister `Révision` et
  `Fusion` parmi les étapes tolérantes les aurait rendues muettes sur la voie
  longue aussi, où l'absence de chantier est bien une anomalie. Le défaut s'est
  vu à l'usage, pas à la lecture : une voie courte arrivée à la révision criait
  « hors chantier » sur un état parfaitement normal.
- **Un seul emplacement**, et **aucun secret** : ce qu'elle affiche est visible
  de quiconque regarde l'écran ou une capture.

---

[← Annexe C](C-la-forge.md) · [Sommaire](README.md) · [Annexe E →](E-les-procedures.md)
