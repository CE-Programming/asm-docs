
## Getting Started

The tutorials in this guide assume that you have a decent knowledge of eZ80 assembly.
However, if you have no idea where to begin, you will first want to begin with the updated version of [**Asm in 28 Days**](http://media.taricorp.net/83pa28d/lesson/), and then introduce yourself to the small changes with the new eZ80 processor, located [**here**](../appendix/eZ80-differences.md).

## The Template

This is the default template for all CE assembly programs.
Simply copy and paste into the main assembly code file.

```asm
include 'include/ez80.inc'
include 'include/tiformat.inc'
include 'include/ti84pceg.inc'
format ti executable 'DEMO'

; Start of program code
```

## Introduction

We are first going to understand how the CE LCD functions.
To get things to display on the screen, the easiest thing to do is to write to the LCD memory (commonly reffered to as VRAM/GRAM, starting at address `$D40000`).
VRAM is 320\*240\*2 (153600) bytes in size.

However, the LCD supports countless permutations of operation.
The OS normally operates in [16 bits per pixel (bpp)](https://en.wikipedia.org/wiki/High_color), or 16-bit high color with green containing the extra bit.
However, while 16bpp is useful for full-color graphics and things, it tends to be quite slow when doing intensive graphical effects, as it must draw 153600 bytes per frame.
This tutorial advocates for using palettized [8 bits per pixel](https://en.wikipedia.org/wiki/8-bit_color), where the color data is arranged in 1555 color, where 1=least significant bit (lsb) of green, and 555=red, green, blue (rgb) respectively in the LCD palette memory.
This not only makes it easy to compute the x and y offset for a given pixel, but also leads to improved drawing performance, and a possibility for double buffering.

## The Code

As you reach a code block, read the description and append it to the template.

First, most programs begin by turning off the OS run indicator and disabling interrupts. This can be accomplished quite quickly with:

```asm
	call	ti.RunIndicOff	; turn off run indicator
	di						; disable interrupts
```

Next, since our program is going to be using 8bpp mode, we need to set up the palette. This can be done many ways, simply by writing the color data in 16 bit increments to the palette memory. This code will create the following palette, which is highly useful.

```asm
create1555palette:
	ld	hl,ti.mpLcdPalette		; mmio address of lcd palette
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
```

![1555 Palette](../appendix/rgbhlpalette.png "Special thanks to Shaun 'Merthsoft' McFall for generating this image")
Now that the palette is set to the above image, we should clear the screen so that it doesn't cause weird graphical effects when switching modes.
Then we can enable 8bpp mode.
The code below will accomplish both of these tasks:

```asm
	call	ti.boot.ClearVRAM	; set all of vram to index 255 (white)
	ld	a,ti.lcdBpp8
	ld	(ti.mpLcdCtrl),a	; enable 8bpp mode
```

Great!
Now if you write the number from corresponding to the palette into the LCD data located at VRAM, the pixels will be set to the color at that palette offset.

Now, let's fill the screen with your favorite color.
Simply choose one of the color indexes, and add it to the following code:

```asm
	ld	a,$e0			; place your favorite color index here
	ld	hl,ti.vRam		; address of screen in memory ($d40000)
	ld	bc,ti.lcdWidth * ti.lcdHeight
	call	ti.MemSet
```

And then let's add a small key wait loop so we can see the results:

```asm
wait4key:
	call	ti.GetCSC
	cp	a,ti.skEnter
	jr	nz,wait4key
```

Once we end our key loop, we then need to do some common cleanup in order to properly return to the TI-OS.
This includes redrawing the status bar, and restoring 16bpp, along with a few other optional items.
Here's some example exiting code:

```asm
	call	ti.ClrScrn
	ld	a,ti.lcdBpp16
	ld	(ti.mpLcdCtrl),a
	call	ti.DrawStatusBar
	ei				; reset screen back to normal
	ret				; return to os
```

## Finishing Up

Congratulations! You have just completed the first tutorial.
In case you didn't quite catch all of the code, here is the full code:

```asm
include 'include/ez80.inc'
include 'include/tiformat.inc'
include 'include/ti84pceg.inc'
format ti executable 'DEMO'

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

	ld	a,$e0			; place your favorite color index here
	ld	hl,ti.vRam		; address of screen in memory ($d40000)
	ld	bc,ti.lcdWidth * ti.lcdHeight
	call	ti.MemSet

wait4key:
	call	ti.GetCSC
	cp	a,ti.skEnter
	jr	nz,wait4key

	call	ti.ClrScrn
	ld	a,ti.lcdBpp16
	ld	(ti.mpLcdCtrl),a
	call	ti.DrawStatusBar
	ei				; reset screen back to normal
	ret				; return to os
```
