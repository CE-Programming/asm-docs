---
layout: page
title: Creating Your First Program
permalink: /tutorials/c/first-program/
---

This tutorial will help you `make` your first program with the local toolchain (build tools) and give some tips!  
In this specific example, a program using the GRAPHX library will be made.

# Creating a Program Directory

To be more organized and so you know where everything you create is, I suggest creating a new directory, located anywhere, for all your new TI-84+ CE programs. Name it something like "CEPrograms" (all one work to make cd'ing easier) and remember where you put it. 

Now, open up CEdev/examples and copy the template. Paste the template into your new directory, rename it, and open it up.

# Editing the Makefile

The makefile holds the base information for you program, the name, and your compile options. Follow the steps below to set it up.

- Open the file labeled `Makefile` with Notepad++ or your preferred editor.

- Edit `TARGET ?= DEMOT` and replace `DEMOT` with your program name.

- Keep `DEBUGMODE ?=` as `NDEBUG` until you decide to use the Debug features in your program.

- The other options are pretty self explanatory, and the comments at the top of the file will help with explanation.

- **IMPORTANT:** You will want to add `graphx fileioc keypadc` after `L :=` to be able to use the libraries.

# Editing your Program

So you have all these tools to create your program, but how do you actually go about doing it? Follow these steps to push away your confusion. (Some knowledge of C is recommended)

- Go to the `src` folder in your program directory, then open `main.c` with your editor.
- To make library commands work, you need to add the corresponding lines below the "standard" includes:

```c
#include <lib/ce/graphx.h>
#include <lib/ce/keypadc.h>
#include <lib/ce/fileioc.h>
```
- If you also add `#include <debug.h>`, it can make debugging easier as you can output messages in CEmu's console.
- In `void main(void) {}` add `gfx_Begin( gfx_8bpp );` to initialize the graphics canvas, and `gfx_End();` then `prgm_CleanUp();` at the end so your program ends cleanly.

You now have a program that opens, initializes the graphics, then closes! (Once you compile it, of course) To add more commands, check out the C library headers [here](https://github.com/CE-Programming/toolchain/tree/master/CEdev/include/lib/ce).  

The GRAPHX library has all sorts of commands to easily draw on the screen. 

# Making your Program (Compiling)

You have your code written, but you want to test out your program? Then `make` is the right command for you! It compiles your program, and if successful, creates a `*.8xp` in the /bin/ folder!

The gist of it is to open a command prompt/terminal, go to your project's folder (`cd [...]`), then run `make` (on Windows) or `wine [...]CEdev/bin/make.exe` (on Linux/Mac, after you've installed 'Wine').  
More details are available [here](https://www.cemetech.net/learn/C_SDK_Tips_and_Tricks#.22Making.22_the_program_2) (Windows) or [here](https://www.cemetech.net/learn/C_SDK_Tips_and_Tricks#.22Making.22_the_program) (Linux/Mac).

When that's done, go ahead and send the newly created `.8xp` file to CEmu or your calculator. Be sure you have the C libraries installed, and run it with `Asm(prgmPROGRAM`!

# Finishing Up

You should have just created, compiled, and tested a program that you made! Now that you have this knowledge, have fun creating programs and games!  
Don't forget that thanks to many programs being open-source, you can also learn by example, from their source code.

