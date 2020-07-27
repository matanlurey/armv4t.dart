; expected result: 0x200 = 4, 0x204 = 5

; ARM MODE (Entrypoint)
processor CPU32_V1
  code32
    mov sp, 0x200         ; 0x0
    mov r0, main - 1      ; 0x4
processor CPU32_V4T
    BX r0                 ; 0x8

code16
  main:
    bl func               ; 0xa
    b ending              ; 0xc

  func:
    mov r0, #4            ; 0xe
    mov r1, lr            ; 0x10
    bx lr

  ending:
    str r0, [sp]          ; 0x12
    str r1, [sp, #4]      ; 0x14
