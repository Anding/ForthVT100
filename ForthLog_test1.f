NEED ForthVT100
NEED simple-tester

s" %idir%" $-> log.directory
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

create forth-log-test-buffer 32 allot
variable forth-log-test-file

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
    throw nip }T 0 ==

forth-log-test-file @ close-file throw
s" forth-log-test" log.filepath delete-file
    throw
Tend
