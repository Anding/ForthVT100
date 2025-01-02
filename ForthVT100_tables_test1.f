include e:\coding\Forthbase\libraries\libraries.f
need ForthVT100
include %idir%\ForthVT100_tables.f

5 12 1 table

assign vt.green to-do table.line-format
assign vt.yellow to-do table.text-format

vt.cls vt.home vt.reset

row |h |h |h |h
row |t |t |t |t
row |l |l |l |l
row |f |f |f |f
CR

51 -> table.cellWidth
row |h ." Ecliptic coordinates of the mount"
12 -> table.cellWidth
row |r |r |r |r
row |t s" RA" CJ.	|t s" 00:05:15" LJ. |t s" DEC" RJ. |t s" +12:45:30" LJ.
row |f |f |f |f
CR

vt.red_bg
:noname vt.cyan vt.italic_off ; ' table.line-format defer!
:noname vt.white vt.italic ; ' table.text-format defer!
 
 0 7 0 table
 15 0 vt.move
 row |h row |t row |t s" One" CJ. row |t row |f  
 
 20 7 0 table                               
 15 0 vt.move                              
 row |h row |t row |t s" Two" CJ. row |t row |f
 vt.reset CR 