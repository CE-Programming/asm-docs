include 'ez80.inc'
include 'ti84pceg.inc'
include 'tiformat.inc'
format ti executable 'DEMO'

	call	_HomeUp
	ld	hl,hello
	call	_PutS
	jp	_NewLine

hello:
	db "Hello", 0
