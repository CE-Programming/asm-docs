include 'include/ez80.inc'
include 'include/ti84pceg.inc'
include 'include/tiformat.inc'
format ti executable 'DEMO'

	call	ti.HomeUp
	ld	hl,hello
	call	ti.PutS
	jp	ti.NewLine

hello:
	db "Hello World!", 0
