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
    stdout type 0 vt.column vt.default flushkeys
;



: countdown ( n -- IOR)
\ countdown n seconds offering the user a cancellation
\ return IOR = -1 if the user cancelled, 0 otherwise
    cr
    0 over do
        i (.)       $-> vt.str01    
        s"  ... "   $+> vt.str01   
        dup (.)     $+> vt.str01
        s"  seconds. Key X to cancel" $+> vt.str01
        vt.str01 .>
        1000 ms
    -1 +loop
    drop cr 
;
    
    
: test
    cr 
    s" First" .>
    800 ms
    s" Second" .>
    800 ms
    s" Third" .>
    cr
;