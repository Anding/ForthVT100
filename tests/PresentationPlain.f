NEED ForthVT100
PLAIN-PRESENTATION

: plain-presentation
    ." @@PRESENTATION-BEGIN" cr
    ." CLS " CLS ." is inert" cr
    s" Observatory session" .title
    s" Durable output" .>
    s" Emphasized output" .emphasis
    s" This sentence demonstrates plain width-controlled wrapping without terminal control sequences." .wrap
    s" Diagnostic output" .D>
    s" Error output" .E>
    s" This transient status must not be redirected" ...>
    -...
    ." Cursor controls " 40 vt.column ." remain plain" cr

    s" Camera" panel{
    s" Model"       s" ASI2600MM Pro" .field
    s" Temperature" s" -10.2 C"       .field
    }panel

    0 12 1 table
    row |h s" Filter" LJ. |h s" Exposure" LJ.
    row |t s" LUM" LJ.    |t s" 60 s" RJ.
    row |t s" RED" LJ.    |t s" 120 s" RJ.
    row |f |f
    }table

    ." @@PRESENTATION-END" cr
;

plain-presentation
bye
