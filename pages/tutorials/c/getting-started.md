---
layout: page
title: Getting Started
permalink: /tutorials/c/getting-started/
---

The tutorials in this guide assume that you have a basic knowledge of C. If that is not the case, you'll be able to find C tutorials easily on Google.

# Prerequisites

The CE C toolchain requires ANSI C (C89), which means that some common C99-syntax won't work. You can find out more about the things in C99 that don't work in C89 [**here**](https://en.wikipedia.org/wiki/C99#Design).

For instance, functions which take no arguments must be declared as
`return_type name(void);`

TIOS functions are prefixed with either `os_` or `boot_` for your convience, and these functions can be included by using the [`tice.h`](https://github.com/CE-Programming/toolchain/blob/master/CEdev/include/ce/c/tice.h) header that comes with the toolcahin.

Finally, in order to save space, the prototype for main is: `void main(void);`

# The Libararies

There a few standard C libraries in order to make your life easier when programming. You can find them [**here**](https://github.com/CE-Programming/libraries/releases/latest).

Follow the directions in the above link in order to install the libraries into your toolchain.

These will be dynamically linked into your program at runtime, and only the functions you use will be referenced, thus minimizing size.

# Finishing Up

And that's all there is to it! Now it's just off to find some good C tutorials, or browse around some example code, references, and tutorials available here. (If you are unsure where to start, check out the next tutorial below)

Next: [Creating your first program]({{ site.baseurl }}/tutorials/c/first-program)
