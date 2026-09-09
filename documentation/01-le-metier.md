# 01 — Le métier a changé

[← Sommaire](README.md) · [Suivant : Installer →](02-installer.md)

On a moins besoin d'écrire du code. On a toujours autant besoin de le réviser.
Le volume de lignes produites n'est plus la mesure du travail ; ce qui compte
est la qualité de ce qu'on laisse entrer dans le dépôt.

Maîtriser le code reste donc aussi important qu'avant, mais pour une autre
raison : on le maîtrise moins pour écrire que pour **lire, juger et proposer**.
Lire un diff et voir ce qui cloche. Juger si une solution tient dans
l'architecture. Proposer la décision qui évitera trois corrections. Un
développeur qui ne sait plus lire son langage ne peut plus réviser, et un code
non révisé est une dette qui entre dans le tronc.

## Ce qui sépare le développeur du débutant

Deux étapes de la méthode ne produisent aucun code, et ce sont elles qui font
que le travail est professionnel : **le cadrage** qui précède le plan, et **la
révision** qui précède la fusion.

La première garantit qu'on a compris ce qu'on demande avant de le demander. La
seconde, qu'on a lu ce qu'on a reçu avant de l'accepter. Entre les deux, on
délègue. À ces deux points, on ne fait confiance à personne sur parole, et
surtout pas à l'agent.

Celui qui code à l'intuition accepte ce que l'agent produit parce que ça tourne.
Le professionnel accepte ce qu'il a compris, lu et vérifié.

La sécurité est le troisième marqueur. Un agent écrit volontiers une route sans
garde, une requête interpolée ou une donnée personnelle dans une réponse, et
rien ne s'en plaint à l'exécution.

## Le développeur est l'architecte

L'analogie tient d'un bout à l'autre. L'architecte ne pose pas les briques. Il
écoute le client, dessine le plan, le fait valider, puis confie le chantier à
des gens qui bâtissent plus vite que lui. Il repasse quand un imprévu demande
une décision, et il fait la réception des travaux avant de remettre les clés. Il
sait bâtir, sinon il ne saurait ni dessiner un plan qui tient, ni voir qu'un mur
est de travers.

Tout le vocabulaire en découle. Le **cahier d'instructions** est ce que l'agent
reçoit avant de commencer : les règles de l'art et les conventions de la maison.
Le **blueprint** est la définition d'une fonctionnalité, validée avant le
premier coup de pelle. Le **chantier** est le jalon qui la réalise. La
**révision** est la réception des travaux.

Le cahier des charges, lui, reste hors de la méthode : c'est ce qui a été
convenu avec le client, et c'est l'entrée du cadrage. La méthode commence
après lui.

L'analogie a une limite : un plan de bâtiment est complet avant qu'on creuse,
alors qu'un blueprint est sommaire et se précise au fil des tâches. C'est un
plan d'architecte, pas un plan d'ingénieur.

## L'agent est l'exécutant

Un agent de code est un assistant par défaut : il répond, il propose, il
conseille. Ce n'est pas ce rôle qu'on lui donne ici. Il est l'exécutant : celui
qui reçoit un plan et une tâche, et qui bâtit.

Ce qu'il apporte de lui-même est bienvenu à trois moments :

- **au cadrage**, où ses questions valent autant que ses réponses ;
- **dans le commentaire de livraison**, où il dit ce que la réalisation a appris ;
- **quand il s'interrompt**, parce qu'il voit une façon plus solide ou plus sûre
  de faire ce que le plan prévoit. Il propose et attend.

Le reste du temps, il exécute. C'est ce partage qui rend la délégation sûre. Un
assistant à qui l'on fait confiance dérive ; un exécutant à qui l'on donne un
plan, une tâche bornée et un critère de fin livre ce qui était prévu.

> **HAL 9001 est un rôle, pas un outil.** Le nom désigne le poste que l'agent
> occupe : exécuter un plan qu'il n'a pas décidé, annoncer ses gestes avant de
> les poser, s'arrêter quand il voit plus solide. Emprunté au calculateur de
> *2001* pour une seule réplique, « I'm afraid I can't do that », qui est ici
> une qualité : un agent qui refuse d'exécuter et le dit vaut mieux qu'un agent
> qui obéit à un ordre douteux.

> **D'autres parallèles, en aparté.** Le rédacteur en chef commande les
> articles, fixe l'angle et donne le bon à tirer : il écrit peu, mais rien ne
> paraît sans son regard. Le chef de cuisine écrit la fiche technique de chaque
> plat et goûte au passe avant l'envoi — il sait cuisiner, sinon il ne saurait
> pas ce qu'il goûte. Le chef d'orchestre ne joue d'aucun instrument pendant le
> concert, mais il entend la fausse note avant le public. Le pilote programme la
> route, surveille l'automate et reprend les commandes aux moments qui comptent ;
> celui qui ne vole plus jamais à la main perd ce qui le rend utile le jour de
> l'imprévu.

## Glossaire

La méthode manipule des objets qui ont déjà un nom. On les garde.

| Terme | Ce que c'est | Dans le cycle |
|-------|--------------|---------------|
| **Agent** | L'outil qui lit les instructions, exécute des commandes et écrit du code. Ici Claude Code. | La main-d'œuvre. Il ne décide pas, il ne fusionne pas. |
| **Cahier d'instructions** | Ce que l'agent lit avant tout travail : `workflow/core/methode.md` (du kit) et `workflow/instructions.md` (du projet). | Les règles de l'art. On y ajoute des règles bien plus souvent qu'on n'en change. |
| **Blueprint** | La définition sommaire d'une fonctionnalité : contexte, décision, alternatives, conséquences, découpage, tests. | Un par fonctionnalité. Discuté, accepté, puis figé. |
| **Jalon** (*milestone*) | Le regroupement des tâches d'un blueprint. | L'unité de livraison. Même numéro, même titre court que le plan. |
| **Issue** (la tâche) | Une fiche de travail : objectifs, critères, fichiers, tests. | L'unité de travail de l'agent. Autonome, fermée par un commentaire de livraison. |
| **Dépendance** | La relation « bloquée par », portée par la forge elle-même. | L'ordre du chantier, calculé une fois au découpage. |
| **Label** | Une étiquette de sujet : interface, serveur, base, tests… | Le classement par corps de métier. |
| **Branche `dev/…`** | La branche d'un chantier, créée depuis le tronc. | Le lieu du travail. Un commit par issue, aucun push automatique. |
| **PR** (la révision) | La proposition d'intégrer la branche, avec un récit et le diff. | La réception des travaux. Une par chantier, sans exception. |
| **Fusion** | L'intégration dans la branche principale. | La livraison. Jamais déclenchée par l'agent. |
| **Script de jalon** | Un script bash versionné, un par blueprint, qui crée le jalon, ses issues et leurs dépendances. | Le découpage sous forme de fichier relisible et rejouable. |

## Ce que ça rappelle, et ce qui diffère

Qui a travaillé avec Jira reconnaîtra la forme. La méthode en reprend la
hiérarchie. Ce qu'elle ne reprend pas, c'est le centre de gravité : dans un flux
Jira, l'outil de suivi est le lieu du travail ; ici, le lieu du travail est la
conversation entre l'humain et l'agent, et l'outil de suivi n'en tient que la
comptabilité.

| Dans un flux Jira | Ici | La différence |
|-------------------|-----|---------------|
| Epic | Blueprint et son jalon | L'epic est un ticket ; le blueprint est un document du dépôt, versionné, accepté avant qu'un ticket existe. |
| Story, tâche | Issue | Une story s'écrit pour un humain qui posera des questions. Une issue s'écrit pour un agent qui n'en posera pas. |
| Refinement, planning | Le cadrage | La cérémonie d'équipe a lieu avant. Le cadrage est ce qui vient après : ses conclusions passées à l'agent. |
| Découpage à la main | Le script de jalon | Les tickets sortent d'un fichier relu et rejouable, pas d'une séance de clics. |
| Revue de code | La révision, avec audit | Le même geste, mais obligatoire, adossé au plan, et complété d'un passage de sécurité. |
| Sprint, version | Chantier | Un chantier se ferme quand le plan est livré, pas quand le calendrier le dit. |

La correspondance est un mode d'emploi : une équipe qui vit dans Jira applique
la méthode telle quelle avec ses propres objets. Ce qui ne se transpose pas,
parce que c'est la méthode : **le document avant le ticket, l'issue écrite pour
un exécutant, et les deux moments où l'humain vérifie**.

---

[← Sommaire](README.md) · [Suivant : Installer →](02-installer.md)
