NEED ForthVT100
NEED ordered-maps
NEED simple-tester

allocate-map CONSTANT F1

s" 03:30:00" F1 =>" RA"
s" -20:00:50" F1 =>" DEC"
s" 179:59:59" F1 =>" ALT"
s" 72:31:00" F1 =>" AZ"

: position-table
    0 12 1 table
    row |h s" Coordinate" LJ. |h s" Value" LJ.
    row |r |r
    row |t s" RA" LJ.  |t s" RA" F1 map@ RJ.
    row |t s" DEC" LJ. |t s" DEC" F1 map@ RJ.
    row |t s" ALT" LJ. |t s" ALT" F1 map@ RJ.
    row |t s" AZ" LJ.  |t s" AZ" F1 map@ RJ.
    row |f |f
    }table
;

Tstart
T{ 1234 position-table }T 1234 ==
T{ F1 map-count }T 4 ==
T{ s" RA" F1 map@ s" 03:30:00" compare }T 0 ==
T{ s" DEC" F1 map@ s" -20:00:50" compare }T 0 ==
T{ s" missing" F1 map@ }T 0 0 ==
T{ F1 free-map }T ==
Tend
