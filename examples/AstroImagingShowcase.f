NEED ForthVT100

: showcase-status
    s" Transient observing status" .section
    8 0 do
        s" Plate solving" i .spinner
        80 ms
    loop
    -...
    0 101 10 do
        i 100 .progress
        35 ms
    10 +loop
    -...
    s" Field solved in 1.8 seconds" .OK>
;

: showcase-equipment
    s" Connected equipment" .section

    s" Camera" panel{
    s" Model"       s" ASI2600MM Pro" .field
    s" Frame"       s" 6248 x 4176"   .field
    s" Gain"        s" 100"           .field
    s" Offset"      s" 50"            .field
    s" Temperature" s" -10.2 C"       .field
    }panel

    s" Mount" panel{
    s" Model"     s" GM1000HPS" .field
    s" State"     s" Tracking"  .field
    s" Pier side" s" East"      .field
    s" Target"    s" M45"       .field
    }panel
;

: showcase-sequence
    s" Observation sequence" .section
    s" Connect and inspect equipment" 0 .branch
    s" Camera ready"                  1 .branch
    s" Wheel at LUM"                  1 .branch
    s" Mount tracking"                1 .branch
    s" Autofocus"                     0 .branch
    s" Nine-point model"              0 .branch
    s" Science exposure"              0 .branch
;

: showcase-table
    s" Imaging plan" .section
    1 16 1 table
    row |h s" Filter" LJ. |h s" Exposure" LJ. |h s" Frames" LJ.
    row |r |r |r
    row |t s" LUM" LJ. |t s" 60 s" RJ.  |t s" 20" RJ.
    row |t s" RED" LJ. |t s" 120 s" RJ. |t s" 10" RJ.
    row |t s" GREEN" LJ. |t s" 120 s" RJ. |t s" 10" RJ.
    row |t s" BLUE" LJ. |t s" 120 s" RJ. |t s" 10" RJ.
    row |f |f |f
    }table
;

: showcase-histogram
    s" Preview histogram" .section
    ."   Background  " 18 100 36 .bar
    ."   Midtones    " 54 100 36 .bar
    ."   Highlights  " 91 100 36 .bar
;

: showcase ( -- )
    CLS
    s" AstroImagingInForth terminal presentation" .title
    s" Beautiful scrolling output with automatic clean redirection." .emphasis
    s" The presentation remains ordinary sequential Forth output while terminal capability adds hierarchy, colour, transient activity, and structure." .wrap
    cr

    s" Home observatory attached without changing retained hardware state." .OK>
    s" Polar alignment should be refined before long exposures." .W>
    s" ASTAP catalogue path not found" .E>
    s" Solver request: RA 03:47:24  Dec +24:07:00" .D>
    cr

    showcase-status cr
    showcase-equipment cr
    showcase-sequence cr
    showcase-table cr
    showcase-histogram
    cr
    s" Operator interaction" .section
    s" Continue with the science sequence" .Q> ." yes" cr
;

showcase

