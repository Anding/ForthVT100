NEED ForthVT100
TERMINAL-PRESENTATION

: terminal-presentation
    ." @@TERMINAL-BEGIN" cr
    s" Waiting for exposure" ...>
    -...
    s" Exposure complete" .OK>
    0 8 1 table
    row |h s" State" LJ. |h s" Value" LJ.
    row |f |f
    }table
    3 4 .progress
    -...
    ." @@TERMINAL-END" cr
;

terminal-presentation
bye
