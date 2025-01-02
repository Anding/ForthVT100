\ table formatting using VT100 control codes

0  value table.tableMargin	\ spaces to the left of the table
0  value table.cellWidth	\ width of the table cell in characters
0  value table.cellMargin	\ used for justfied text printing
-1 value table.startRow		\ true before starting to print a row, false while printing a row
0  value table.nextColumn	\ the next column after the current cell, or the first column of the table

defer table.line-format		\ ForthVT100 word to format table lines
defer table.text-format		\ ForthVT100 word to format table text
assign noop to-do table.line-format
assign noop to-do table.text-format

: table.CELL-TAG ( startChar cellChar divChar endChar --)
	create
		c, c, c, c, 
	does>		( cell-width PFA --)
		>R table.cellWidth
		table.startRow IF 
			0 -> table.startRow		
			vt.newline		
			table.tableMargin 1+ -> table.nextColumn	\ 1+ since VT terminals start at column 1
			R@ 3 + c@					( cell-width startChar)		
		ELSE
			R@ 1+ c@						( cell-width divChar)
		THEN
		table.nextColumn vt.column table.line-format	emit
		R@ 2+ c@ over 0				( cell-width cellChar cell-width 0)
		DO
			dup emit
		LOOP drop						( cell-width)
		R> @ emit
		table.nextColumn 1+ vt.column
		1+ add table.nextColumn		
		table.text-format	
;
	
218 196 194 191 table.CELL-TAG |h	\ ┐ ┬ ─ ┌ header cell
179  32 179 179 table.CELL-TAG |t	\ │ │   │ text cell
195 196 197 180 table.CELL-TAG |l	\ ┤ ┼ ─ ├ line cell
192 196 193 217 table.CELL-TAG |f	\ ┘ ┴ ─ └ footer cell
195 196 194 180 table.CELL-TAG |r 	\ ┤ ┬ ─ ├ ruler cell
 32  32  32  32 table.CELL-TAG |b	\         cell made with blanks

: row
\ start a new row
	-1 -> table.startRow	
;

: table ( n m l --)
\ start a new table with parameters
	-> table.cellMargin
	-> table.cellWidth
	-> table.tableMargin
	flushkeys							\ decongest any pending output
;

: RJ. ( caddr u - )
\ add leading spaces to right justfy then type text in the current cell
	table.cellWidth over - table.cellMargin - 0 max spaces type
;

: CJ. ( caddr u -- )
\ add leading spaces to centre justfy then type text in the current cell
	table.cellWidth over - 0 max 2/ spaces type
;   

: LJ. ( caddr u --)
\ add leading spaces to left justfy then type text in the current cell
	table.cellMargin spaces type
;
	

	
	





