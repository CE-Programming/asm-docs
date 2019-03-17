## Direct Keypad Input

Today we are going to be learning how to directly interact with the keypad in order to move a square around on the screen.

You can find the keypad hardware documentation [**here**](http://wikiti.brandonw.net/index.php?title=84PCE:Ports:A000).

# The Code

Let us begin with a simple routine to draw a square. Since we are in 8bpp mode, this becomes fairly trivial, as all we have to do is draw a horizontal line, and repeat this for however tall the square is.

Note that we have also set up our default palette.

```asm
;----------------------------------------
; draw_rectangle
; inputs:
;         de = x
;          l = y
;         bc = width
;          a = height
;  rcolor = color of rectangle
;  this routine can be greatly optimized!
;----------------------------------------
draw_rectangle:
	ld	h,ti.lcdWidth / 2	; h = 160
	mlt	hl			; 160 * y
	add	hl,hl			; hl * 2
	add	hl,de			; add x coordinate
	ld	de,ti.vRam
	add	hl,de			; offset vRam
	dec	bc			; for ldir
.loop:
	ld	(hl),0
.color := $ - 1
	push	hl
	pop	de
	inc	de
	push	bc
	ldir				; draw line
	pop	bc
	ld	de,ti.lcdWidth
	add	hl,de			; move down
	sbc	hl,bc
	dec	a
	jr	nz,.loop
	ret
```

Now that we have the code to draw a rectangle, we need to understand how the keypad controller works. Per the [**WikiTI page**](http://wikiti.brandonw.net/index.php?title=84PCE:Ports:A000), the simplest way to scan is to perform a single scan. The following code accomplishes that:

(**Note:** interrupts must be disabled when executing this code in order to prevent the OS from taking control).

```asm
	di
	ld	hl,ti.DI_Mode		; register for keypad mode
	ld	(hl),2			; set single scan mode

	xor	a,a
scan_wait:
	cp	a,(hl)			; wait for keypad idle mode
	jr	nz,scan_wait

; Read data registers here as needed
```

Great, now we can get input from the keypad. But where is this data located? Since the keypad is a part of the memory-mapped port range, it exists in the `0xF50000` address space.

The following table breaks it down:

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

You can find all the available keypad equates [**here**](../appendix/keypad-equates.md).

Now, we want to move the square around using the arrow keys. From the above table, we can see the arrow keys exist in ```kbdG7```. So, we just need to read ```kbdG7```, and then check the bit pattern.

Here's some code that reads the keypad, and then accordingly executes the correct routine to move the square:

```asm
request_up:
	ld	a,0
yPos := $ - 1
	dec	a
	ret	z			; return if @ 1
	ld	(yPos),a
	ret

request_right:
	ld	hl,0
xPos := $ - 3
	inc	hl
	ld	de,ti.lcdWidth
	or	a,a
	sbc	hl,de
	add	hl,de
	ret	z			; return if @ 319
	ld	(xPos),hl
	ret

request_left:
	ld	hl,(xPos)
	dec	hl
	add	hl,de
	or	a,a
	sbc	hl,de
	ret	z			; return if @ 1
	ld	(xPos),hl
	ret

request_down:
	ld	a,(yPos)
	inc	a
	cp	a,ti.lcdHeight
	ret	z			; return if @ 239
	ld	(yPos),a
	ret
```

But wait. Where are `yPos` and `xPos` actually located? The special `xPos := $ - 3` allows the code to self-modify itself, and update the position without needing to use extra RAM. This is reffered to as Self-Modifying-Code, or SMC for short.

Now we have the code to move a rectangle, and the code to draw a rectangle. So, we need some code to actually update the screen if a key is pressed.

Note that if we simply redraw the square, the old square won't be erased. As of right now, we have two options:

* Clear the screen on each redraw
* Only redraw the portions that the rectangle shifted by

Option one is the preferred choice for now. In the next tutorial we will learn more about drawing to the LCD.

This subroutine should preform what we need. First, it clears the screen, and then draws the new rectangle posistion. From the key input code block, you can now see where `redraw_screen` comes from.

```asm
redraw_screen:
	ld	hl,ti.vRam
	ld	bc,ti.lcdWidth * ti.lcdHeight
	call	ti.MemClear		; set the LCD background

	ld	a,RECT_COLOR_I		; change the color of the rectangle
	ld	(draw_rectangle.color),a

	ld	de,(xPos)
	ld	hl,(yPos)
	ld	a,RECT_WIDTH
	ld	bc,RECT_HEIGHT
	jp	draw_rectangle
```

`RECT_WIDTH`, `RECT_HEIGHT`, and `RECT_COLOR_I` are simply defines you can add to the top of your code:

```asm
RECT_WIDTH := 10
RECT_HEIGHT := 10
RECT_COLOR_I := 255
```

# Finishing Up

Of course, the next reasonable question is, how do I put this all together?

First, you need an your key input to be in a loop, so that way you can continuously poll data from the keypad.

This program demonstrates how one might do that. Now, you should be able to move your rectangle across the screen. Some fun challenges:

* Slow down the speed of the rectangle movement
 * (Hint: Loop for a long time)
* Change the background color of the screen from black
* Add some more functions using the keypad
 * Center the rectangle if the [2ND] key is pressed
 * Add movement of multiple rectangles

Let's keep going!

```asm
include 'include/ez80.inc'
include 'include/ti84pceg.inc'
include 'include/tiformat.inc'
format ti executable 'DEMO'

RECT_WIDTH := 10
RECT_HEIGHT := 10
RECT_COLOR_I := 255

; Start of program code
	call	ti.RunIndicOff		; turn off run indicator
	di				; disable interrupts

create1555palette:
	ld	hl,ti.mpLcdPalette	; mmio address of lcd palette
	ld	b,0
.loop:
	ld	d,b
	ld	a,b
	and	a,192
	srl	d
	rra
	ld	e,a
	ld	a,31
	and	a,b
	or	a,e
	ld	(hl),a
	inc	hl
	ld	(hl),d
	inc	hl
	inc	b
	jr	nz,.loop

	call	ti.boot.ClearVRAM	; set all of vram to index 255 (white)
	ld	a,ti.lcdBpp8
	ld	(ti.mpLcdCtrl),a	; enable 8bpp mode

main_loop:
	di
	ld	hl,ti.DI_Mode		; register for keypad mode
	ld	(hl),2			; set single scan mode

	xor	a,a
scan_wait:
	cp	a,(hl)			; wait for keypad idle mode
	jr	nz,scan_wait

; Read data registers here as needed

	ld	a,(ti.kbdG6)
	bit	ti.kbitClear,a
	jp	nz,exit_prgm		; exit the program if [CLEAR] is pressed

	ld	a,(ti.kbdG7)
	push	af
 	bit	ti.kbitUp,a
 	call	nz,request_up   	  ; is [UP] pressed?

	pop	af
	push	af
	bit	ti.kbitRight,a
	call	nz,request_right	; is [RIGHT] pressed?

	pop	af
	push	af
	bit	ti.kbitLeft,a
	call	nz,request_left		; is [LEFT] pressed?

	pop	af
	push	af
	bit	ti.kbitDown,a
	call	nz,request_down		; is [DOWN] pressed?

 	pop	af
	or	a,a
	call	nz,redraw_screen	; if any key is pressed, update the screen

	jp	main_loop

request_up:
	ld	a,0
yPos := $ - 1
	dec	a
	ret	z			; return if @ 1
	ld	(yPos),a
	ret

request_right:
	ld	hl,0
xPos := $ - 3
	inc	hl
	ld	de,ti.lcdWidth
	or	a,a
	sbc	hl,de
	add	hl,de
	ret	z			; return if @ 319
	ld	(xPos),hl
	ret

request_left:
	ld	hl,(xPos)
	dec	hl
	add	hl,de
	or	a,a
	sbc	hl,de
	ret	z			; return if @ 1
	ld	(xPos),hl
	ret

request_down:
	ld	a,(yPos)
	inc	a
	cp	a,ti.lcdHeight
	ret	z			; return if @ 239
	ld	(yPos),a
	ret

redraw_screen:
	ld	hl,ti.vRam
	ld	bc,ti.lcdWidth * ti.lcdHeight
	call	ti.MemClear		; set the LCD background

	ld	a,RECT_COLOR_I		; change the color of the rectangle
	ld	(draw_rectangle.color),a

	ld	de,(xPos)
	ld	hl,(yPos)
	ld	a,RECT_WIDTH
	ld	bc,RECT_HEIGHT
;	jp	draw_rectangle

;----------------------------------------
; draw_rectangle
; inputs:
;         de = x
;          l = y
;         bc = width
;          a = height
;  rcolor = color of rectangle
;  this routine can be greatly optimized!
;----------------------------------------
draw_rectangle:
	ld	h,ti.lcdWidth / 2	; h = 160
	mlt	hl			; 160 * y
	add	hl,hl			; hl * 2
	add	hl,de			; add x coordinate
	ld	de,ti.vRam
	add	hl,de			; offset vRam
	dec	bc			; for ldir
.loop:
	ld	(hl),0
.color := $ - 1
	push	hl
	pop	de
	inc	de
	push	bc
	ldir				; draw line
	pop	bc
	ld	de,ti.lcdWidth
	add	hl,de			; move down
	sbc	hl,bc
	dec	a
	jr	nz,.loop
	ret

exit_prgm:
	call	ti.ClrScrn
	ld	a,ti.lcdBpp16
	ld	(ti.mpLcdCtrl),a
	call	ti.DrawStatusBar
	ei				; reset screen back to normal
	ret				; return to os

```
