---
layout: page
title: eZ80 Differences
permalink: /tutorials/asm/ez80diff.html
---

The tutorials in this guide assume that you have a decent knowledge of eZ80 assembly. However, if you have no idea where to begin, you will first want to begin with the updated version of [**Asm in 28 Days**](http://media.taricorp.net/83pa28d/lesson/toc.html#lessons).

Of course, eZ80 assembly is a little different than what the guide uses throught. Most of the ideas are entirely applicable, although the following **must** also be taken into account:

1. The **bcall()** and **bjump()** macros are no no longer nessasary. If you have Z80 code that looks like this:

```
 bcall(_ClrLCD)
```

Or something similar, this can simply be replaced with:

```
 call _ClrLCD
```

2. The eZ80 has two differnt CPU modes, ADL and Z80 respectively.
