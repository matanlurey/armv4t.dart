; expected result: 0x1f4 = 0xa, 0x1f8 = 0xc, 0x1fc = 0x10, 0x200 = 6, 0x204 = 0x200

main:
  mov r13, #0x200             ; r13          = 0x200

  mov r1, #10                 ; r1           = 0x10
  mov r2, #12                 ; r2           = 0x12
  BL test_func                ; pc           = <@test_func>
  stmia R13, {R0, R13}
  B exit

test_func:
  stmfd R13!, {R1, R2, R14}   ; @0x1f4       = 0xa
                              ; @0x1f8       = 0xc
                              ; 0x1fc        = 0x10
                              ; r13          = 0x200 (?)
  EOR R0, R1, R2
  ldmfd R13!, {R1, R2, R15}

exit:
