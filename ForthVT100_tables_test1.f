include e:\coding\Forthbase\libraries\libraries.f
need ForthVT100
include %idir%\ForthVT100_tables.f

5 table
12 value cw		\ cell width

assign vt.green to-do table.line-format
assign vt.yellow to-do table.text-format

row cw |h cw |h cw |h cw |h
row cw |t cw |t cw |t cw |t
row cw |l cw |l cw |l cw |l
row cw |f cw |f cw |f cw |f
CR

row cw 4* 3 + |h ." Ecliptic coordinates of the mount"
row cw |r cw |r cw |r cw |r
row cw |t ." RA" 	cw |t ." 00:05:15" 
	  cw |t ." DEC" 	cw |t ." +12:45:30"
row cw |f cw |f cw |f cw |f
CR

