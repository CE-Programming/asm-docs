## Drawing Sprites

Now for the fun part.
We are going to learn how to draw sprites on the screen, and rather than simply trying to manually build a sprite, we can use some prebuilt software to do it for us.

## Introduction

First, let us begin with a simple sprite such as this familiar one:

![Mushroom Sprite](../appendix/mushroomsprite.png "+1 life!")

Notice that we want to use the pink color as a transparent color, so that we can move it over other things. This is fairly easy to do in code, as we will see later on.

Now, how do I convert this image to be used in 8bpp mode? Isn't there a palette that I have to use?

**Note**: To convert your images, you will need to download this tool: https://github.com/mateoconlechuga/convimg

## The Code

Now, we first want to convert this image so we can see how to use it.
Copy the above mushroom sprite into your project directory and name it `mushroomsprite.png`.
Next, use convimg to create an assembly file containing the sprite's data and palette information.
A `convimg.yaml` file is provided below to accomplish this:

```yaml
palettes:
  - name: mypalette
    images: automatic

converts:
  - name: myimages
    palette: mypalette
    images:
      - mushroomsprite.png

outputs:
  - type: asm
    include-file: gfx.inc
    palettes:
      - mypalette
    converts:
      - myimages
```

Next inside your *main.asm* file, start with this template:

```asm
include 'ez80.inc'
include 'ti84pceg.inc'
include 'tiformat.inc'
format ti executable 'DEMO'

; Start of program code



; End program code
; Start of data section

include 'gfx.inc'

; End data section
```

Notice the `include 'gfx.inc'` line, which inserts the converted image information into the program.

Now, because the sprite uses a different palette than our default one, we must copy it to the palette memory.
Here's some simple code to copy our palette to memory:

```asm
	ld	hl,mypalette
	ld	de,mpLcdPalette
	ld	bc,sizeof_mypalette
	ldir
```

Now our sprite's palette is set up in memory. Next, we simply need to copy the sprite data to the screen in order to display it.
This can be accomplished by copying the data in rows.
The converted sprite from convimg stores the width and height as the first two bytes respectively.

So, we need a sprite routine that will copy 32 bytes of data for each row, increment to the next row, and repeat this operation for 32 times.
This is some genearic code to get you started:

```asm
;----------------------------------------
; DrawSprite
; inputs:
;         bc = x
;          l = y
;         de = pointer to sprite
;  this routine can be greatly optimized
;----------------------------------------
DrawSprite:
	ld	h,ti.lcdWidth / 2		; h=160
	mlt	hl		; 160*y
	add	hl,hl		; hl*2
	add	hl,bc		; add x
	ld	bc,ti.vRam
	add	hl,bc		; offset vRam
	ld	a,(de)		; width
	ld	(.width_smc),a
	inc	de
	ld	a,(de)		; height
	inc	de
	ex	de,hl
.loop:
.width_smc := $+1
	ld	bc,0
	push	de
	ldir			; draw line
	pop	de
	ex	de,hl
	ld	bc,ti.lcdWidth
	add	hl,bc		; move down
	ex	de,hl
	dec	a
	jr	nz,.loop
	ret
```

