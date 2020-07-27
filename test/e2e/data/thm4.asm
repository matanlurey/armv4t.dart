; expected result: 0x200 = 4, 0x204 = 5

; ARM MODE (Entrypoint)
processor CPU32_V1
  code32
    mov sp, 200
    mov r0, main - 1
processor CPU32_V4T
    BX r0

code16
  main:
    bl func
    b ending

  func:
    mov r0, #4
    mov r1, lr
    bx lr

  ending:
    str r0, [sp]
    str r1, [sp, #4]
