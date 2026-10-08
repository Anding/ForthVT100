\ State-aware ANSI/VT100 presentation primitives.
\
\ Terminal control is emitted only when stdout is a character device.  The
\ presentation mode can be forced for repeatable tests, then returned to the
\ state detected from the process standard handles.

NEED CommandStrings

0x1b CONSTANT ESC
256 buffer: vt.buff

also system
: vt.detect-terminal-input ( -- flag )
    stdindev @ FILE_TYPE_CHAR =
;

: vt.detect-terminal-output ( -- flag )
    stdoutdev @ FILE_TYPE_CHAR =
;
previous

0 value vt.terminal-input
0 value vt.terminal-output

: AUTO-PRESENTATION ( -- )
    vt.detect-terminal-input  -> vt.terminal-input
    vt.detect-terminal-output -> vt.terminal-output
;

: TERMINAL-PRESENTATION ( -- )
    -1 -> vt.terminal-input
    -1 -> vt.terminal-output
;

: PLAIN-PRESENTATION ( -- )
    0 -> vt.terminal-input
    0 -> vt.terminal-output
;

: vt.control-type ( caddr u -- )
\ Emit terminal control without changing Forth's logical output column.
    vt.terminal-output if
        out @ >r type r> out !
    else
        2drop
    then
;

: VT100-CONTROL
    create ( n "name" -- )
        here 1+
        << ESC | '[' | .| 'm' | >>
        dup 1+ allot
        swap 1- c!
    does> ( pfa -- )
        count vt.control-type
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

: vt.cls ( -- )
    [ vt.buff << ESC | s" [2J" ..| >> ]
    sliteral vt.control-type
;

: vt.erase_line ( -- )
    [ vt.buff << ESC | s" [2K" ..| >> ]
    sliteral vt.control-type
;

: vt.erase_to_end_line ( -- )
    [ vt.buff << ESC | s" [0K" ..| >> ]
    sliteral vt.control-type
;

: vt.home ( -- )
    [ vt.buff << ESC | '[' | 'H' | >> ]
    sliteral vt.control-type
    vt.terminal-output if out off then
;

: vt.newline ( -- )
    vt.terminal-output if
        vt.buff << ESC | '[' | '1' | 'E' | >> vt.control-type
        out off
    else
        cr
    then
;

: vt.move ( line column -- )
    vt.terminal-output if
        1 max swap
        vt.buff << ESC | '[' | .| ';' | (.) ..| 'H' | >> vt.control-type
        1- out !
    else
        2drop
    then
;

: vt.column ( column -- )
    vt.terminal-output if
        1 max dup
        vt.buff << ESC | '[' | .| 'G' | >> vt.control-type
        1- out !
    else
        drop
    then
;

: vt.right ( columns -- )
    vt.terminal-output if
        0 max dup
        vt.buff << ESC | '[' | .| 'C' | >> vt.control-type
        out +!
    else
        drop
    then
;

: vt.cursor_off ( -- )
    [ vt.buff << ESC | s" [?25l" ..| >> ]
    sliteral vt.control-type
;

: vt.cursor_on ( -- )
    [ vt.buff << ESC | s" [?25h" ..| >> ]
    sliteral vt.control-type
;

: CLS ( -- )
    vt.cls vt.home
;

: -cr ( -- )
    vt.terminal-output if
        vt.buff << ESC | '[' | '1' | 'F' | >> vt.control-type
        out off
    then
;

AUTO-PRESENTATION
