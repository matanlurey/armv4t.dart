mov r12, 50                     ; 0xE3A0C032
add r0, pc, 1                   ; 0xE28F0001
bx r0                           ; 0xE12FFF10
???? <UnimplementedError>       ; 0x46842033
strmi r10, [r0, -r0]            ; 0x4700A000
mov r12, 52                     ; 0xE3A0C034
add r0, pc, 0                   ; 0xE28F0000
bx r0                           ; 0xE12FFF10
mov r12, 53                     ; 0xE3A0C035
b 1                             ; 0xEA000001
mov r12, 55                     ; 0xE3A0C037
b 3                             ; 0xEA000003
mov r12, 54                     ; 0xE3A0C036
b 16777211                      ; 0xEAFFFFFB
mov r12, 57                     ; 0xE3A0C039
mov pc, r14                     ; 0xE1A0F00E
mov r12, 56                     ; 0xE3A0C038
b 16777211                      ; 0xEBFFFFFB
mov r12, 0                      ; 0xE3A0C000