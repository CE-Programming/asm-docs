---
layout: page
title: Getting Started
permalink: /tutorials/c/getting-started/
---

The tutorials in this guide assume that you have a basic knowledge of C. If that is not the case, you'll be able to find C tutorials easily on Google.

# Prerequisites

The CE C toolchain requires ANSI C (C89), which means that some common C99-syntax won't work. You can find out more about the things in C99 that don't work in C89 [**here**](https://en.wikipedia.org/wiki/C99#Design).

For instance, functions which take no arguments must be declared as
`returntype name(void);`

In addition, because the ZDS C Compiler (and the TIOS) does not save IY when working with functions and loops; you must use the `_OS( )` macro when calling native CE OS functions. For example:

```c
    /* Wait for the OS to recieve a keypress */
    _OS( os_GetKey() );
```

TIOS functions are prefixed with either `os_` or `boot_` in order to ensure the OS macro is used properly.

Finally, in order to save space, the prototype for main is: `void main(void);`

# The Libararies

There a few standard C libraries in order to make your life easier when programming. You can find them [**here**](https://github.com/CE-Programming/libraries).

In order to use these libraries, click on the button that says `Download ZIP`. Then, simply navigate to the `/library_headers` directory, and copy all the files inside into your C development library include directory, which is located at `CEdev/lib/ce`.

# Introduction

# The Code

# Finishing Up