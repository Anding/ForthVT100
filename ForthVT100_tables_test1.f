NEED ForthVT100
NEED forth-map

map CONSTANT F1

s" 03:30:00" F1 =>" RA"
s" -20:00:50" F1 =>" DEC"
s" 179:59:59" F1 =>" ALT"
s" 72:31:00" F1 =>" AZ"

: position-table
    0 12 1 table
    row |h s" Coordinate" LJ. |h s" Value" LJ.
    row |r |r
    F1 +map
    row |t s" RA" LJ.  |t RA RJ.
    row |t s" DEC" LJ. |t DEC RJ.
    row |t s" ALT" LJ. |t ALT RJ.
    row |t s" AZ" LJ.  |t AZ RJ.
    F1 -map
    row |f |f
    }table
;

position-table
