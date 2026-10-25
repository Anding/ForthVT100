NEED ForthVT100
NEED simple-tester

LOG value log.test-saved-log
log.directory $value log.test-saved-directory
\ A held reader reproduces sharing failure without changing existing contents.

Tstart
T{ s" E:\" s" images\logs\regression-forth-log" makeDirLevels }T 0 ==
s" E:\images\logs\regression-forth-log" $-> log.directory
s" forth-log-test" log.filepath 2dup delete-file drop

LOG-OFF
s" forth-log-test" s" ignored" log-line

T{ s" forth-log-test" log.filepath r/o open-file nip 0<> }T -1 ==

LOG-ON
s" forth-log-test" s" first" log-line
LOG-OFF
s" forth-log-test" s" ignored" log-line
LOG-ON
s" forth-log-test" s" second" log-line
LOG-OFF

create forth-log-test-buffer 32 allot
variable forth-log-test-file

T{ s" forth-log-test" log.filepath r/o open-file
    swap forth-log-test-file ! }T 0 ==
LOG-ON
T{ s" forth-log-test" s" third" log-line }T ==
T{ forth-log-test-file @ close-file }T 0 ==
s" forth-log-test" s" third" log-line
LOG-OFF

T{ s" forth-log-test" log.filepath r/o open-file
    swap forth-log-test-file ! }T 0 ==

T{ forth-log-test-buffer 32 forth-log-test-file @ read-line
    >r drop forth-log-test-buffer swap hashS r> }T s" first" hashS 0 ==
T{ forth-log-test-buffer 32 forth-log-test-file @ read-line
    >r drop forth-log-test-buffer swap hashS r> }T s" second" hashS 0 ==
T{ forth-log-test-buffer 32 forth-log-test-file @ read-line
    >r drop forth-log-test-buffer swap hashS r> }T s" third" hashS 0 ==
T{ forth-log-test-buffer 32 forth-log-test-file @ read-line
    nip }T 0 0 ==

T{ forth-log-test-file @ close-file }T 0 ==
T{ s" forth-log-test" log.filepath delete-file }T 0 ==
log.test-saved-directory $-> log.directory
log.test-saved-log -> LOG
T{ log.directory hashS }T log.test-saved-directory hashS ==
T{ LOG }T log.test-saved-log ==
Tend
