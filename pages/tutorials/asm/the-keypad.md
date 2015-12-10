---
layout: page
title: The Keypad
permalink: /tutorials/asm/the-keypad/
---

Inside of your *CEasm* directory that you created in the [**setup**]({{site.baseurl}}/setup/asm-setup) guide, create a new folder called *tutorial_2*. Now, inside the *tutorial_1* directory, create a file called *main.asm*. This is the file in which you will be placing all of the following code.

As you may have noticed, this is precisely the same layout in Tutorial 1. This is the standard tutorial template, and will be applied to all subsequent tutorials in order to organize your code. So, your *CEasm* directory should look something like this now:

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
```

# Introduction

Today we are going to be learning how to directly interact with the keypad in order to move a square around on the screen.

You can find the keypad hardware documentation [**here**](http://wikiti.brandonw.net/index.php?title=84PCE:Ports:A000).

# The Code

Let us begin with a simple routine to draw a square. Since we are in 8bpp mode, this becomes fairly trivial, as all we have to do is draw a horizontal line, and repeat this for however tall the square is.

Note that we have also set up our default palette.

```
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; DrawRectangle
; inputs:
;         de = x
;          l = y
;         bc = width
;          a = height
;  rectColor = color of rectangle
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
DrawRectangle:
 ld h,lcdWidth/2       ; hl=160
 mlt hl                ; 160*y
 add hl,hl             ; hl*2
 add hl,de             ; add x
 ld de,vRam
 add hl,de             ; offset vRam
 dec bc                ; for ldir
FillRect_Loop:
rectColor = $+1
 ld (hl),0
 push hl
 pop de
 inc de
 push bc
  ldir                 ; draw line
 pop bc
 ld de,lcdWidth
 add hl,de             ; move down
 sbc hl,bc
 dec a
 jr nz,FillRect_Loop
 ret
```

Now that we have the code to draw a rectangle, we need to understand how the keypad controller works. Per the [**WikiTI page**](http://wikiti.brandonw.net/index.php?title=84PCE:Ports:A000), the simplest way to scan is to perform a single scan. The following code accomplishes that:

(**Note:** interrupts must be disabled when executing this code in order to prevent the OS from taking control).

```
 di
 ld hl,DI_Mode  ; Register for keypad mode
 ld (hl),2      ; Set Single Scan mode

 xor a,a
scan_wait:
 cp a,(hl)      ; Wait for Idle mode
 jr nz,scan_wait

 ; Read data registers here as needed
```

Great, now we can get input from the keypad. But where is this data located? Since the keypad is a part of the memory-mapped port range, it exists in the $F50000 address space.

The following table will breaks it down:

Address | Equate | Bit 0 | Bit 1 | Bit 2 | Bit 3 | Bit 4 | Bit 5 | Bit 6 | Bit 7
------- | ------ | ----- | ----- | ----- | ----- | ----- | ----- | ----- | -----
F50010	|		 |		 |		 |	     |       |       |       |       |
F50012	| kbdG1  | graph | trace | zoom	 | wind	 | y=	 | 2nd	 | mode	 | del
F50014	| kbdG2  | sto	 | ln	 | log	 | x^2	 | x^-1	 | math  | alpha |
F50016	| kbdG3  | 0	 | 1	 | 4	 | 7	 | ,	 | sin	 | apps	 | XNOT
F50018	| kbdG4  | .	 | 2	 | 5	 | 8	 | (	 | cos	 | prgm	 | stat
F5001A	| kbdG5  | (-)	 | 3	 | 6	 | 9	 | )	 | tan	 | vars	 | 
F5001C	| kbdG6  | enter | +	 | -	 | *	 | /	 | ^	 | clear | 
F5001E	| kbdG7  | down	 | left  | right | up    |       |       |       | 

Then, each bit is also given an equate, which follows the pattern: ```kbit{keyname}```.

So, the graph key bit name would be ```kbitGrah```, and others such as ```kbitAlpha```, ```kbdComma```, and ```kbitLParen```.

You can find all the available keypad equates [**here**]({{site.baseurl}}/resources/keypad-equates).

Now, we want to move the square around using the arrow keys. From the above table, we can see the arrow keys exist in ```kbdG7```. So, we just need to read ```kbdG7```, and then check the bit pattern.

Here's some code that reads the keypad, and then accordingly executes the correct routine to move the square:

```
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
```
 
 Now, what do all of the ```Request{xxxx}``` routines look like? Here's one way of implementing it:
 
```
RequestUp:
 ld a,(yPos)
 dec a
 ret z              ; return if @ 1
 ld (yPos),a
 ret
 
RequestRight:
 ld hl,(xPos)
 inc hl
 ld de,lcdWidth
 or a,a 
 sbc hl,de 
 add hl,de
 ret z              ; return if @ 319
 ld (xPos),hl
 ret
 
RequestLeft:
 ld hl,(xPos)
 dec hl
 add hl,de 
 or a,a 
 sbc hl,de
 ret z              ; return if @ 1
 ld (xPos),hl
 ret
 
RequestDown:
 ld a,(yPos)
 inc a
 cp lcdHeight
 ret z              ; return if @ 239
 ld (yPos),a
 ret
```

But wait. Where are `yPos` and `xPos` located? Again, [**WikiTI**](http://wikiti.brandonw.net/index.php?title=Category:84PCE:RAM:By_Address) tells us that we have **69090** bytes of safeRAM, or free bytes that our program can use for whatever purpose, as long as we clean up after.

Add these equates to the top of your code then:

```
xPos    equ pixelShadow2
yPos    equ xPos+3
```

Now we have the code to move a rectangle, and the code to draw a rectangle. So, we need some code to actually update the screen if a key is pressed.

Note that if we simply redraw the square, the old square won't be erased. AS of right now, we have two options:

* Clear the screen on each redraw
* Only redraw the portions that the rectangle shifted by

Option one is the perfered choice for now. In the next tutorial we will learn more about drawing to the LCD.

This subroutine should preform what we need. First, it clears the screen, and then draws the new rectangle posistion. From the key input code block, you can now see where `RedrawScreen` comes from.

```
RedrawScreen:
 ld hl,vram
 ld bc,(lcdWidth*lcdHeight)-1
 call _MemClear         ; Set the LCD background to black
 
 ld a,RECT_COLOR_I      ; change the color of the rectangle
 ld (rectColor),a
 
 ld de,(xPos)
 ld hl,(yPos)
 ld a,RECT_WIDTH
 ld bc,RECT_HEIGHT
 jp DrawRectangle
```

`RECT_WIDTH`, `RECT_HEIGHT`, and `RECT_COLOR_I` are simply defines you can add to the top of your code:

```
#define RECT_WIDTH      10
#define RECT_HEIGHT     10
#define RECT_COLOR_I    255     ; white
```

Of course, the next reasonable question is, how do I put this all together? 

First, you need an your key input to be in a loop, so that way you can continously poll data from the keypad.

This program demonstrates how one might do that. Now, you should be able to move your rectangle across the screen. Some fun challenges:

* Slow down the speed of the rectangle movement
 * (Hint: Loop for a long time)
* Change the background color of the screen from black
* Add some more functions using the keypad
 * Center the rectangle if the [2ND] key is pressed
 * Add movement of multiple rectangles

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
 ld hl,vram
 ld bc,(lcdWidth*lcdHeight)-1
 call _MemClear         ; Set the LCD background to black
 
 ld a,RECT_COLOR_I      ; change the color of the rectangle
 ld (rectColor),a
 
 ld de,(xPos)
 ld hl,(yPos)
 ld a,RECT_WIDTH
 ld bc,RECT_HEIGHT
 ;jp DrawRectangle      ; Commented because we just run into this subroutine
 
DrawRectangle:
 ld h,lcdWidth/2        ; hl=160
 mlt hl                 ; 160*y
 add hl,hl              ; hl*2
 add hl,de              ; add x
 ld de,vRam
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