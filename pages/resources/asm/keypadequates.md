---
layout: page
title: Keypad Equates
permalink: /resources/asm/keypad-equates/
---

```
; DI Keyboard Equates
;---------------------------
DI_Mode		equ $F50000
DI_Cntrl	equ $F50004
DI_Int		equ $F50008
DI_IntMask	equ $F5000C

kbdG1		equ $F50012
;----------------------------
kbdGraph	equ %00000001
kbdTrace	equ %00000010
kbdZoom		equ %00000100
kbdWindow	equ %00001000
kbdYequ 	equ %00010000
kbd2nd		equ %00100000
kbdMode		equ %01000000
kbdDel		equ %10000000

kbitGraph	equ 00
kbitTrace	equ 01
kbitZoom	equ 02
kbitWindow	equ 03
kbitYequ    equ 04
kbit2nd		equ 05
kbitMode	equ 06
kbitDel		equ 07

kbdG2		equ $F50014
;----------------------------
kbdStore	equ %00000010
kbdLn		equ %00000100
kbdLog		equ %00001000
kbdSquare	equ %00010000
kbdRecip	equ %00100000
kbdMath		equ %01000000
kbdAlpha	equ %10000000

kbitStore	equ 01
kbitLn		equ 02
kbitLog		equ 03
kbitSquare	equ 04
kbitRecip	equ 05
kbitMath	equ 06
kbitAlpha	equ 07

kbdG3		equ $F50016
;----------------------------
kbd0		equ %00000001
kbd1		equ %00000010
kbd4		equ %00000100
kbd7		equ %00001000
kbdComma	equ %00010000
kbdSin		equ %00100000
kbdApps		equ %01000000
kbdGraphVar	equ %10000000

kbit0		equ 00
kbit1		equ 01
kbit4		equ 02
kbit7		equ 03
kbitComma	equ 04
kbitSin		equ 05
kbitApps	equ 06
kbitGraphVar	equ 07

kbdG4		equ $F50018
;----------------------------
kbdDecPnt	equ %00000001
kbd2		equ %00000010
kbd5		equ %00000100
kbd8		equ %00001000
kbdLParen	equ %00010000
kbdCos		equ %00100000
kbdPgrm		equ %01000000
kbdStat		equ %10000000

kbitDecPnt	equ 00
kbit2		equ 01
kbit5		equ 02
kbit8		equ 03
kbitLParen	equ 04
kbitCos		equ 05
kbitPgrm	equ 06
kbitStat	equ 07

kbdG5		equ $F5001A
;----------------------------
kbdChs		equ %00000001
kbd3		equ %00000010
kbd6		equ %00000100
kbd9		equ %00001000
kbdRParen	equ %00010000
kbdTan		equ %00100000
kbdVars		equ %01000000

kbitChs		equ 00
kbit3		equ 01
kbit6		equ 02
kbit9		equ 03
kbitRParen	equ 04
kbitTan		equ 05
kbitVars	equ 06

kbdG6		equ $F5001C
;----------------------------
kbdEnter	equ %00000001
kbdAdd		equ %00000010
kbdSub		equ %00000100
kbdMul		equ %00001000
kbdDiv		equ %00010000
kbdPower	equ %00100000
kbdClear	equ %01000000

kbitEnter	equ 00
kbitAdd		equ 01
kbitSub		equ 02
kbitMul		equ 03
kbitDiv		equ 04
kbitPower	equ 05
kbitClear	equ 06

kbdG7		equ $F5001E
;----------------------------
kbdDown		equ %00000001
kbdLeft		equ %00000010
kbdRight	equ %00000100
kbdUp		equ %00001000

kbitDown	equ 00
kbitLeft	equ 01
kbitRight	equ 02
kbitUp		equ 03
```