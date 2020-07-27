; expected result: 0x1fc = 0xff
; regression test for unaligned memory access

; ARM MODE (Entrypoint)
processor CPU32_V1
  code32
    mov sp, 0x200
    mov r0, main - 1
processor CPU32_V4T
    BX r0

code16
  main:
    mov r0, #0xff     ; r0    = 255
    lsl r0, r0, #16   ; r0    = 255 << 16
                      ; r0    = 0xff0000
    mov r2, sp        ; r2    = 200
    str r0, [r2]      ; @r2   = r0
                      ; @200  = 0xff0000
    mov r3, #2        ; r3    = 2
    ldr r1, [r2, r3]  ; r1    = @r2  + r3
                      ; r1    = @200 + 2
                      ; r1    = @200 + 2
                      ; r1    = @202
                      ; r1    = <MIS ALIGNED READ> 0xff
    push {r1}
