; expected result: 0x200: 0xff00, 0x204: 0xff80, 0x208: 0x7fffff80

; ARM MODE (Entrypoint)
processor CPU32_V1
  code32
    mov sp, 0x200
    mov r0, main - 1
processor CPU32_V4T
    BX r0

code16
  main:
    mov r7, sp          ; r7         = r13
                        ; r7         = 0x200
    mov r0, #0xff       ; r0         = 0xff
    mov r6, #0          ; r6         = 0
    strb r0, [r7, #1]   ; @(r7  + 1) = r0
                        ; @(200 + 1) = r0
                        ; @201       = 0xff
    ldrsh r1, [r7, r6]  ; r1         = signed @(r7   + r6)
                        ; r1         = signed @(0x200 + 0)
                        ; r1         = signed @0x200
                        ; r1         = signed 0xff
                        ; r1         = 0xff00
    lsr r1, r1, #1      ; r1         = r1 << 1
                        ; r1         = 0xff00 << 1
                        ; r1         = 0x1fe00
    strh r1, [r7, #4]   ; 
                        ; @0x204     = 0x7f80
    str r1, [sp, #8]
