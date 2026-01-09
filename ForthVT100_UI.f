\ User interface facilities using VT100 control codes

NEED ForthBase
NEED ForthVT100

\ controls what is reported
3 value report-level
\ 0 nothing
\ 1 or greater - errors
\ 2 or greater - output
\ 3 or greater - diagnostics


defer vt.err-on
defer vt.err-off
defer vt.out-on
defer vt.out-off
defer vt.dia-on
defer vt.dia-off

assign vt.red to-do vt.err-on
assign vt.default to-do vt.err-off
assign vt.green to-do VT.out-on
assign vt.default to-do VT.out-off
assign vt.faint to-do vt.dia-on
assign vt.faint_off to-do vt.dia-off

s" " $value vt.str01

: .> ( caddr u --)
\ report output
\ print the string and return the cursor to the start of the current line 
\ use the STDOUT ink 
    report-level 2 >=  if
        VT.out-on 0 vt.column type vt.erase_to_end_line flushkeys vt.default VT.out-off
    else 2drop then
;

: .>E ( caddr u --)
\ report an error
\ print the string and return the cursor to the start of the current line 
    report-level 1 >=  if
        vt.err-on ( vt.erase_line) 0 vt.column type flushkeys vt.err-off
    else 2drop then
;

: .>D ( caddr u --)
\ report a diagnostoc
\ print the string and return the cursor to the start of the current line 
    report-level 3 >=  if
        vt.dia-on ( vt.erase_line) 0 vt.column type flushkeys vt.dia-off 
    else 2drop then
;

: countdown ( n -- IOR)
\ countdown n seconds offering the user a cancellation
\ return IOR = -1 if the user cancelled, 0 otherwise
    dup cr (.) nip ( n r)
    over 0 swap do
        i over (u.r)    $-> vt.str01    
        s"  ("         $+> vt.str01   
        2dup (u.r)      $+> vt.str01
        s"  seconds) key x to cancel" $+> vt.str01
        vt.str01 .>
        i 0<> if 999 ms then   \ no wait after reaching 0
        key? if key 'x' = if unloop 2drop -1 cr exit then then       
    -1 +loop
    2drop 0 cr 
;
