\ User interface facilities using VT100 control codes

NEED ForthBase
NEED ForthVT100

defer stdout
defer stderr
assign vt.green to-do stdout
assign vt.red to-do stderr

s" " $value vt.str01

: .> ( caddr u --)
\ print the string and return the cursor to the start of the current line 
\ use the STDOUT ink 
    stdout ( vt.erase_line) 0 vt.column type flushkeys vt.default 
;

: .>> ( caddr u --)
\ print the string and return the cursor to the start of the current line 
\ use the STDOUT ink 
    stderr vt.erase_line type flushkeys vt.default 
;

: countdown ( n -- IOR)
\ countdown n seconds offering the user a cancellation
\ return IOR = -1 if the user cancelled, 0 otherwise
    dup cr (.) nip ( n r)
    over 0 swap do
        i over (u.r)    $-> vt.str01    
        s"  / "         $+> vt.str01   
        2dup (u.r)      $+> vt.str01
        s"  seconds. Key x to cancel" $+> vt.str01
        vt.str01 .>
        i 0<> if 999 ms then   \ no wait after reaching 0
        key? if key 'x' = if unloop 2drop -1 cr exit then then       
    -1 +loop
    2drop 0 cr 
;
