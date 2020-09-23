include 'include/ez80.inc'
include 'include/tiformat.inc'
include 'include/ti84pceg.inc'
format ti executable 'DEMO'

	call	ti.HomeUp
	ld	hl,hello
	call	ti.PutS
	jp	ti.NewLine

hello:
	db "Hello World!", 0
