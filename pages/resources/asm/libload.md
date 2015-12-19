---
layout: page
title: Keypad Equates
permalink: /resources/asm/libload/
---

# Introduction

This page aims to document the setup of libraries and operations performed by LibLoad, the on-calc library dynamic relocator.

# Setup

Libraries are contained within a single appvar, and consist of 4 main sections: the header, the functions, any dependencies, and finally the code itself.

The following describes the format taken after assembling. If you are looking for how to create libraries, [**this page**]() will guide you.

## The Header

A sample header begins with 2 idendifying bytes:

```asm
$C0,$C0
```

This simply lets us know that the following data is a valid library.

These bytes are then followed by the library version byte; for example, this would represent version 4:

```asm
$04
```

And that is all the header contains.

## The Functions

Functions are also stored in the library binary as entries in a vector table. A sample vector table looks like this:

(Note that assembled code is on the left, while the original file is shown on the right)

```asm
0F 00 00 -   .function "void","function_1","void",_function_1_label
1D 00 00 -   .function "void","function_2","void",_function_2_label
```

The preceeding bytes simply represent the offset in the library where the function is located.

## Dependencies

This is where it gets kind of fun. Since dependencies are a part of the library in order to have an address to jump to, dependencies are simply the outputted jump table when assembling a library.

A sample library with a single dependency on LIB1 will look like this:

```asm
C0 4C 49 42 
31 00 -  -   db 0C0h,"LIB1",0
01 -  -  -   db 1
-  -  -  -  _function_1 equ $
C3 00 00 00  jp 0
-  -  -  -  _function_2 equ $
C3 03 00 00  jp 3
```

**Important note:** Since dependencies are resolved as a part of code, they are also considered code. Thus, from before, function offsets are calculated from the start of the dependency table, not the end of it.

## The Code

The code of the library is simply whatever the developer decides to add to the library. Some examples include file I/O, and many other things.


# Relocation

When the assembler hits a **.r** or **.r2** macro, it stores the current location counter +1 or +2 respectively to the relocation table. The relocation table is then placed after the code section.

After the relocation information is two special words: one which holds an offset pointer to the start of the dependency table, and one that holds the size of the library if it were to be extraceted to RAM.

This size consists of the dependencies+code portions; no header, function, or anything else is included.

# LibLoad Process

The process taken by LibLoad is breifly summarized in the following flowchart:

![LibLoad]({{site.baseurl}}/images/resources/libload/flowchart.png "A.K.A absoulte madness")

