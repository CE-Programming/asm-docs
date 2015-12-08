---
layout: page
title: Creating C/ASM libraries
permalink: /tutorials/asm/libcreation.html
---

If you are loking to create an ASM or C library, this is the place! Simply follow the simple steps below.

# Creation

Navigate into your CE C toolchain installation directory. Inside the *shared_libs* directory, you will find another directory called *template*. 

Create a copy of the *template* directory, and rename it to whatever your library does. For example, if it performs File I/O, call it something like *fileio*

Inside of your newly created directory, you will find the *MakeFile*. Open this in your editor, and change the following lines:

```
LIB = TEMPLTE
SOURCES = template.asm
```

**LIB** is the name of the library AppVar that will exist on your calculator. Try to make this somewhat descriptive.

**SOURCES** This countains the name of the files you wish to use for your library. If you rename the *template.asm* in your directory, you **must** also update it here.

Now, close the *MakeFile*, and open the *template.asm* file, or whatever you have renamed it to. It should look something like this:

```asm
#include "../include/relocation.inc"

 .libraryName		"TEMPLTE"
 .libraryVersion	1
 
 .function "sample",_sample
 
 .beginDependencies
 .endDependencies

;== Start Library Code

_sample:
 ret

;== End Library Code

 .endLibrary
 ```
 
 Now, the very first thing you want to do is change this line:
 
 ```
 .libraryName		"TEMPLTE"
 ```
 
 **Make sure TEMPLTE is changed to the name of your AppVar that you set before in the *LIB* part of the Makefile!**
 
 The next line, ```.libraryVersion``` tells us which version this library is. If you add a function, it is nessasary to update the version. If you simply change a function, or add more features to it, it is not nessasary to update the version.
 
 **Note: Newer versions of libraries are *always* expected to be compatible with previous versions.**

# Programming
