---
layout: page
title: Double Buffering
permalink: /tutorials/asm/double-buffering/
---

As before, create a new directory called *tutorial_3*, and from within create the file called *main.asm*

Current directory structure:

```
 CEasm
    |
    include
    |
    tools
    |
    tutorial_1
    |
    tutorial_2
    |
    **tutorial_3**
```

# Introduction

In computer graphics, double buffering refers to drawing graphics out of the user's view, and then transfering the drawn data all at once to the screen.

This prevents the weird graphical effects you may have seen in the previous tutorial, where we cleared the screen and then updated the rectangle, where there was a few milliseconds where the screen is completely black.

Now, the two main methods of double buffering are known as **blitting** and **page flipping**. For the curious, here's a short explanation on each: [**Double Buffering**](https://docs.oracle.com/javase/tutorial/extra/fullscreen/doublebuf.html)

# The Code