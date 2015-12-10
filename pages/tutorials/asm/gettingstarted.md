---
layout: page
title: Getting Started
permalink: /tutorials/asm/gettingstarted.html
---

The tutorials in this guide assume that you have a decent knowledge of eZ80 assembly. However, if you have no idea where to begin, you will first want to begin with the updated version of [**Asm in 28 Days**](http://media.taricorp.net/83pa28d/lesson/toc.html#lessons), and then introduce yourself to the small changes with the new eZ80 processor, located [**here**]({{site.baseurl}}/tutorials/asm/ez80diff.html).

The end result of all these tutorials is to construct a simple game of snake, starting with the basics and working towards more advanced things. 

Inside of your *CEasm* directory that you created in the [**setup**]({{site.baseurl}}/setup/asmsetup.html) guide, create a new folder called *tutorial_1*. Now, inside the *tutorial_1* directory, create a file called *main.asm*. This is the file in which you will be placing all of the following code.

# The Template

This is the default template for all CE assembly programs. Simply copy and paste into the *main.asm* file.

```asm
#include "..\include\ti84pce.inc"
.assume ADL=1
.db     texttok,tasm84cecmp
.org    usermem

; Start of program code
```

# Introduction

We are first going to understand how the CE LCD functions. To get things to display on the screen, the easiest thing to do is to write to the LCD memory (VRAM/GRAM, starting at address D40000h). VRAM is 320*240*2 (153600) bytes in size.

However, the LCD supports countless permutations of opperation. The OS normally operates in [16 bits per pixel (bpp)](https://en.wikipedia.org/wiki/High_color), or 16-bit high color with green containing the extra bit. However, while 16bpp is useful for full-color graphics and things, it tends to be quite slow when doing extremely intensive graphical effects, as it must draw 153600 bytes per frame. This is why this tutorial advocates for palettized [8 bits per pixel](https://en.wikipedia.org/wiki/8-bit_color), where the color data is stored in 1555 color, where 1=intensity, and 555=rgb respectively in the LCD palette memory. This not only makes it easy to compute the x and y offset for a pixel, but also leads to amazing graphical performance, and a possiblity for double buffering.

# The Code

As you reach a code block, read the description and append it to the *main.asm* file you have, which should currently hold the template.

First, most programs begin by turning off the OS run indicator and disabling interrupts. This can be accomplished quite quickly with:

```asm
 di
 call _RunIndicOff
```

Next, we since our program is going to be using 8bpp mode, we need to set up the palette. This can be done many ways, simply by writting the color data in 16 bit increments to the palette memory. This code will create the following palette, which is highly useful.

```asm
Create1555Palette:
 ld hl,mpLcdPalette				; MMIO address of LCD Palette
 ld b,0
_cp1555loop:
 ld d,b
 ld a,b
 and %11000000
 srl d
 rra
 ld e,a
 ld a,%00011111
 and b
 or e
 ld (hl),a
 inc hl
 ld (hl),d
 inc hl
 inc b
 jr nz,_cp1555loop
```
![1555 Palette]({{site.baseurl}}/images/tutorials/asm/rgbhlpalette.png "Special thanks to Shaun 'Merthsoft' McFall for generating this image")
Now that the palette is set to the above image, we should clear the screen so that it doesn't cause weird graphical effects when switching modes. Then we can enable 8bpp mode. The code below will accomplish both of these tasks:

```
 call _clearVRAM    ; Set all of VRAM to $FF
 ld a,lcdbpp8
 ld (mpLcdCtrl),a
```

Congradulations! Now if you write the number $23 into the LCD data located at VRAM, the pixels will be set to a green color, and if you write a $E0, the color will be red, as shown in the palette.

