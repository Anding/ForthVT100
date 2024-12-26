include %idir%\..\ForthBase\libraries\libraries.f
NEED CommandStrings

: COLOUR-CONTROL
	create ( n 'NAME' --)
		here 1+ 
		<< 0x1b | '[' | (.) ..| 'm' | >>
		dup 1+ allot
		swap 1- c!
	does>
		( pfa) count type
;

31 COLOUR-CONTROL vt.red
32 COLOUR-CONTROL vt.green 