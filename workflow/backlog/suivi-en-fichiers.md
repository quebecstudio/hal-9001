# Un suivi en fichiers, sans forge

Statut : Proposé

## Le problème, ou l'envie

La méthode suppose une forge — jalons, tâches, dépendances, révision sur un
diff. Cette dépendance est assumée et nommée depuis le contrat de la forge, mais
elle exclut trois cas réels : un client qui interdit les outils externes, un
dépôt qui n'est hébergé nulle part, un projet solo pour qui ouvrir un compte est
plus cher que le bénéfice.

## L'idée

Un mode où les jalons et les tâches vivent dans `workflow/`, en fichiers
versionnés. Le script de milestone écrit des fichiers au lieu d'appeler une API,
et les dépendances sont un champ dans l'en-tête d'une tâche.

## Ce qu'elle vaudrait

Le dépôt devient auto-suffisant : tout ce qui décrit le travail est dans le
clone, y compris son état. Plus de secret, plus de compte, plus de piège d'API à
consigner. Et la promesse de portabilité cesse d'avoir une exception silencieuse.

## Ce qu'elle toucherait

Le gabarit de script de milestone, la bibliothèque — qui n'appellerait plus
`gh` —, la ligne de statut, `/chantier`, `/abandon`, et la révision.

## Les questions ouvertes

**La cinquième capacité du contrat de la forge, la révision sur un diff, n'a pas
d'équivalent en fichiers.** Elle redeviendrait un `git diff` lu à deux, sans
trace et sans checks de CI — et c'est l'étape que la méthode protège le plus.
C'est le point à trancher avant tout le reste : soit on accepte cette perte pour
les cas visés, soit on trouve autre chose.

Le second point : deux modes dont un seul est employé divergent, et c'est le
mort qu'on lira. Le dépôt a déjà refusé une troisième bibliothèque pour cette
raison, et retiré une implémentation entière pour bien moins que ça. Ce mode ne
devrait donc naître que porté par un projet réel qui l'exécute.
