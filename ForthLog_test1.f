NEED ForthVT100
NEED simple-tester

LOG value log.test-saved-log
log.directory $value log.test-saved-directory
\ Maintenance: an append-open error must never try destructive CREATE_ALWAYS.
\ A held reader reproduces VFX's sharing failure without changing log contents.
' create-file constant log.test-original-create
variable log.test-create-count
: create-file ( caddr u fam -- fileid ior )
    1 log.test-create-count +!
    log.test-original-create execute
;
include "%idir%\ForthLog.f"

s" E:\" s" images\logs\regression-forth-log" makeDirLevels
    throw
s" E:\images\logs\regression-forth-log" $-> log.directory
s" forth-log-test" log.filepath 2dup delete-file drop

LOG-OFF
s" forth-log-test" s" ignored" log-line

Tstart
T{ s" forth-log-test" log.filepath r/o open-file nip 0<> }T -1 ==

LOG-ON
s" forth-log-test" s" first" log-line
LOG-OFF
s" forth-log-test" s" ignored" log-line
LOG-ON
s" forth-log-test" s" second" log-line
LOG-OFF

: log.test-third-line ( -- )
    s" forth-log-test" s" third" log-line
;

create forth-log-test-buffer 32 allot
variable forth-log-test-file

s" forth-log-test" log.filepath r/o open-file throw
forth-log-test-file !
0 log.test-create-count !
LOG-ON
T{ ' log.test-third-line catch 0<> }T -1 ==
T{ log.test-create-count @ }T 0 ==
forth-log-test-file @ close-file throw
log.test-third-line
LOG-OFF

s" forth-log-test" log.filepath r/o open-file
    throw
forth-log-test-file !

T{ forth-log-test-buffer 32 forth-log-test-file @ read-line
    throw drop
    forth-log-test-buffer swap hashS }T s" first" hashS ==
T{ forth-log-test-buffer 32 forth-log-test-file @ read-line
    throw drop
    forth-log-test-buffer swap hashS }T s" second" hashS ==
T{ forth-log-test-buffer 32 forth-log-test-file @ read-line
    throw drop
    forth-log-test-buffer swap hashS }T s" third" hashS ==
T{ forth-log-test-buffer 32 forth-log-test-file @ read-line
    throw nip }T 0 ==

forth-log-test-file @ close-file throw
s" forth-log-test" log.filepath delete-file
    throw
log.test-saved-directory $-> log.directory
log.test-saved-log -> LOG
T{ log.directory hashS }T log.test-saved-directory hashS ==
T{ LOG }T log.test-saved-log ==
Tend
