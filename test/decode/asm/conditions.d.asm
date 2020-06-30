msr cpsr_c, 257                 ; 0xE328F101
beq 16777215                    ; 0xAFFFFFF
msr cpsr_c, 0                   ; 0xE328F000
bne 16777215                    ; 0x1AFFFFFF
msr cpsr_c, 514                 ; 0xE328F202
bcs 16777215                    ; 0x2AFFFFFF
msr cpsr_c, 0                   ; 0xE328F000
bcc 16777215                    ; 0x3AFFFFFF
msr cpsr_c, 258                 ; 0xE328F102
bmi 16777215                    ; 0x4AFFFFFF
msr cpsr_c, 0                   ; 0xE328F000
bpl 16777215                    ; 0x5AFFFFFF
msr cpsr_c, 513                 ; 0xE328F201
bvs 16777215                    ; 0x6AFFFFFF
msr cpsr_c, 0                   ; 0xE328F000
bvc 16777215                    ; 0x7AFFFFFF
msr cpsr_c, 514                 ; 0xE328F202
bhi 16777215                    ; 0x8AFFFFFF
msr cpsr_c, 257                 ; 0xE328F101
bls 16777215                    ; 0x9AFFFFFF
msr cpsr_c, 0                   ; 0xE328F000
bge 16777215                    ; 0xAAFFFFFF
msr cpsr_c, 521                 ; 0xE328F209
bge 16777215                    ; 0xAAFFFFFF
msr cpsr_c, 258                 ; 0xE328F102
blt 16777215                    ; 0xBAFFFFFF
msr cpsr_c, 513                 ; 0xE328F201
blt 16777215                    ; 0xBAFFFFFF
msr cpsr_c, 0                   ; 0xE328F000
bgt 16777215                    ; 0xCAFFFFFF
msr cpsr_c, 521                 ; 0xE328F209
bgt 16777215                    ; 0xCAFFFFFF
msr cpsr_c, 257                 ; 0xE328F101
ble 16777215                    ; 0xDAFFFFFF
msr cpsr_c, 258                 ; 0xE328F102
ble 16777215                    ; 0xDAFFFFFF
msr cpsr_c, 513                 ; 0xE328F201
ble 16777215                    ; 0xDAFFFFFF
b 16777215                      ; 0xEAFFFFFF