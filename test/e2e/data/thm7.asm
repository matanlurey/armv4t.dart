; expected result: 0x1fc = 0xff
; regression test for unaligned memory access

; ARM MODE (Entrypoint)
processor CPU32_V1
  code32
    mov sp, 200
    mov r0, main - 1
processor CPU32_V4T
    BX r0

code16
  main:
    mov r0, #0xff
    lsl r0, r0, #16
    mov r2, sp
    str r0, [r2]
    mov r3, #2
    ldr r1, [r2, r3]
    push {r1}
