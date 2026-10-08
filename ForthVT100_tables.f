\ Streaming tables with terminal box drawing and clean ASCII redirection.
\
\ A cell tag starts a cell. The next tag, row, or }table pads and closes the
\ previous cell. Forth's output-column counter permits ordinary TYPE, .", and
\ numeric display words inside cells without cursor positioning.

0 value table.tableMargin
0 value table.cellWidth
0 value table.cellMargin
0 value table.cellStart
0 value table.cellTag
0 value table.rowActive
0 value table.cellActive

defer table.line-format
defer table.text-format
assign noop to-do table.line-format
assign noop to-do table.text-format

: table.tag-offset ( -- n )
    vt.terminal-output if 0 else 4 then
;

: table.tag-char ( pfa index -- char )
    table.tag-offset + + c@
;

: table.fill-cell ( -- )
    table.cellActive if
        table.cellStart table.cellWidth + out @ - 0 max
        table.cellTag 1 table.tag-char swap
        0 ?do dup emit loop drop
    then
;

: table.close-row ( -- )
    table.rowActive if
        table.fill-cell
        table.line-format
        table.cellTag 3 table.tag-char emit
        cr
        0 -> table.rowActive
        0 -> table.cellActive
    then
;

: table.begin-cell ( pfa -- )
    table.cellActive if
        table.fill-cell
        table.line-format
        table.cellTag 2 table.tag-char emit
    else
        table.tableMargin spaces
        table.line-format
        dup 0 table.tag-char emit
        -1 -> table.cellActive
    then
    dup -> table.cellTag
    out @ -> table.cellStart
    dup 1 table.tag-char bl = if
        table.text-format
    else
        table.line-format
    then
    drop
;

: table.CELL-TAG
    { terminal-start terminal-fill terminal-divider terminal-end
      plain-start plain-fill plain-divider plain-end -- }
    create
        terminal-start c,
        terminal-fill c,
        terminal-divider c,
        terminal-end c,
        plain-start c,
        plain-fill c,
        plain-divider c,
        plain-end c,
    does> ( pfa -- )
        table.begin-cell
;

218 196 194 191  '+' '-' '+' '+' table.CELL-TAG |h
179  32 179 179  '|' bl  '|' '|' table.CELL-TAG |t
195 196 197 180  '+' '-' '+' '+' table.CELL-TAG |l
192 196 193 217  '+' '-' '+' '+' table.CELL-TAG |f
195 196 194 180  '+' '-' '+' '+' table.CELL-TAG |r
 32  32  32  32  bl  bl  bl  bl  table.CELL-TAG |b

: row ( -- )
    table.close-row
    -1 -> table.rowActive
;

: table ( margin width cell-margin -- )
    table.close-row
    -> table.cellMargin
    -> table.cellWidth
    -> table.tableMargin
;

: }table ( -- )
    table.close-row
    vt.reset
;

: RJ. ( caddr u -- )
    table.cellWidth over - table.cellMargin - 0 max
    table.cellTag 1 table.tag-char swap
    0 ?do dup emit loop drop
    type
;

: CJ. ( caddr u -- )
    table.cellWidth over - 0 max 2/
    table.cellTag 1 table.tag-char swap
    0 ?do dup emit loop drop
    type
;

: LJ. ( caddr u -- )
    table.cellTag 1 table.tag-char table.cellMargin
    0 ?do dup emit loop drop
    type
;
