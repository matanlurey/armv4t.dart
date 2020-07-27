; expected result: 0x200: 0xff00, 0x204: 0xff80, 0x208: 0x7fffff80

; ARM MODE (Entrypoint)
processor CPU32_V1
  code32
    mov sp, 200
    mov r0, main - 1
processor CPU32_V4T
    BX r0

code16
  main:
    mov r7, sp
    mov r0, #0xff
    mov r6, #0
    strb r0, [r7, #1]
    ldrsh r1, [r7, r6]
    lsr r1, r1, #1
    strh r1, [r7, #4]
    str r1, [sp, #8]
