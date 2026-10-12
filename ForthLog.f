\ Optional named-channel text logging, independent of terminal presentation.

NEED ForthBase

0 value LOG
s" ." $value log.directory
s" " $value log.pathname

: LOG-ON  ( -- ) -1 -> LOG ;
: LOG-OFF ( -- )  0 -> LOG ;

: log.filepath { channel-addr channel-u -- caddr u }
    log.directory $-> log.pathname
    s" \" $+> log.pathname
    channel-addr channel-u $+> log.pathname
    s" .log" $+> log.pathname
    log.pathname
;

: log.open-append { caddr u | fileid zaddr[ 1024 ] -- fileid }
    \ Open errors include sharing violations, not just missing files.
    \ Atomic OPEN_ALWAYS (4) never truncates an existing channel on failure.
    caddr u expand zaddr[ zplace
    zaddr[ r/w 1 0 4 0 0 CreateFile -> fileid
    fileid -1 = abort" Cannot open log channel"
    fileid file-size abort" Cannot size log channel"
    fileid reposition-file abort" Cannot append log channel"
    fileid
;

: log-line
    { channel-addr channel-u message-addr message-u | fileid -- }
    LOG 0= if exit then
    channel-addr channel-u log.filepath log.open-append -> fileid
    message-addr message-u fileid write-line
        abort" Cannot write log channel"
    fileid flush-file abort" Cannot flush log channel"
    fileid close-file abort" Cannot close log channel"
;
