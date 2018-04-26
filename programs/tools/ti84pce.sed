#!/bin/sed -f
# usage: ./ti84pce.sed ti84pce.inc > ti84pceg.inc
1s/^/define ti? ti\nnamespace ti?\n/
$s/$/\nend namespace/
s/^[#.][^\n]*//
s/^_//
s/\(boot\|os\)_/\1./g
s/^\(\w.*[ 	]\)equ\([ 	]\)/?\1:=\2/
s/ \?| \?/ or /g
s/ \?& \?/ and /g
s/ \?\^ \?/ xor /g
s/ \?<< \?/ shl /g
s/ \?>> \?/ shr /g
