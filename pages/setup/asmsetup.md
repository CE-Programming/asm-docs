---
layout: page
title: ASM Enviornment Setup
permalink: /setup/asmsetup.html
---

Welcome! Here you will find the nessasary tools for programming in eZ80 assembly. Be sure to follow along carefully so you can be up and ready in no time.

# Windows

Create a folder in your somewhere on your computer called 'CEasm'

Navigate into this folder and make another folder, this one called 'myfirstasmprgm'

Create two new files in the 'myfirstasmprgm' directory called 'main.asm' and 'ti84pce.inc'.

Now, you will need the include file for the TI-84+CE/TI83PCE calculator line. You can find the latest version here: [CE Include File](http://wikiti.brandonw.net/index.php?title=84PCE:OS:Include_File)

Simply copy all the text on that page within the gray box into the 'ti84pce.inc' file, save, and exit.

Now, copy and paste the following assembly code into the 'main.asm' file:

{% highlight %}
#include "ti84ce.inc"

.db t2ByteTok,tAsmCmp
.org usermem

call _HomeUp
ld hl,msg
call _PutS
ret

msg:
 .db "Hello World!",0
{% endhighlight %}

Now, you are going to need an assembler. Simply put, this assembler will translate your assembly-flavored code into something that the calculator can execute. Remember, the calculator has no idea what 'code' even is, and can only do what you tell it to.

The latest version of SPASM-NG, an eZ80 assembler, can be found here: [SPASM-NG](https://github.com/alberthdev/spasm-ng/releases)

Place SPASM-NG into 'myfirstasmprgm' directory, and rename it to 'spasm.exe', if it is not already.


