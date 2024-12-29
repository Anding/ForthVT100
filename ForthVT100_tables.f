\ table formatting using VT100 control codes

0 value table.leftMargin	\ spaces to the left of the table
-1 value table.startRow		\ true before starting to print a row, false while printing a row
0 value table.nextColumn	\ the next column after the current cell, or the first column of the table

defer table.line-format		\ ForthVT100 word to format table lines
defer table.text-format		\ ForthVT100 word to format table text
assign noop to-do table.line-format
assign noop to-do table.text-format

: table.CELL-TAG ( startChar cellChar divChar endChar --)
	create
		c, c, c, c, 
	does>		( cell-width PFA --)
		>R	
		table.startRow IF 
			0 -> table.startRow		
			vt.newline		
			table.leftMargin 1+ -> table.nextColumn	\ 1+ since VT terminals start at column 1
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
	
218 196 194 191 table.CELL-TAG |h	\ header cell
179  32 179 179 table.CELL-TAG |t	\ text cell
195 196 197 180 table.CELL-TAG |l	\ line cell
192 196 193 217 table.CELL-TAG |f	\ footer cell
195 196 194 180 table.CELL-TAG |r \ ruler cell
 32  32  32  32 table.CELL-TAG |b	\ cell made with blanks

: row
\ start a new row
	-1 -> table.startRow	
;

: table ( n --)
\ start a new table
\ padded n cells on the left
	-> table.leftMargin
	flushkeys							\ decongest any pending output
;






