---
layout: page
title: Double Buffering
permalink: /tutorials/asm/double-buffering/
---

As before, create a new directory called *tutorial_3*, and from within create the file called *main.asm*

Current directory structure:

```
 CEasm
    |
    include
    |
    tools
    |
    tutorial_1
    |
    tutorial_2
    |
    **tutorial_3**
```

# Introduction

In computer graphics, double buffering refers to drawing graphics out of the user's view, and then transfering the drawn data all at once to the screen.

This prevents the weird graphical effects you may have seen in the previous tutorial, where we cleared the screen and then updated the rectangle, where there was a few milliseconds where the screen is completely black.

Now, the two main methods of double buffering are known as **blitting** and **page flipping**. For the curious, here's a short explanation on each: [**Double Buffering**](https://docs.oracle.com/javase/tutorial/extra/fullscreen/doublebuf.html)

# The Code

## Blitting

Taking the finished code from [**tutorial 2**]({{site.baseurl}}/tutorials/asm/the-keypad), let's modify it to use the first method of double buffering, which is simply copying our drawn data to the screen.

So, rather than drawing to the start of VRAM, since we are in 8bpp mode, we can use VRAM+(320*240) as our back buffer.

Some equates for working with double buffering:

```
screenData  equ vram
bufData     equ vram+(320*240)
```

Now, we need to write some code that will copy our finished data to the screen. This simple ldir technique can accomplish this.

```
blitScreen:
 ld hl,bufData
 ld de,screenData
 ld bc,(lcdWidth*lcdHeight)-1
 ldir
 ret
```

Now, when we draw anything to the screen, we use `bufData` as our drawing location. When we are ready to copy data to the screen, we simply call `blitScreen`, and all of our graphical data is copied directly.

So if we used to write to `vram`, now we write to `bufData`.

Here's what tutorial_2 now looks like: (notice the small amount of changes that we made)

```
#include "../include/ti84pce.inc"

#define RECT_WIDTH      10
#define RECT_HEIGHT     10
#define RECT_COLOR_I    255     ; white

xPos    equ pixelShadow2
yPos    equ xPos+3

.assume ADL=1
.db     tExtTok,tAsm84CECmp
.org    userMem

; Start of program code
 di
 call _RunIndicOff
 
create1555Palette:
 ld hl,mpLcdPalette	    ; MMIO address of LCD Palette
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
 jr nz,_cp1555loop      ; Set up palette

 call _clearVRAM        ; Set all of VRAM to $FF (white)
 ld a,lcdbpp8
 ld (mpLcdCtrl),a
 
MainPrgmLoop:
 di
 ld hl,DI_Mode          ; Register for keypad mode
 ld (hl),2              ; Set Single Scan mode

 xor a,a
scan_wait:
 cp a,(hl)              ; Wait for Idle mode
 jr nz,scan_wait

 ; Read data registers here as needed
 ld a,(kbdG6)
 bit kbitClear,a
 jp nz,ExitPrgm         ; Exit the program if [CLEAR] is pressed
  
 ld a,(kbdG7)
 push af
  bit kbitUp,a
  call nz,RequestUp     ; Is [UP] pressed?
  
 pop af \ push af
  bit kbitRight,a
  call nz,RequestRight  ; Is [RIGHT] pressed?
  
 pop af \ push af
  bit kbitLeft,a
  call nz,RequestLeft   ; Is [LEFT] pressed?
  
 pop af \ push af
  bit kbitDown,a
  call nz,RequestDown   ; Is [DOWN] pressed?
 
 pop af
 or a,a
 call nz,RedrawScreen   ; If a key is pressed, update the screen
 
 jp MainPrgmLoop
 
RequestUp:
 ld a,(yPos)
 dec a
 ret z                  ; return if @ 1
 ld (yPos),a
 ret
 
RequestRight:
 ld hl,(xPos)
 inc hl
 ld de,lcdWidth
 or a,a 
 sbc hl,de 
 add hl,de
 ret z                  ; return if @ 319
 ld (xPos),hl
 ret
 
RequestLeft:
 ld hl,(xPos)
 dec hl
 add hl,de 
 or a,a 
 sbc hl,de
 ret z                  ; return if @ 1
 ld (xPos),hl
 ret
 
RequestDown:
 ld a,(yPos)
 inc a
 cp lcdHeight
 ret z                  ; return if @ 239
 ld (yPos),a
 ret
 
RedrawScreen:
 ld hl,bufData
 ld bc,(lcdWidth*lcdHeight)-1
 call _MemClear         ; Set the LCD background to black
 
 ld a,RECT_COLOR_I      ; change the color of the rectangle
 ld (rectColor),a
 
 ld de,(xPos)
 ld hl,(yPos)
 ld a,RECT_WIDTH
 ld bc,RECT_HEIGHT
 call DrawRectangle
 ;jp blitScreen         ; Commented because we just run into this subroutine
 
blitScreen:
 ld hl,bufData
 ld de,screenData
 ld bc,(lcdWidth*lcdHeight)-1
 ldir
 ret
 
DrawRectangle:
 ld h,lcdWidth/2        ; hl=160
 mlt hl                 ; 160*y
 add hl,hl              ; hl*2
 add hl,de              ; add x
 ld de,bufData
 add hl,de              ; offset vRam
 dec bc                 ; for ldir
FillRect_Loop:
rectColor = $+1
 ld (hl),$FF
 push hl
 pop de
 inc de
 push bc
  ldir                  ; draw line
 pop bc
 ld de,lcdWidth
 add hl,de              ; move down
 sbc hl,bc
 dec a
 jr nz,FillRect_Loop
 ret
 
ExitPrgm:
 call _ClrScrn          ; Clear the screen (white)
 ld a,lcdbpp16
 ld (mpLcdCtrl),a
 call _DrawStatusBar
 ei
 ret                    ; Return to TI-OS
```

## Page Flipping

Page flipping is a little more advanced, as it requires the use of LCD interrupts in order to make sure we can switch the VRAM pointer at the correct time. If we do not, this can cause weird scanlines and other graphical artifacts we don't want to happen.

# Finishing Up
