---
layout: page
title: ASM Environment Setup
permalink: /setup/asmsetup.html
---

Welcome! Here you will find the necessary tools for programming in eZ80 assembly. Be sure to follow along carefully so you can be up and ready in no time.

# Steps

As it is a good idea to get familiar with a command shell when doing actual development, this guide will aid you in that process. Simply open a command window, either the command prompt in windows or a similar variant. You can find information on using the shell and available commands for Windows [**here**](http://ss64.com/nt/).

Now, input the following command: `mkdir CEasm/include CEasm/tools & cd CEasm` on Windows, or `mkdir -p CEasm/include CEasm/tools && cd CEasm` on Linux / OS X.

The **mkdir** command creates a directory, here called *CEasm*, with two subdirectories called *include* and *tools*. The **cd** command then navigates inside of the *CEasm* directory, which we will be using to place all of our example code in.

Now, input the following command: `echo.>include/ti84pce.inc` on Windows, or `touch include/ti84pce.inc` on Linux / OS X.

This will create an empty file called *ti84pce.inc* in the *include* directory.

Now, we are going to add some information to this file. Open the *ti84pce.inc* file in your favorite editing software, such as notepad. If you aren't sure where the file is if you are use a nice GUI such as Windows, simply look at what the path says in the window, for example, *C:\Users\Mateo\CEasm*, which tells you exactly where to go.

Open the the CE [**Include File**](http://wikiti.brandonw.net/index.php?title=84PCE:OS:Include_File) and copy everything inside the gray container box, paste it into the *ti84pce.inc* file, save, and exit.

Now, you are going to need an assembler. Simply put, an assembler will translate your assembly-flavored code into something that the calculator can execute. Remember, the calculator has no idea what 'code' even is, and can only do what you tell it to.

The latest version of spasm-ng, an eZ80 assembler, can be found [**here**](https://github.com/alberthdev/spasm-ng/releases). You may want to build it from the source code to get the latest features/bugfixes, if possible.

Place spasm-ng into the *tools* directory, and be sure to rename it to **spasm.exe** (or just **spasm** on Linux / OS X) if it is not already.

Now you are ready to begin your journey into programming in assembly!

Let us begin with the first tutorial.
1. [Getting started]({{ site.baseurl }}/tutorials/asm/gettingstarted.html)
