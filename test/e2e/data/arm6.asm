; expected result: 0x1f4 = 0xa, 0x1f8 = 0xc, 0x1fc = 0x10, 0x200 = 6, 0x204 = 0x200

mov r13, #0x200

mov r1, #10
mov r2, #12
BL test_func
stmia R13, {R0, R13}
B exit

test_func:
stmfd R13!, {R1, R2, R14}
EOR R0, R1, R2
ldmfd R13!, {R1, R2, R15}

exit:
