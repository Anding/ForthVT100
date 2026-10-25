\ Optional named-channel text logging, independent of terminal presentation.

NEED ForthBase

0 value LOG
s" ." $value log.directory
s" " $value log.pathname

: LOG-ON  ( -- ) -1 -> LOG ;
: LOG-OFF ( -- )  0 -> LOG ;

: log.filepath { channel-addr channel-u -- caddr u }
\ Assemble the selected channel's pathname.
    log.directory $-> log.pathname
    s" \" $+> log.pathname
    channel-addr channel-u $+> log.pathname
    s" .log" $+> log.pathname
    log.pathname
;

: log-line
    { channel-addr channel-u message-addr message-u | fileid zaddr[ 1024 ] -- }
\ Append one message if logging is enabled; always close an opened channel.
    LOG 0= if exit then
    \ Open errors include sharing violations, not just missing files.
    \ Atomic OPEN_ALWAYS (4) never truncates an existing channel on failure.
    channel-addr channel-u log.filepath expand zaddr[ zplace
    zaddr[ r/w 1 0 4 0 0 CreateFile -> fileid
    fileid -1 = if s" Cannot open log channel" .E> exit then
    fileid file-size if 2drop true else fileid reposition-file then if
        s" Cannot append log channel" .E>
    else
        message-addr message-u fileid write-line if
            s" Cannot write log channel" .E>
        else
            fileid flush-file if s" Cannot flush log channel" .E> then
        then
    then
    fileid close-file if s" Cannot close log channel" .E> then
;
