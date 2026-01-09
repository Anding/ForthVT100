include %idir%\..\ForthBase\libraries\libraries.f
NEED CommandStrings

0x1b CONSTANT ESC									\ ESC character
256 buffer: vt.buff								\ private buffer for command manipulation

: VT100-CONTROL
	create ( n 'NAME' --)
		here 1+ 
		<< ESC | '[' | .| 'm' | >>
		dup 1+ allot
		swap 1- c!
	does>
		( pfa) count type
;

0 VT100-CONTROL vt.reset
1 VT100-CONTROL vt.bold
2 VT100-CONTROL vt.faint
3 VT100-CONTROL vt.italic
4 VT100-CONTROL vt.underline
5 VT100-CONTROL vt.blinking
7 VT100-CONTROL vt.inverse
8 VT100-CONTROL vt.hidden
9 VT100-CONTROL vt.strikethrough

22 VT100-CONTROL vt.bold_off
22 VT100-CONTROL vt.faint_off
23 VT100-CONTROL vt.italic_off
24 VT100-CONTROL vt.underline_off
25 VT100-CONTROL vt.blinking_off
27 VT100-CONTROL vt.inverse_off
28 VT100-CONTROL vt.hidden_off
29 VT100-CONTROL vt.strikethrough_off

30 VT100-CONTROL vt.black
31 VT100-CONTROL vt.red
32 VT100-CONTROL vt.green 
33 VT100-CONTROL vt.yellow
34 VT100-CONTROL vt.blue
35 VT100-CONTROL vt.magenta
36 VT100-CONTROL vt.cyan
37 VT100-CONTROL vt.white
39 VT100-CONTROL vt.default

40 VT100-CONTROL vt.black_bg
41 VT100-CONTROL vt.red_bg
42 VT100-CONTROL vt.green_bg 
43 VT100-CONTROL vt.yellow_bg
44 VT100-CONTROL vt.blue_bg
45 VT100-CONTROL vt.magenta_bg
46 VT100-CONTROL vt.cyan_bg
47 VT100-CONTROL vt.white_bg
49 VT100-CONTROL vt.default_bg

90 VT100-CONTROL vt.black_off
91 VT100-CONTROL vt.red_off
92 VT100-CONTROL vt.green_off 
93 VT100-CONTROL vt.yellow_off
94 VT100-CONTROL vt.blue_off
95 VT100-CONTROL vt.magenta_off
96 VT100-CONTROL vt.cyan_off
97 VT100-CONTROL vt.white_off
99 VT100-CONTROL vt.default_off

100 VT100-CONTROL vt.black_bg_off
101 VT100-CONTROL vt.red_bg_off
102 VT100-CONTROL vt.green_bg_off 
103 VT100-CONTROL vt.yellow_bg_off
104 VT100-CONTROL vt.blue_bg_off
105 VT100-CONTROL vt.magenta_bg_off
106 VT100-CONTROL vt.cyan_bg_off
107 VT100-CONTROL vt.white_bg_off
109 VT100-CONTROL vt.default_bg_off

: vt.cls ( --)
\ clear the entire screen
	[ vt.buff << ESC | s" [2J" ..| >> ]
	sliteral type
;

: vt.erase_line ( --)
\ clear the entire line
	[ vt.buff << ESC | s" [2K" ..| >> ]
	sliteral type
;

: vt.erase_to_end_line
 \ clear to the end of line line
	[ vt.buff << ESC | s" [0K" ..| >> ]
	sliteral type
;   

: vt.home ( --)
\ move the cursor to home position (1, 1)
	[ vt.buff 	<< ESC | '[' | 'H' | >> ]
	sliteral type
;

: vt.newline
	vt.buff << ESC | '[' | '1' | 'E' | >> 
	type
;	

: vt.move ( line column --)
\ move the cursor to the line, column
	swap 														( column line)
	vt.buff << ESC | '[' | .| ';' | (.) ..| 'H' | >> 
	type
;

: vt.column ( column --)
\ move the cursor to the column
	vt.buff << ESC | '[' | .| 'G' | >> 
	type
;

: vt.right ( columns --)
\ move the cursor columns to the right
	vt.buff << ESC | '[' | .| 'C' | >> 
	type
;	

: vt.cursor_off ( --)
\ make the cursor invisible
	[ vt.buff << ESC | s" [?25l" ..| >> ]
	sliteral type
;

: vt.cursor_on ( --)
\ make the cursor invisible
	[ vt.buff << ESC | s" [?25h" ..| >> ]
	sliteral type
;


