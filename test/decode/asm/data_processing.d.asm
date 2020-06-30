MOV R0, #32                     ; 0xE3A00020
CMP R0, #32                     ; 0xE3500020
BNE 0                           ; 0x1A000000
B 16777215                      ; 0xEAFFFFFF
MVN R0, #0                      ; 0xE3E00000
ADDS R0, R0, #1                 ; 0xE2900001
BNE 0                           ; 0x1A000000
B 16777215                      ; 0xEAFFFFFF
MOV R0, #255                    ; 0xE3A000FF
AND R0, R0, #15                 ; 0xE200000F
CMP R0, #15                     ; 0xE350000F
BNE 0                           ; 0x1A000000
B 16777215                      ; 0xEAFFFFFF
MOV R0, #255                    ; 0xE3A000FF
EOR R0, R0, #240                ; 0xE22000F0
CMP R0, #15                     ; 0xE350000F
BNE 0                           ; 0x1A000000
B 16777215                      ; 0xEAFFFFFF
MOV R0, #240                    ; 0xE3A000F0
ORR R0, R0, #15                 ; 0xE380000F
CMP R0, #255                    ; 0xE35000FF
BNE 0                           ; 0x1A000000
B 16777215                      ; 0xEAFFFFFF
MOV R0, #255                    ; 0xE3A000FF
BIC R0, R0, #15                 ; 0xE3C0000F
CMP R0, #240                    ; 0xE35000F0
BNE 0                           ; 0x1A000000
B 16777215                      ; 0xEAFFFFFF
MOV R0, #32                     ; 0xE3A00020
ADD R0, R0, #32                 ; 0xE2800020
CMP R0, #64                     ; 0xE3500040
BNE 0                           ; 0x1A000000
B 16777215                      ; 0xEAFFFFFF
MSR CPSR_C, #0                  ; 0xE328F000
MOVS R0, #32                    ; 0xE3B00020
ADC R0, R0, #32                 ; 0xE2A00020
CMP R0, #64                     ; 0xE3500040
BNE 5                           ; 0x1A000005
MSR CPSR_C, #514                ; 0xE328F202
MOV R0, #32                     ; 0xE3A00020
ADC R0, R0, #32                 ; 0xE2A00020
CMP R0, #65                     ; 0xE3500041
BNE 0                           ; 0x1A000000
B 16777215                      ; 0xEAFFFFFF
MOV R0, #64                     ; 0xE3A00040
SUB R0, R0, #32                 ; 0xE2400020
CMP R0, #32                     ; 0xE3500020
BNE 0                           ; 0x1A000000
B 16777215                      ; 0xEAFFFFFF
MOV R0, #32                     ; 0xE3A00020
RSB R0, R0, #64                 ; 0xE2600040
CMP R0, #32                     ; 0xE3500020
BNE 0                           ; 0x1A000000
B 16777215                      ; 0xEAFFFFFF
MSR CPSR_C, #0                  ; 0xE328F000
MOV R0, #64                     ; 0xE3A00040
SBC R0, R0, #32                 ; 0xE2C00020
CMP R0, #31                     ; 0xE350001F
BNE 5                           ; 0x1A000005
MSR CPSR_C, #514                ; 0xE328F202
MOV R0, #64                     ; 0xE3A00040
SBC R0, R0, #32                 ; 0xE2C00020
CMP R0, #32                     ; 0xE3500020
BNE 0                           ; 0x1A000000
B 16777215                      ; 0xEAFFFFFF
MSR CPSR_C, #0                  ; 0xE328F000
MOV R0, #32                     ; 0xE3A00020
RSC R0, R0, #64                 ; 0xE2E00040
CMP R0, #31                     ; 0xE350001F
BNE 5                           ; 0x1A000005
MSR CPSR_C, #514                ; 0xE328F202
MOV R0, #32                     ; 0xE3A00020
RSC R0, R0, #64                 ; 0xE2E00040
CMP R0, #32                     ; 0xE3500020
BNE 0                           ; 0x1A000000
B 16777215                      ; 0xEAFFFFFF
MOV R0, #32                     ; 0xE3A00020
CMP R0, R0                      ; 0xE1500000
BNE 0                           ; 0x1A000000
B 16777215                      ; 0xEAFFFFFF
MOV R0, #8                      ; 0xE3A00102
CMN R0, R0                      ; 0xE1700000
BNE 0                           ; 0x1A000000
B 16777215                      ; 0xEAFFFFFF
MOV R0, #240                    ; 0xE3A000F0
TST R0, #15                     ; 0xE310000F
BNE 0                           ; 0x1A000000
B 16777215                      ; 0xEAFFFFFF
MOV R0, #255                    ; 0xE3A000FF
TEQ R0, #255                    ; 0xE33000FF
BNE 0                           ; 0x1A000000
B 16777215                      ; 0xEAFFFFFF
MOV R0, #4278190080             ; 0xE3A00CFF
MOV R1, #255                    ; 0xE3A010FF
MOV R1, R1, LSL R4              ; 0xE1A01401
CMP R1, R0                      ; 0xE1510000
BNE 0                           ; 0x1A000000
B 16777215                      ; 0xEAFFFFFF
MOVS R0, #4080                  ; 0xE3B002FF
BCC 2                           ; 0x3A000002
MOVS R0, #1044480               ; 0xE3B006FF
BCS 0                           ; 0x2A000000
B 16777215                      ; 0xEAFFFFFF
MOV R0, #255                    ; 0xE3A000FF
MOV R1, #4                      ; 0xE3A01004
MOVS R2, R0, ROR R1             ; 0xE1B02170
BCC 4                           ; 0x3A000004
MOV R0, #240                    ; 0xE3A000F0
MOV R1, #4                      ; 0xE3A01004
MOVS R2, R0, ROR R1             ; 0xE1B02170
BCS 0                           ; 0x2A000000
B 16777215                      ; 0xEAFFFFFF
MOV R0, #255                    ; 0xE3A000FF
MOVS R1, R0, ROR #4             ; 0xE1B01260
BCC 3                           ; 0x3A000003
MOV R0, #240                    ; 0xE3A000F0
MOVS R1, R0, ROR #4             ; 0xE1B01260
BCS 0                           ; 0x2A000000
B 16777215                      ; 0xEAFFFFFF
MOV R0, #0                      ; 0xE3A00000
MSR CPSR_C, #514                ; 0xE328F202
MOVS R0, R0, RRX                ; 0xE1B00060
BCS 2                           ; 0x2A000002
CMP R0, #8                      ; 0xE3500102
BNE 0                           ; 0x1A000000
B 16777215                      ; 0xEAFFFFFF
ADD R0, R15, #4                 ; 0xE28F0004
CMP R0, R15                     ; 0xE150000F
BNE 0                           ; 0x1A000000
B 16777215                      ; 0xEAFFFFFF
ADD R0, R15, #0                 ; 0xE28F0000
MOV R15, R0                     ; 0xE1A0F000
MOV R8, #32                     ; 0xE3A08020
MSR CPSR_CF, #17                ; 0xE329F011
MOV R8, #64                     ; 0xE3A08040
MSR SPSR_CF, #31                ; 0xE369F01F
SUBS R15, R15, #4               ; 0xE25FF004
CMP R8, #32                     ; 0xE3580020
BNE 0                           ; 0x1A000000
B 16777215                      ; 0xEAFFFFFF
MOV R0, #0                      ; 0xE3A00000
???? <FormatException>          ; 0xE1A0001F
CMP R0, R15                     ; 0xE150000F
BNE 0                           ; 0x1A000000
B 16777215                      ; 0xEAFFFFFF
MOV R0, #0                      ; 0xE3A00000
???? <FormatException>          ; 0xE08F0010
CMP R0, R15                     ; 0xE150000F
BNE 0                           ; 0x1A000000
B 16777215                      ; 0xEAFFFFFF
MOV R0, #0                      ; 0xE3A00000
MOV R2, R14                     ; 0xE1A0200E
BL 16777215                     ; 0xEBFFFFFF
MOV R1, R14                     ; 0xE1A0100E
MOV R14, R2                     ; 0xE1A0E002
ADD R0, R15, R0                 ; 0xE08F0000
ADD R1, R1, #16                 ; 0xE2811010
CMP R1, R0                      ; 0xE1510000
BNE 0                           ; 0x1A000000
B 16777215                      ; 0xEAFFFFFF
MSR CPSR_C, #0                  ; 0xE328F000
MOVS R0, #8                     ; 0xE3B00102
BCC 1                           ; 0x3A000001
BPL 0                           ; 0x5A000000
B 16777215                      ; 0xEAFFFFFF
MSR CPSR_C, #514                ; 0xE328F202
MOV R0, #0                      ; 0xE3A00000
ADCS R0, R0, #8                 ; 0xE2B00102
CMP R0, #24                     ; 0xE3500106
BNE 5                           ; 0x1A000005
MSR CPSR_C, #514                ; 0xE328F202
MOV R0, #0                      ; 0xE3A00000
ADCS R0, R0, #112               ; 0xE2B00207
CMP R0, #368                    ; 0xE3500217
BNE 0                           ; 0x1A000000
B 16777215                      ; 0xEAFFFFFF
MSR CPSR_C, #0                  ; 0xE328F000
MOV R0, #128                    ; 0xE3A00080
MOVS R0, R0, ROR #8             ; 0xE1B00460
BCC 1                           ; 0x3A000001
BPL 0                           ; 0x5A000000
B 16777215                      ; 0xEAFFFFFF
MSR CPSR_C, #514                ; 0xE328F202
MOV R0, #0                      ; 0xE3A00000
MOV R1, #128                    ; 0xE3A01080
ADCS R0, R0, R1, ROR #8         ; 0xE0B00461
CMP R0, #24                     ; 0xE3500106
BNE 6                           ; 0x1A000006
MSR CPSR_C, #514                ; 0xE328F202
MOV R0, #0                      ; 0xE3A00000
MOV R1, #112                    ; 0xE3A01070
ADCS R0, R0, R1, ROR #8         ; 0xE0B00461
CMP R0, #368                    ; 0xE3500217
BNE 0                           ; 0x1A000000
B 16777215                      ; 0xEAFFFFFF
MSR CPSR_C, #0                  ; 0xE328F000
MOV R0, #128                    ; 0xE3A00080
MOV R1, #8                      ; 0xE3A01008
MOVS R0, R0, ROR R1             ; 0xE1B00170
BCC 1                           ; 0x3A000001
BPL 0                           ; 0x5A000000
B 16777215                      ; 0xEAFFFFFF
MSR CPSR_C, #514                ; 0xE328F202
MOV R0, #0                      ; 0xE3A00000
MOV R1, #128                    ; 0xE3A01080
MOV R2, #8                      ; 0xE3A02008
ADCS R0, R0, R1, ROR R2         ; 0xE0B00271
CMP R0, #24                     ; 0xE3500106
BNE 7                           ; 0x1A000007
MSR CPSR_C, #514                ; 0xE328F202
MOV R0, #0                      ; 0xE3A00000
MOV R1, #112                    ; 0xE3A01070
MOV R2, #8                      ; 0xE3A02008
ADCS R0, R0, R1, ROR R2         ; 0xE0B00271
CMP R0, #368                    ; 0xE3500217
BNE 0                           ; 0x1A000000
B 16777215                      ; 0xEAFFFFFF
MSR CPSR_C, #0                  ; 0xE328F000
TST R0, #8                      ; 0xE3100102
BCC 3                           ; 0x3A000003
MSR CPSR_C, #0                  ; 0xE328F000
TEQ R0, #8                      ; 0xE3300102
BCC 0                           ; 0x3A000000
B 16777215                      ; 0xEAFFFFFF