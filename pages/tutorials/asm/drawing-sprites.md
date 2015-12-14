---
layout: page
title: Drawing Sprites
permalink: /tutorials/asm/drawing-sprites/
---

Now for the fun part. We are going to learn how to draw sprites on the screen, and rather than simply trying to manually build a sprite, we can use some prebuilt software to do it for us.

# Introduction

First, let us begin with a simple sprite such as this famialar one:

![1555 Palette]({{site.baseurl}}/images/tutorials/asm/mushroomsprite.png "+1 life!")

Notice that we want to use the pink color as a transparent color, so that we can move it over other things. This is fairly easy to do in code, as we will see later on.

Now, how do I convert this image to be used in 8bpp mode? Isn't there a palette that I have to use?

To convert your images, you will need this tool:

Now, simply place *convimage* within your *tools* directory, which is again located inside of your *CEasm* installation directory.

# The Code

Now, we first want to convert this image so we can see how to use it. Copy the above mushroom sprite into your *tutorial_4* directory and call it `mushroomsprite.png`

Then in the command line, from your *tutorial_4* directory, type:

```
..\\tools\\convimage -8z -i mushroomsprite.png
```

This will create a new file in the *tutorial_4* directory called *mushroomsprite.asm*. This is the converted data for your sprite, and includes the palette that you can use as well in 8bpp mode.

Next inside your *main.asm* file, start with this template:

```asm
#include "..\include\ti84pce.inc"
.assume ADL=1
.db     tExtTok,tAsm84CECmp
.org    userMem

; Start of program code

; End program code
; Start of data section

#include "mushroomsprite.asm"

; End data section
```

Notice that we are simply including our converted sprite data into our main file.

Now, because the sprite uses a different palette than our default one, we must copy it to the palette memory. As we can see in the converted sprite data file, `_mushroomsprite_pal_start` and `_mushroomsprite_pal_end` represent the start and end of our palette. Here's some simple code to copy our palette to memory:

```asm
ld hl,_mushroomsprite_pal_start
ld de,mpLcdPalette
ld bc,(_mushroomsprite_pal_end-_mushroomsprite_pal_start)-1
ldir
```

Now our sprite's palette is set up in memory. Next, we simply need to copy the sprite data to the screen in order to display it. This can be accomplished quite simply be copying the data in rows. Looking at the outputted data, we note that it prefixes the sprite data with:

```asm
_mushroomsprite_start
 db 32,32
```
Where `32,32` stand for `spriteWidth,spriteHeight` respectively.

So, we need a sprite routine that will copy 32 bytes of data for each row, increment to the next row, and repeat this operation for 32 times. This is some genearic code to get you started:

```asm
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; DrawSprite
; inputs:
;         bc = x
;          l = y
;         de = pointer to sprite
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
DrawSprite:
 ld h,lcdWidth/2       ; hl=160
 mlt hl                ; 160*y
 add hl,hl             ; hl*2
 add hl,bc             ; add x
 ld bc,vRam
 add hl,bc             ; offset vRam
 ld a,(de)             ; width
 ld (SpriteWidthSMC),a
 inc de
 ld a,(de)             ; height
 inc de
 ex de,hl
drawSpriteLoop:
SpriteWidthSMC: =$+1
 ld bc,0
 push de
  ldir                 ; draw line
 pop de
 ex de,hl
  ld bc,lcdWidth
  add hl,bc             ; move down
 ex de,hl
 dec a
 jr nz,drawSpriteLoop
 ret
```

# Advanced uses of the converter

# Finishing Up

Let's keep going! [**Tutorial 5: The VAT**]({{site.baseurl}}/tutorials/asm/the-vat/)