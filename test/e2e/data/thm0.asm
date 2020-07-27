; expected result: 0x1ec = 10, 0x1f0 = 15, 0x1f4 = 5, 0x1f8 = 60, 0x1fc = 0x200

; ARM MODE (Entrypoint)
processor CPU32_V1
  code32
    mov sp, 0x200
    mov r0, main - 1
processor CPU32_V4T
    BX r0

code16
  main:
    mov r0, #10                ; r0 = 10
    mov r1, #15                ; r1 = 15
    mov r2, r1                 ; r2 = 15
    eor r2, r2, r0             ; r2 = r2 XOR r0
                               ; r2 = 15 XOR 10
                               ; r2 = 5
    lsl r3, r1, #2             ; r3 = r1 << 2
                               ; r3 = 15 << 2
                               ; r3 = 60
    mov r4, r13                ; r4 = 200
    push {r0, r1, r2, r3, r4}  ; stmfd r13!, {r0-r4}
                               ; this is a pre-decrement store i.e. STMDB
                               ;
