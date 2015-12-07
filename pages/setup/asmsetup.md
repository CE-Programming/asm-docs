---
layout: page
title: ASM Enviornment Setup
permalink: /setup/asmsetup.html
---

Welcome! Here you will find the nessasary tools for programming in eZ80 assembly. Be sure to follow along carefully so you can be up and ready in no time.

# Windows

Create a folder in your somewhere on your computer called 'CEasm'

Navigate into this folder and make another folder, this one called 'myfirstasmprgm'

Create a new file in the 'myfirstasmprgm' directory called 'main.asm'. This is where you will place all of the code you write.

Next, create a new file in the 'myfirstasmprgm' directory called 'ti84pce.inc'. This is an include file, which defines 

Now, you will need the include file for the TI-84+CE/TI83PCE calculator line. It is constantly being updated; you can find the latest version here: [CE Include File]http://wikiti.brandonw.net/index.php?title=84PCE:OS:Include_File)

Simply copy all the text on that page within the gray box into the 'ti84pce.inc' file, save, and exit.

Now, you are going to need an assembler. Simply put, this assembler will translate your assembly-flavored code into something that the calculator can execute. Remember, the calculator has no idea what 'code' even is, and can only do what you tell it to.

The latest version of SPASM-NG, an eZ80 assembler, can be found here: [SPASM-NG](https://github.com/alberthdev/spasm-ng/releases)

Place SPASM-NG into 'myfirstasmprgm' directory, and rename it to 'spasm.exe', if it is not already.


