; expected result: 0x1fc = 0

; ARM MODE (Entrypoint)
processor CPU32_V1
  code32
    mov sp, 0x200
    mov r0, main - 1
processor CPU32_V4T
    BX r0

code16
  main:
    mov r0, #2
    mov r1, #2
    cmp r0, r1
    sbc r0, r0
    push {r0}
