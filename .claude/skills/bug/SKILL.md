---
name: bug
description: Suspend l'issue en cours, reproduit le défaut par un test, corrige, puis reprend. C'est le mot-clé « Bug : » de la méthode.
disable-model-invocation: true
argument-hint: [le symptôme observé]
---

## Le symptôme

$ARGUMENTS

## L'état du dépôt

!`git status --short --branch`

## Où on en était

!`cat workflow/etat.local.md 2>/dev/null || echo "(pas de fichier d'état)"`

## Ce qu'il faut faire

**Reproduire avant de corriger.** C'est l'étape qu'on saute quand le défaut a
l'air évident, et c'est celle qui compte : un test qui échoue prouve qu'on a
compris le symptôme, et prouve ensuite qu'on l'a réglé. Sans lui, on corrige ce
qu'on croit avoir compris.

L'ordre :

1. **Écrire le test qui échoue.** Il porte sur le comportement observé, pas sur
   la cause supposée. Le lancer, et vérifier qu'il échoue pour la bonne raison —
   un test qui échoue à cause d'une faute de frappe ne prouve rien.
2. **Corriger le code.** Le test passe.
3. **Lancer les tests ciblés** du fichier touché, pas la suite complète : elle
   est pour la fin du chantier.
4. **Trouver l'issue d'origine.** Un défaut découvert pendant une issue se
   corrige sous **son** issue à elle, avec son propre commit et son propre
   `MNNNN #N`. Si le défaut ne relève d'aucune issue ouverte, le dire — c'est
   peut-être une entrée de backlog, pas une correction à glisser ici.
5. **Consigner dans le commentaire de livraison** de cette issue : le symptôme,
   la cause réelle, et les diagnostics qui se sont révélés faux. Les fausses
   pistes valent autant que la solution pour le suivant.

## Si ça résiste

Si le défaut ne se reproduit pas, ne pas corriger à l'aveugle. Dire ce qui a été
tenté, ce que le test montre, et demander des précisions sur les conditions
d'apparition. Une correction posée sur un symptôme non reproduit ajoute du code
sans rien fermer.

## Puis reprendre

Le mot-clé suspend l'issue en cours, il ne l'abandonne pas. Reviens à ce que
l'état ci-dessus indique, en une phrase qui dit où tu reprends.
