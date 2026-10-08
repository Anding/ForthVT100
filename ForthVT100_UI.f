\ Beautiful scrolling presentation built on the state-aware VT100 primitives.

NEED ForthBase
NEED ForthVT100

3 value report.level
78 value presentation.width
22 value field.width
0 value vt.status-active

: DIAGNOSTICS       3 -> report.level ;
: STANDARD-OUTPUT   2 -> report.level ;
: JUST-ERRORS       1 -> report.level ;
: SILENT-RUNNING    0 -> report.level ;

defer vt.err-on
defer vt.err-off
defer vt.out-on
defer vt.out-off
defer vt.dia-on
defer vt.dia-off
defer vt.title-on
defer vt.title-off
defer vt.section-on
defer vt.section-off
defer vt.success-on
defer vt.success-off
defer vt.warning-on
defer vt.warning-off
defer vt.rule-on
defer vt.rule-off
defer vt.label-on
defer vt.label-off
defer vt.emphasis-on
defer vt.emphasis-off

assign vt.red to-do vt.err-on
assign vt.default to-do vt.err-off
assign vt.green to-do vt.out-on
assign vt.default to-do vt.out-off
assign vt.faint to-do vt.dia-on
assign vt.faint_off to-do vt.dia-off
:noname vt.bold vt.cyan ; to-do vt.title-on
assign vt.reset to-do vt.title-off
:noname vt.bold vt.white ; to-do vt.section-on
assign vt.reset to-do vt.section-off
assign vt.green to-do vt.success-on
assign vt.default to-do vt.success-off
assign vt.yellow to-do vt.warning-on
assign vt.default to-do vt.warning-off
assign vt.faint to-do vt.rule-on
assign vt.faint_off to-do vt.rule-off
assign vt.cyan to-do vt.label-on
assign vt.default to-do vt.label-off
assign vt.bold to-do vt.emphasis-on
assign vt.bold_off to-do vt.emphasis-off
assign vt.cyan to-do table.line-format
assign vt.default to-do table.text-format

s" " $value vt.str01

: vt.repeat { char count -- }
    count 0 max 0 ?do char emit loop
;

: -... ( -- )
\ Erase a transient status, if one is currently visible.
    vt.status-active if
        1 vt.column vt.erase_to_end_line
        0 -> vt.status-active
    then
;

: vt.begin-status ( -- flag )
    report.level 2 >= vt.terminal-output and dup if
        1 vt.column
    then
;

: vt.end-status ( -- )
    vt.erase_to_end_line
    -1 -> vt.status-active
;

: .> ( caddr u -- )
    report.level 2 >= if
        -... vt.out-on type vt.out-off cr
    else
        2drop
    then
;

: .E> ( caddr u -- )
    report.level 1 >= if
        -... vt.err-on ." [ERROR] " type vt.err-off cr
    else
        2drop
    then
;

: .D> ( caddr u -- )
    report.level 3 >= if
        -... vt.dia-on ." [DEBUG] " type vt.dia-off cr
    else
        2drop
    then
;

: ...> ( caddr u -- )
    vt.begin-status if
        vt.out-on type vt.out-off vt.end-status
    else
        2drop
    then
;

: .rule ( width -- )
    -... vt.rule-on '-' swap vt.repeat vt.rule-off cr
;

: .title { caddr u -- }
    -...
    vt.title-on caddr u type vt.title-off cr
    vt.rule-on '=' u vt.repeat vt.rule-off cr
;

: .section ( caddr u -- )
    -... vt.section-on type vt.section-off cr
;

: .emphasis ( caddr u -- )
    -... vt.emphasis-on type vt.emphasis-off cr
;

: .indent { caddr u depth -- }
    -... depth 2* spaces caddr u type cr
;

: vt.word-length { caddr u | n -- n }
    0 -> n
    begin n u < while
        caddr n + c@ bl = if n exit then
        n 1+ -> n
    repeat
    n
;

: .wrap { caddr u | column word-u -- }
    -...
    out @ -> column
    begin
        begin u 0> if caddr c@ bl = else 0 then while
            caddr 1+ -> caddr
            u 1- -> u
        repeat
        u 0= if
            cr exit
        then

        caddr u vt.word-length -> word-u
        column 0> if
            column word-u + 1+ presentation.width > if
                cr 0 -> column
            else
                space column 1+ -> column
            then
        then

        caddr word-u type
        column word-u + -> column
        caddr word-u + -> caddr
        u word-u - -> u
    again
;

: .Q> ( caddr u -- )
    -... vt.label-on type vt.label-off ." : "
;

: .OK> ( caddr u -- )
    report.level 2 >= if
        -...
        vt.success-on ." [OK] " vt.success-off type cr
    else
        2drop
    then
;

: .W> ( caddr u -- )
    report.level 2 >= if
        -...
        vt.warning-on ." [WARN] " vt.warning-off type cr
    else
        2drop
    then
;

: .bullet ( caddr u -- )
    -... 2 spaces ." * " type cr
;

: .branch { caddr u depth -- }
    -... depth 2* spaces ." +- " caddr u type cr
;

: .field { key-addr key-u value-addr value-u -- }
    -...
    2 spaces
    vt.label-on key-addr key-u type vt.label-off
    field.width key-u - 1 max spaces
    value-addr value-u type cr
;

: panel{ { caddr u | fill -- }
    -...
    presentation.width u - 6 - 0 max -> fill
    vt.rule-on ." +-- " vt.rule-off
    vt.section-on caddr u type vt.section-off space
    vt.rule-on '-' fill vt.repeat '+' emit vt.rule-off cr
;

: }panel ( -- )
    -...
    vt.rule-on '+' emit '-' presentation.width 2 - vt.repeat '+' emit
    vt.rule-off cr
;

: .bar { value maximum width | filled percent -- }
    -...
    maximum 0> if
        value 0 max maximum min width * maximum / -> filled
        value 0 max maximum min 100 * maximum / -> percent
    else
        0 -> filled
        0 -> percent
    then
    '[' emit
    vt.success-on '#' filled vt.repeat vt.success-off
    '-' width filled - vt.repeat
    ']' emit space percent 3 .r ." %"
    cr
;

: .progress { value maximum | width filled percent -- }
    vt.begin-status if
        30 -> width
        maximum 0> if
            value 0 max maximum min width * maximum / -> filled
            value 0 max maximum min 100 * maximum / -> percent
        else
            0 -> filled
            0 -> percent
        then
        '[' emit
        vt.success-on '#' filled vt.repeat vt.success-off
        '-' width filled - vt.repeat
        ']' emit space percent 3 .r ." %"
        vt.end-status
    then
;

: .spinner { caddr u phase | char -- }
    vt.begin-status if
        phase 3 and case
            0 of '|' endof
            1 of '/' endof
            2 of '-' endof
            3 of '\' endof
        endcase -> char
        char emit space caddr u type
        vt.end-status
    then
;

: .countdown ( seconds -- ior )
\ Interactive terminals show a cancellable transient countdown. Redirected
\ operation waits without reading command input or producing progress noise.
    vt.terminal-input vt.terminal-output and if
        0 max dup (.) nip
        over 0 swap do
            i over (u.r) $-> vt.str01
            s"  seconds. Key x to cancel" $+> vt.str01
            vt.str01 ...>
            i 0<> if 999 ms then
            key? if
                key 'x' = if
                    unloop 2drop -... -1 exit
                then
            then
        -1 +loop
        2drop -... 0
    else
        0 max 0 ?do 1000 ms loop
        0
    then
;
