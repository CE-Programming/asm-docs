## Double Buffering

In computer graphics, double buffering refers to drawing graphics out of the user's view, and then transferring the drawn data all at once to the screen.

This prevents the weird graphical effects you may have seen in the previous tutorial, where we cleared the screen and then updated the rectangle, where there was a few milliseconds where the screen is completely black.

Now, the two main methods of double buffering are known as **blitting** and **page flipping**. For the curious, here's a short explanation on each: [**Double Buffering**](https://docs.oracle.com/javase/tutorial/extra/fullscreen/doublebuf.html)

## The Code

## Blitting

Taking the finished code from [**tutorial 2**](https://github.com/CE-Programming/documentation/tutorials/3-direct-key-input.md), let's modify it to use the first method of double buffering, which is simply copying our drawn data to the screen.

So, rather than drawing to the start of VRAM, since we are in 8bpp mode, we can use VRAM+(320*240) as our back buffer.

Some equates for working with double buffering:

```asm
screenData := vram
bufData := vram+(320*240)
```

Now, we need to write some code that will copy our finished data to the screen. This simple ldir technique can accomplish this.

```asm
BlitScreen:
	ld	hl,bufData
	ld	de,screenData
	ld	bc,lcdWidth*lcdHeight
	ldir
	ret
```

*Work In Progress... email matthewwaltzis@gmail.com if you need this completed.*
