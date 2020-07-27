; expected result: 0x200 = 10, 0x204 = 83

; ARM MODE (Entrypoint)
processor CPU32_V1
  code32
    mov sp, 200
    mov r0, main - 1
processor CPU32_V4T
    BX r0

code16
  main:
    mov r2, #83
    mov r3, #10
    cmp r2, r3
    blt less
    str r3, [sp]
    str r2, [sp, #4]
    b exit
  less:
    str r2, [sp]
    str r3, [sp, #4]
  exit:
