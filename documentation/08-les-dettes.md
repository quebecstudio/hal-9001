# 08 — La dette technique

[← Le backlog](07-le-backlog.md) · [Sommaire](README.md) · [Suivant : Le chantier →](09-le-chantier.md)

Un chantier livre ce que son plan prévoit, et il laisse presque toujours
quelque chose derrière lui : un raccourci pris en connaissance de cause, une
pièce qu'on n'a pas encore, une solution provisoire.

Ce reste a un nom, la dette technique, et il a un dossier : `workflow/debts/`.

## Une dette par fichier

Chaque fichier décrit **une seule** dette : ce qui a été fait à la place de
quoi, pourquoi, ce que ça coûte tant que ça dure, et ce qu'il faudrait pour la
rembourser.

Les dettes ne sont pas numérotées — elles n'ont pas d'ordre d'exécution. Elles
sont **préfixées du numéro du blueprint** dont elles découlent :
`0014-licence-de-police-a-acquerir.md`. On retrouve ainsi d'un coup d'œil le
chantier qui l'a créée et le plan qui explique le contexte.

## Chaque chantier ajoute les siennes

C'est une étape de la fermeture, entre les issues et la révision : l'agent
relit ce qu'il a livré, nomme ce qu'il sait provisoire, et écrit un fichier par
dette. La PR les cite dans « Ce qui reste ouvert ».

**Une dette qu'on ne consigne pas n'est pas une dette, c'est une surprise pour
quelqu'un d'autre.**

## Une dette est parfois prévue

Tout ce qu'on doit au projet n'est pas un défaut du code : une licence à
acheter avant la mise en production, un service à acquérir, une alternative
qu'on sait devoir implémenter quand le code sera plus mûr.

Ces dettes-là se consignent de la même façon, avec **ce qui déclenchera leur
remboursement** : une date, un volume, un jalon.

> Le cas le plus courant : un projet sans framework de test. La méthode interdit
> de bricoler un script de vérification jetable — il coûte le même temps et ne
> prouve rien deux semaines plus tard. Le blueprint liste quand même les
> comportements à prouver, et une dette porte les tests qui restent à écrire.
> Ils s'écriront au chantier qui installe le framework, et la dette dit
> lesquels.

## Le tour des dettes

À intervalles réguliers, ou avant d'ouvrir un blueprint qui touche à un module
endetté, on demande à un agent de lire le dossier : quelles dettes tiennent
encore, lesquelles le code a rendues caduques, et pour chacune une façon de s'en
départir avec son coût.

Ce rapport suit `tpl-report.md`, comme tout rapport d'agent. L'architecte décide
de ce qu'on rembourse et dans quel ordre.

## Rembourser est un chantier comme un autre

La correction passe par la même cérémonie qu'une fonctionnalité : un cadrage —
où le fichier de dette et le rapport sont les pièces sur la table —, un
blueprint qui prend son numéro et cite la dette qu'il règle, un script, des
issues, une branche, une révision avec audit, une fusion.

Une dette petite et bornée peut rejoindre le chantier d'un blueprint qui touche
au même module, comme issue de suite. Mais elle ne se règle **jamais en douce**,
sur un coin de branche, sans plan ni révision.

Une fois le chantier fermé, le fichier descend dans `settled/` avec la référence
du blueprint qui l'a réglée. Rien n'est supprimé, pour la même raison que le
backlog : c'est le raisonnement qu'on cherche des mois plus tard, pas seulement
la conclusion.

---

[← Le backlog](07-le-backlog.md) · [Sommaire](README.md) · [Suivant : Le chantier →](09-le-chantier.md)
