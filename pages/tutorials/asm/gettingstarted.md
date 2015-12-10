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
.db     tExtTok,tAsm84CECmp
.org    userMem

; Start of program code
```

# Introduction

We are first going to understand how the CE LCD functions. To get things to display on the screen, the easiest thing to do is to write to the LCD memory (VRAM/GRAM, starting at address $D40000). VRAM is 320*240*2 (153600) bytes in size.

However, the LCD supports countless permutations of operation. The OS normally operates in [16 bits per pixel (bpp)](https://en.wikipedia.org/wiki/High_color), or 16-bit high color with green containing the extra bit. However, while 16bpp is useful for full-color graphics and things, it tends to be quite slow when doing intensive graphical effects, as it must draw 153600 bytes per frame. This tutorial advocates for using palettized [8 bits per pixel](https://en.wikipedia.org/wiki/8-bit_color), where the color data is arranged in 1555 color, where 1=intensity, and 555=rgb respectively in the LCD palette memory. This not only makes it easy to compute the x and y offset for a pixel, but also leads to improved drawing performance, and a possibility for double buffering.

# The Code

As you reach a code block, read the description and append it to the *main.asm* file you have, which should currently hold the template.

First, most programs begin by turning off the OS run indicator and disabling interrupts. This can be accomplished quite quickly with:

```asm
 di
 call _RunIndicOff
```

Next, since our program is going to be using 8bpp mode, we need to set up the palette. This can be done many ways, simply by writing the color data in 16 bit increments to the palette memory. This code will create the following palette, which is highly useful.

```asm
create1555Palette:
 ld hl,mpLcdPalette				; MMIO address of LCD Palette
 ld b,0
_cp1555Loop:
 ld d,b
 ld a,b
 and a,%11000000
 srl d
 rra
 ld e,a
 ld a,%00011111
 and a,b
 or a,e
 ld (hl),a
 inc hl
 ld (hl),d
 inc hl
 inc b
 jr nz,_cp1555Loop
```
![1555 Palette]({{site.baseurl}}/images/tutorials/asm/rgbhlpalette.png "Special thanks to Shaun 'Merthsoft' McFall for generating this image")
Now that the palette is set to the above image, we should clear the screen so that it doesn't cause weird graphical effects when switching modes. Then we can enable 8bpp mode. The code below will accomplish both of these tasks:

```
 call _clearVRAM    ; Set all of VRAM to $FF (white)
 ld a,lcdbpp8
 ld (mpLcdCtrl),a
```

Great! Now if you write the number from corresponding to the palette into the LCD data located at VRAM, the pixels will be set to the color at that palette offset.

Now, let's fill the screen with your favorite color. Simply choose one of the color indexes, and add it to the following code:

```
 ld a,$E0           ; Place your favorite color index here
 ld hl,vram
 ld bc,(lcdWidth*lcdHeight)-1
 call _MemSet
```

And then let's add a small key wait loop so we can see the results:

```
waitForEnter:
 call _GetCSC
 cp skEnter
 jr nz,waitForEnter
```

Once we end our key loop, we then need to do some common cleanup in order to properly return to the TI-OS. This includes redrawing the status bar, and restoring 16bpp, along with a few other optional items. Here's some example exiting code:

```
 call _ClrScrn
 ld a,lcdbpp16
 ld (mpLcdCtrl),a
 call _DrawStatusBar
 ei
 ret
```
 
# Finishing Up
 
Congratulations! You have just completed the first tutorial. It is simple in order to get you started. The following tutorials will move at a somewhat faster pace. In case you didn't quite catch all of the code, here is the resultant:

Let's keep going!

```
#include "..\include\ti84pce.inc"
.assume ADL=1
.db     tExtTok,tAsm84CECmp
.org    userMem

; Start of program code
 di
 call _RunIndicOff
 
create1555Palette:
 ld hl,mpLcdPalette				; MMIO address of LCD Palette
 ld b,0
_cp1555loop:
 ld d,b
 ld a,b
 and a,%11000000
 srl d
 rra
 ld e,a
 ld a,%00011111
 and a,b
 or a,e
 ld (hl),a
 inc hl
 ld (hl),d
 inc hl
 inc b
 jr nz,_cp1555loop
 
 call _clearVRAM    ; Set all of VRAM to $FF (white)
 ld a,lcdbpp8
 ld (mpLcdCtrl),a
 
 ld a,$E0           ; Place your favorite color index here
 ld hl,vram
 ld bc,(lcdWidth*lcdHeight)-1
 call _MemSet
 
waitForEnter:
 call _GetCSC
 cp skEnter
 jr nz,waitForEnter
 
 call _ClrScrn
 ld a,lcdbpp16
 ld (mpLcdCtrl),a
 call _DrawStatusBar
 ei
 ret
```
