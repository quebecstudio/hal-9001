---
name: question
description: Répond sans rien modifier. C'est le mot-clé « Question : » de la méthode, rendu exécutoire par le retrait des outils d'écriture.
disable-model-invocation: true
disallowed-tools: Edit, Write, NotebookEdit, Bash
argument-hint: [la question]
---

$ARGUMENTS

---

Réponds à ce qui précède. Les outils d'écriture ont été retirés pour ce tour,
Bash compris — c'est par lui qu'un `sed` ou un heredoc écrirait malgré tout.
Rien ne sera donc modifié, même si la réponse fait apparaître un travail évident
à faire. Propose-le, ne le fais pas. Pour lire, Read, Grep et Glob restent.

La forme d'une réponse est celle que la méthode fixe pour ❓, et elle n'est pas
rappelée ici : deux textes qui décrivent la même chose finissent par diverger.
