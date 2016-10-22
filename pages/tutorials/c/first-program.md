---
layout: page
title: Creating Your First Program
permalink: /tutorials/c/first-program/
---

This tutorial will help you `make` your first progran and give some tips!

# Creating a Program Directory

To be more organized and so you know where everything you create is, I suggest creating a new directory, located anywhere, for all your new TI 84+ CE programs. Name it something like "CEPrograms" (all one work to make cd'ing easier) and remember where you put it. 

Now, open up CEdev/examples and copy the template. Paste the template into your new directory, rename it, and open it up.

# Editing the Makefile

The makefile holds the base information for you program, the name, and your compile options. Follow the steps below to set it up.

- Open the file labled `makefile` with Notepad++ or your preferred editor.

- Edit `TARGET ?= DEMOT` and replace `DEMOT` with your program name.

- Keep `DEBUGMODE ?=` as `NDEBUG` until you decide to use the Debug features in your program.

- The other options are pretty self explanatory, and the comments at the top of the file will help with explanation.

- **IMPORTANT:** You will want to add `graphx fileioc keypadc to L :=` to be able to use the libraries.

# Editing your Program

So you have all these tools to create your program, but how do you actually go about doing it? Follow these steps to push away your confusion. (Some knowledge of C is recommended)

- Open /src in your program directory, then open `main.c` with your editor.
- To make any library commands work, you need to add these lines below your other includes.
```
#include <graphx.h>
#include <keypadc.h>
#include <fileioc.h>
#include <debug.h>
```
- In `void main(void) {}` add `gfx_Begin( gfx_8bpp );` to initialize the graphics canvas, and `prgm_CleanUp();` at the end so your program ends

You now have a program that opens, initializes the graphics, then closes! (Once you compile it, of course) To add more commands, check out the C library headers [here](https://github.com/CE-Programming/toolchain/tree/master/CEdev/lib/src/libraries).

# Making your Program (Compiling)

You have your code written, but you wnat to test out your program? Then this is the right command for you! It compiles your program, and if succesful, creates a `*.8xp` in the /bin/ folder!

- To make on windows, go [here](https://www.cemetech.net/learn/C_SDK_Tips_and_Tricks#.22Making.22_the_program_2).
- To make on linux and mac, go [here](https://www.cemetech.net/learn/C_SDK_Tips_and_Tricks#.22Making.22_the_program).

Go ahead and send the file, `*.8xp`, to CEmu or your calculator, be sure you ahve the C libraries installed, and run it with `Asm(prgmPROGRAM`!

# Finishing Up

You should have just created, compiled, and tested a program that you made! Now that you have this knowledge, have fun creating programs and games!
