---
layout: post
title:  Da quando ho smesso di commentare il codice
date:   2015-11-25
image: https://ik.imagekit.io/edelprino/edelprino/blog/clement-helardot-95YRwf6CNw8-unsplash_g8YNA1HXP.jpg?updatedAt=1692092840536
---

Un tempo, mi ricordo, se trovavo del codice poco commentato o non commentato del tutto, mi arrabbiavo. Mandavo accidenti a colui che non aveva avuto l’accortezza di scrivere due righe, una frase o anche solo qualche parola per facilitarmi la vita.

Dopo aver letto [Clean Code di Robert C. Martin](https://www.amazon.it/Clean-Code-Handbook-Software-Craftsmanship/dp/0132350882) ho capito che i commenti non sono cosa buona.

I nomi delle variabili, delle classi, dei metodi dovrebbero essere esplicativi non dovrebbe esserci bisogno di ulteriori aggiunte.

> L’uso dei commenti è quello di compensare il nostro fallimento nel creare codice comprensibile

Robert C. Martin fa questo esempio:
```
// Check to see if the employee is eligible for full benefits
if (($employee->flags & HOURLY_FLAG) && ($employee->age > 65))
```

oppure

```
if ($employee->isEligibleForFullBenefits())
```

In molti casi basta creare un metodo che dica le stesse cose che si vogliono scrivere nel commento per rendere tutto più chiaro.

Citando Brian W. Kernighan and P. J. Plaugher:

>Don’t comment bad code. Rewrite it.

Quando sento la necessità di commentare il codice che ho appena scritto mi fermo e ragiono su come poterlo rendere più leggibile, estraendo metodi, scrivendo nomi di variabili più significative ed esplicite.

Adesso, quando trovo del codice poco commentato o non commentato del tutto, mi arrabbio. Lo stesso. Mandando accidenti a colui che non ha avuto la decenza di scrivere del codice più leggibile.
