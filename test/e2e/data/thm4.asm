; expected result: 0x200 = 4, 0x204 = 5

; ARM MODE (Entrypoint)
processor CPU32_V1
  code32
    mov sp, 0x200         ; 0x00
    mov r0, main - 1      ; 0x04
processor CPU32_V4T
    BX r0                 ; 0x08

code16
  main:
    bl func               ; (Two instructions)
                          ; 0x0c
                          ;   r14 = 0x0c
                          ; 0x0e
                          ;   ...
    b ending              ; 0x10

  func:
    mov r0, #4            ; 0x12
    mov r1, lr            ; 0x14
    bx lr                 ; 0x16

  ending:
    str r0, [sp]          ; 0x18
    str r1, [sp, #4]      ; 0x20
