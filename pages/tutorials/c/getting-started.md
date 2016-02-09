---
layout: page
title: Getting Started
permalink: /tutorials/c/getting-started/
---

The tutorials in this guide assume that you have a basic knowledge of C. If that is not the case, you'll be able to find C tutorials easily on Google.

Inside of your C installation directory you will find a folder called `examples`, and inside this folder `demo1`. Open a command window in this folder, and simply type the command *make*.

# Prerequisites

The CE C toolchain requires ANSI C (C89), which means that some common C99-syntax won't work. You can find out more about the things in C99 that don't work in C89 [here](https://en.wikipedia.org/wiki/C99#Design).

For instance, functions which take no arguments must be declared as
`rettype name(void);`

In addition, because the ZDS C Compiler does not save IY and IX when working with functions and loops; you must use the `_OS( )` macro when calling native CE OS functions. For example:

```c
    /* Wait for the OS to recieve a keypress */
    _OS( while(!GetCSC) );
```

Finally, in order to save space, the prototype for main is: `void main(void);`

# The Libararies

# Introduction

# The code

# Finishing Up