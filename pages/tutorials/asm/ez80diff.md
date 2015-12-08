---
layout: page
title: eZ80 Differences
permalink: /tutorials/asm/ez80diff.html
---

The tutorials in this guide assume that you have a decent knowledge of eZ80 assembly. However, if you have no idea where to begin, you will first want to begin with the updated version of [**Asm in 28 Days**](http://media.taricorp.net/83pa28d/lesson/toc.html#lessons).

Of course, eZ80 assembly is a little different than what the guide uses throught. Most of the ideas are entirely applicable, although the following **must** also be taken into account:

* The **bcall()** and **bjump()** macros are no no longer nessasary. If you have Z80 code that looks like this:

```
 bcall(_ClrLCD)
```

Or something similar, this can simply be replaced with:

```
 call _ClrLCD
```

* The eZ80 has two differnt CPU modes, ADL and Z80 respectively.
 * **Most** of the time you will wish to operate in ADL mode, as this is what mode programs begin execution in on the CE.
 * Note this means a few things must be taken into account when in ADL mode:
  * Addressing is 24 bit linear, which means you can access memory from 0x000000 to 0xFFFFFF. Note that most of these are unmapped though.
  * Registers ```HL```,```DE```,```BC```,```IX```,```IY```, and their shadow counterparts are now 3 bytes in size, rather than 2.
  * This means if you have an instruction such as ```ld hl,(imm24)```, ```HL``` will contain the 3 byte value located at imm24.
  * The same is also true for storage. ```ld (imm24),hl``` will store the 3 bytes in HL to imm24, overwriting imm24, imm24+1, and imm24+2.
* However, suffixes in eZ80 can switch the mode of the CPU per instruction.
 * When in Z80 mode, address use **MBASE**, another register that is prefixed to the start of an address.
  * If **MBASE** is $D0, and your Z80-style address is $1450, then the full eZ80 address would be 0xD01450.
 * For example, ```ld.sis (fillRectColor-$D00000),hl```, only stores the low 2 bytes in HL to fillRectColor, as long as **MBASE** is 0xD0. Notice the "-$D00000"; this makes sure it is only a 16 bit address.
 * **NOTE**: This is only allowed if the address range is has a high byte of 0xD0 when innterrupts are enabled. This is because the interrupt handler sets MBASE to 0xD0. If you disable interrupts, MBASE can be anything you desire.
* For some reason, instruction syntax in eZ80 looks a little different in eZ80. When using instructions that opperate on the accumulator, an 'a' is also added to the operands. Note that this means absolutely nothing, but is proper styling.
 * Example: Z80 code: ```or a``` would be ```or a,a``` in eZ80.
 * Example: Z80 code: ```cp (hl)``` would be ```cp a,(hl)``` in eZ80.
