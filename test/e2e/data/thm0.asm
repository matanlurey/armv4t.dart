; expected result: 0x1ec = 10, 0x1f0 = 15, 0x1f4 = 5, 0x1f8 = 60, 0x1fc = 0x200

; ARM MODE (Entrypoint)
processor CPU32_V1
  code32
    mov sp, 200
    mov r0, main - 1
processor CPU32_V4T
    BX r0

code16
  main:
    mov r0, #10
    mov r1, #15
    mov r2, r1
    eor r2, r2, r0
    lsl r3, r1, #2
    mov r4, r13
    push {r0, r1, r2, r3, r4}
