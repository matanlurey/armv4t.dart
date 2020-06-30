mov r0, 32                      ; 0xE3A00020
cmp r0, 32                      ; 0xE3500020
bne 0                           ; 0x1A000000
b 16777215                      ; 0xEAFFFFFF
mvn r0, 0                       ; 0xE3E00000
adds r0, r0, 1                  ; 0xE2900001
bne 0                           ; 0x1A000000
b 16777215                      ; 0xEAFFFFFF
mov r0, 255                     ; 0xE3A000FF
and r0, r0, 15                  ; 0xE200000F
cmp r0, 15                      ; 0xE350000F
bne 0                           ; 0x1A000000
b 16777215                      ; 0xEAFFFFFF
mov r0, 255                     ; 0xE3A000FF
eor r0, r0, 240                 ; 0xE22000F0
cmp r0, 15                      ; 0xE350000F
bne 0                           ; 0x1A000000
b 16777215                      ; 0xEAFFFFFF
mov r0, 240                     ; 0xE3A000F0
orr r0, r0, 15                  ; 0xE380000F
cmp r0, 255                     ; 0xE35000FF
bne 0                           ; 0x1A000000
b 16777215                      ; 0xEAFFFFFF
mov r0, 255                     ; 0xE3A000FF
bic r0, r0, 15                  ; 0xE3C0000F
cmp r0, 240                     ; 0xE35000F0
bne 0                           ; 0x1A000000
b 16777215                      ; 0xEAFFFFFF
mov r0, 32                      ; 0xE3A00020
add r0, r0, 32                  ; 0xE2800020
cmp r0, 64                      ; 0xE3500040
bne 0                           ; 0x1A000000
b 16777215                      ; 0xEAFFFFFF
msr cpsr_c, 0                   ; 0xE328F000
movs r0, 32                     ; 0xE3B00020
adc r0, r0, 32                  ; 0xE2A00020
cmp r0, 64                      ; 0xE3500040
bne 5                           ; 0x1A000005
msr cpsr_c, 514                 ; 0xE328F202
mov r0, 32                      ; 0xE3A00020
adc r0, r0, 32                  ; 0xE2A00020
cmp r0, 65                      ; 0xE3500041
bne 0                           ; 0x1A000000
b 16777215                      ; 0xEAFFFFFF
mov r0, 64                      ; 0xE3A00040
sub r0, r0, 32                  ; 0xE2400020
cmp r0, 32                      ; 0xE3500020
bne 0                           ; 0x1A000000
b 16777215                      ; 0xEAFFFFFF
mov r0, 32                      ; 0xE3A00020
rsb r0, r0, 64                  ; 0xE2600040
cmp r0, 32                      ; 0xE3500020
bne 0                           ; 0x1A000000
b 16777215                      ; 0xEAFFFFFF
msr cpsr_c, 0                   ; 0xE328F000
mov r0, 64                      ; 0xE3A00040
sbc r0, r0, 32                  ; 0xE2C00020
cmp r0, 31                      ; 0xE350001F
bne 5                           ; 0x1A000005
msr cpsr_c, 514                 ; 0xE328F202
mov r0, 64                      ; 0xE3A00040
sbc r0, r0, 32                  ; 0xE2C00020
cmp r0, 32                      ; 0xE3500020
bne 0                           ; 0x1A000000
b 16777215                      ; 0xEAFFFFFF
msr cpsr_c, 0                   ; 0xE328F000
mov r0, 32                      ; 0xE3A00020
rsc r0, r0, 64                  ; 0xE2E00040
cmp r0, 31                      ; 0xE350001F
bne 5                           ; 0x1A000005
msr cpsr_c, 514                 ; 0xE328F202
mov r0, 32                      ; 0xE3A00020
rsc r0, r0, 64                  ; 0xE2E00040
cmp r0, 32                      ; 0xE3500020
bne 0                           ; 0x1A000000
b 16777215                      ; 0xEAFFFFFF
mov r0, 32                      ; 0xE3A00020
cmp r0, r0                      ; 0xE1500000
bne 0                           ; 0x1A000000
b 16777215                      ; 0xEAFFFFFF
mov r0, 8                       ; 0xE3A00102
cmn r0, r0                      ; 0xE1700000
bne 0                           ; 0x1A000000
b 16777215                      ; 0xEAFFFFFF
mov r0, 240                     ; 0xE3A000F0
tst r0, 15                      ; 0xE310000F
bne 0                           ; 0x1A000000
b 16777215                      ; 0xEAFFFFFF
mov r0, 255                     ; 0xE3A000FF
teq r0, 255                     ; 0xE33000FF
bne 0                           ; 0x1A000000
b 16777215                      ; 0xEAFFFFFF
mov r0, 4278190080              ; 0xE3A00CFF
mov r1, 255                     ; 0xE3A010FF
mov r1, r1, lsl r4              ; 0xE1A01401
cmp r1, r0                      ; 0xE1510000
bne 0                           ; 0x1A000000
b 16777215                      ; 0xEAFFFFFF
movs r0, 4080                   ; 0xE3B002FF
bcc 2                           ; 0x3A000002
movs r0, 1044480                ; 0xE3B006FF
bcs 0                           ; 0x2A000000
b 16777215                      ; 0xEAFFFFFF
mov r0, 255                     ; 0xE3A000FF
mov r1, 4                       ; 0xE3A01004
movs r2, r0, ror r1             ; 0xE1B02170
bcc 4                           ; 0x3A000004
mov r0, 240                     ; 0xE3A000F0
mov r1, 4                       ; 0xE3A01004
movs r2, r0, ror r1             ; 0xE1B02170
bcs 0                           ; 0x2A000000
b 16777215                      ; 0xEAFFFFFF
mov r0, 255                     ; 0xE3A000FF
movs r1, r0, ror 4              ; 0xE1B01260
bcc 3                           ; 0x3A000003
mov r0, 240                     ; 0xE3A000F0
movs r1, r0, ror 4              ; 0xE1B01260
bcs 0                           ; 0x2A000000
b 16777215                      ; 0xEAFFFFFF
mov r0, 0                       ; 0xE3A00000
msr cpsr_c, 514                 ; 0xE328F202
movs r0, r0, rrx                ; 0xE1B00060
bcs 2                           ; 0x2A000002
cmp r0, 8                       ; 0xE3500102
bne 0                           ; 0x1A000000
b 16777215                      ; 0xEAFFFFFF
add r0, pc, 4                   ; 0xE28F0004
cmp r0, r15                     ; 0xE150000F
bne 0                           ; 0x1A000000
b 16777215                      ; 0xEAFFFFFF
add r0, pc, 0                   ; 0xE28F0000
mov pc, r0                      ; 0xE1A0F000
mov r8, 32                      ; 0xE3A08020
msr cpsr_cf, 17                 ; 0xE329F011
mov r8, 64                      ; 0xE3A08040
msr spsr_cf, 31                 ; 0xE369F01F
subs pc, pc, 4                  ; 0xE25FF004
cmp r8, 32                      ; 0xE3580020
bne 0                           ; 0x1A000000
b 16777215                      ; 0xEAFFFFFF
mov r0, 0                       ; 0xE3A00000
???? <FormatException>          ; 0xE1A0001F
cmp r0, r15                     ; 0xE150000F
bne 0                           ; 0x1A000000
b 16777215                      ; 0xEAFFFFFF
mov r0, 0                       ; 0xE3A00000
???? <FormatException>          ; 0xE08F0010
cmp r0, r15                     ; 0xE150000F
bne 0                           ; 0x1A000000
b 16777215                      ; 0xEAFFFFFF
mov r0, 0                       ; 0xE3A00000
mov r2, r14                     ; 0xE1A0200E
b 16777215                      ; 0xEBFFFFFF
mov r1, r14                     ; 0xE1A0100E
mov lr, r2                      ; 0xE1A0E002
add r0, pc, r0                  ; 0xE08F0000
add r1, r1, 16                  ; 0xE2811010
cmp r1, r0                      ; 0xE1510000
bne 0                           ; 0x1A000000
b 16777215                      ; 0xEAFFFFFF
msr cpsr_c, 0                   ; 0xE328F000
movs r0, 8                      ; 0xE3B00102
bcc 1                           ; 0x3A000001
bpl 0                           ; 0x5A000000
b 16777215                      ; 0xEAFFFFFF
msr cpsr_c, 514                 ; 0xE328F202
mov r0, 0                       ; 0xE3A00000
adcs r0, r0, 8                  ; 0xE2B00102
cmp r0, 24                      ; 0xE3500106
bne 5                           ; 0x1A000005
msr cpsr_c, 514                 ; 0xE328F202
mov r0, 0                       ; 0xE3A00000
adcs r0, r0, 112                ; 0xE2B00207
cmp r0, 368                     ; 0xE3500217
bne 0                           ; 0x1A000000
b 16777215                      ; 0xEAFFFFFF
msr cpsr_c, 0                   ; 0xE328F000
mov r0, 128                     ; 0xE3A00080
movs r0, r0, ror 8              ; 0xE1B00460
bcc 1                           ; 0x3A000001
bpl 0                           ; 0x5A000000
b 16777215                      ; 0xEAFFFFFF
msr cpsr_c, 514                 ; 0xE328F202
mov r0, 0                       ; 0xE3A00000
mov r1, 128                     ; 0xE3A01080
adcs r0, r0, r1, ror 8          ; 0xE0B00461
cmp r0, 24                      ; 0xE3500106
bne 6                           ; 0x1A000006
msr cpsr_c, 514                 ; 0xE328F202
mov r0, 0                       ; 0xE3A00000
mov r1, 112                     ; 0xE3A01070
adcs r0, r0, r1, ror 8          ; 0xE0B00461
cmp r0, 368                     ; 0xE3500217
bne 0                           ; 0x1A000000
b 16777215                      ; 0xEAFFFFFF
msr cpsr_c, 0                   ; 0xE328F000
mov r0, 128                     ; 0xE3A00080
mov r1, 8                       ; 0xE3A01008
movs r0, r0, ror r1             ; 0xE1B00170
bcc 1                           ; 0x3A000001
bpl 0                           ; 0x5A000000
b 16777215                      ; 0xEAFFFFFF
msr cpsr_c, 514                 ; 0xE328F202
mov r0, 0                       ; 0xE3A00000
mov r1, 128                     ; 0xE3A01080
mov r2, 8                       ; 0xE3A02008
adcs r0, r0, r1, ror r2         ; 0xE0B00271
cmp r0, 24                      ; 0xE3500106
bne 7                           ; 0x1A000007
msr cpsr_c, 514                 ; 0xE328F202
mov r0, 0                       ; 0xE3A00000
mov r1, 112                     ; 0xE3A01070
mov r2, 8                       ; 0xE3A02008
adcs r0, r0, r1, ror r2         ; 0xE0B00271
cmp r0, 368                     ; 0xE3500217
bne 0                           ; 0x1A000000
b 16777215                      ; 0xEAFFFFFF
msr cpsr_c, 0                   ; 0xE328F000
tst r0, 8                       ; 0xE3100102
bcc 3                           ; 0x3A000003
msr cpsr_c, 0                   ; 0xE328F000
teq r0, 8                       ; 0xE3300102
bcc 0                           ; 0x3A000000
b 16777215                      ; 0xEAFFFFFF