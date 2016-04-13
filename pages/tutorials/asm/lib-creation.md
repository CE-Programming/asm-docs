---
layout: page
title: Creating C/ASM libraries
permalink: /tutorials/asm/lib-creation/
---

If you are looking to create an ASM or C library, this is the place! Simply follow the simple steps below.

# Creation

Navigate into your CE C standard library directory. Inside you will find a directory called *template*.

Create a copy of the *template* directory, and rename it to whatever your library does. For example, if it performs File I/O, call it something like *fileio*

Inside of your newly created directory, you will find the *Makefile*. Open this in your editor, and change the following lines:

```
LIB = TEMPLATE
SOURCES = template_lib.asm
```

**LIB**: The name of the library AppVar that will exist on your calculator. Try to make this somewhat descriptive.

**SOURCES**: This contains the name of the files you wish to use for your library. If you rename the *template_lib.asm* in your directory, you **must** update it here as well.

Now, close the *MakeFile*, and open the *template_lib.asm* file, or what you may have renamed it to. It should look like this:

```asm
#include "..\\..\\include\\relocation.inc"

 .libraryName		"TEMPLATE"   ; Name of library
 .libraryVersion	1            ; Version information (1-255)
 
 .function "ti_TemplateFunction",_TemplateFunction
 
 .beginDependencies
 .endDependencies
 
;--------------------------------------------------
_TemplateFunction:
; Solves the P=NP problem
; Arguments:
;  __frame_arg0 : P
;  __frame_arg1 : NP
; Returns:
;  P=NP
 ret

 .endLibrary
 ```

 Now, the very first thing you want to do is change this line:

```asm
 .libraryName		"TEMPLATE"
```

 **Make sure TEMPLATE is changed to the name of your AppVar that you set before in the *LIB* part of the Makefile!**

 The next line, ```.libraryVersion``` tells us which version this library is. If you add a function, it is necessary to update the version. If you simply change a function, or add more features to it, it is not necessary to update the version.

 **Note: Newer versions of libraries are *always* expected to be compatible with previous versions. Please don't be mean to users.**

 The lines containing ```.beginDependencies``` and ```.endDependencies``` is where you can use other libraries that you may be dependent on. More information can be found below, under the **Dependencies** heading.


# Programming

Great, now you are all set up! Let's start with how to program a library. First, note that libraries are a little different than writing straight assembly programs.

## Functions

The syntax for a function is:

```asm
.function "name",label
```

**{ name }**: Name of the function that you will use in your C/ASM code.

**{ label }**: The location in your library where your function is.

To insert a new function into your library, just insert a new line right below the previous function. So if you had a library with 3 functions, it would look something like this:

*You can only insert at the end of the list if you have already released a previous version.*

```asm
#include "..\\..\\include\\relocation.inc"

 .libraryName		"TEMPLATE"          ; Name of library
 .libraryVersion	1                   ; Version information (1-255)
 
 .function "ti_TemplateFunction1",_TemplateFunction1
 .function "ti_TemplateFunction2",_TemplateFunction2
 
 .beginDependencies
 .endDependencies
 
;--------------------------------------------------
_TemplateFunction1:
; Solves the P=NP problem
; Arguments:
;  __frame_arg0 : P
;  __frame_arg1 : NP
; Returns:
;  P=NP
 ret

;--------------------------------------------------
_TemplateFunction2:
; Solves the P=NP problem two times in a row
; Arguments:
;  __frame_arg0 : P
;  __frame_arg1 : NP
; Returns:
;  P=NP
 ret
 ret
 
 .endLibrary
```

Function arguments and return types are listed here: (or you can use the uint{x}_t definitions from *stdint.h*)

Type         |  Size
------------ | -------------
char         | 8 bits
short        | 16 bits
int          | 24 bits
long         | 32 bits
float        | 32 bits
double       | 32 bits

In C, functions receive arguments from the stack in reverse order. Say you call from C a function such as this:

```sample(10, 20, 30);```

Then you can pull arguments out like this in assembly:

```asm
_sample:
 push ix
  ld ix,0
  add ix,sp
  ld hl,(ix+__frame_arg0)  ; hl = 30
  ld de,(ix+__frame_arg1)  ; de = 20
  ld bc,(ix+__frame_arg2)  ; bc = 10
 pop ix
 ret
```

*__frame_argX* are defines that you can use to pull elements off the stack frame. `__frame_arg0` is defined as 6, and each is 3 bytes wide.

Here's a helpful table that lists the sizes and place on the stack for C arguments: (Stack memory goes from **Low** -> **High**)

Type         |  Size         | Stack Memory
------------ | ------------- | -------------
char         | 3 bytes       | xx ?? ??
short        | 3 bytes       | xx xx ??
int          | 3 bytes       | xx xx xx
long         | 6 bytes       | xx xx xx xx ?? ??
float        | 6 bytes       | xx xx xx xx ?? ??
double       | 6 bytes       | xx xx xx xx ?? ??
pointer      | 3 bytes       | xx xx xx

## Relocations

**Important note**: Because libraries are position-independent, this means that any usage of a ```call```, ```jp```, or absolute location **must** be relocated. The following shows how:

```asm
; Some library code...

_sample0:
 jp _sample2 \.r

_sample1:
 call _sample0 \.r
 jr _sample0

_sample2:
 ld de,$000000
 ld (libdata),de \.r
 ld hl,libtext \.r
 jp _PutS

libtext:
 .db "Test",0
libdata:
 .dl 100

; End Library Code
```

Note the ```\.r``` suffix on instructions. This tells the assembler to add the address to the relocation table, so that is can be position-independent. Do this when you make calls or absolute jumps within your program. Note that relative jumps **do not** require this.

There you are! Now you should be able to write your library in no time at all.

# Assembling

Once you are finished writing your library, you will want to open a command shell in your library's source directory. Simply type the command ```make```, which will assemble your library and produce some files.

One file is a **.8xv**; your library's AppVar which is sent to the calculator.

Another is a **.asm**, which is the linkable file that contains the jump table for your library.

Another is a **.lst**, which is simply the listing file for your assembly source. This is primarily used for debugging purposes.

The file **relocation_table** is created if your library uses absolute relocations. You can delete it if you want.

# Creating your header file

When you assemble your library, a .asm file is generated for you. All you need to do is create the C prototypes for your functions. A sample header might look something like this:

```c
/**
 * @file    TEMPLATE CE C Library
 * @version 1.0
 */

#ifndef H_TEMPLATE
#define H_TEMPLATE

/**
 * Solves the P=NP problem
 */
int ti_TemplateFunction(int p, int np);

#endif // H_TEMPLATE
```

# Finishing Up

Great, now your header file should be complete. Now for one of the harder parts. From your base C toolchain installation, copy your header file and outputted `.asm`

Now, whenever you want to use your libraries functions in your program, simply do:

```c
#include <template.h>
```

Where *template.h* is the name of the header file you copied.

# Dependencies

Dependencies are other libraries that your library relies on. You can simply include the outputted `.asm` file from an existing library in this section, or if you only plan to use a couple or so functions of the library, you can save space by only including the header inforamtion and the jump equates. Recursive libarary dependencies are supported. Don't forget to use the `\.r` syntax when you make calls to dependencies!

# Some important notes

In order to use your library, you must have LibLoad installed, along with your library's binary. Please note that LibLoad itself is merely a tool that is used to link your library to the users' program.
