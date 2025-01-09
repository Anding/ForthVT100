include e:\coding\Forthbase\libraries\libraries.f
need ForthVT100
need forth-map
include %idir%\ForthVT100_tables.f

map CONSTANT F1

s" 03:30:00" F1 	=>" RA"
s" -20:00:50" F1	=>" DEC" 
s" 179:59:59" F1 	=>" ALT"
s" 72:31:00" F1	=>" AZ" 

12 5 1 table
assign vt.green to-do table.text-format
assign vt.cyan to-do table.line-format 

vt.cls vt.home vt.reset

51 -> table.cellWidth
row |h ." Position of the mount"
12 -> table.cellWidth
F1 +map
row |r |r |r |r
row |t s" RA" RJ.	|t RA RJ. |t s" DEC" RJ. |t DEC RJ.
row |l |l |l |l
row |t s" Alt" RJ.	|t ALT RJ. |t s" AZ" RJ. |t AZ RJ.
row |f |f |f |f
F1 -map
CR
