MSR CPSR_C, #257                ; 0xE328F101
BEQ 16777215                    ; 0xAFFFFFF
MSR CPSR_C, #0                  ; 0xE328F000
BNE 16777215                    ; 0x1AFFFFFF
MSR CPSR_C, #514                ; 0xE328F202
BCS 16777215                    ; 0x2AFFFFFF
MSR CPSR_C, #0                  ; 0xE328F000
BCC 16777215                    ; 0x3AFFFFFF
MSR CPSR_C, #258                ; 0xE328F102
BMI 16777215                    ; 0x4AFFFFFF
MSR CPSR_C, #0                  ; 0xE328F000
BPL 16777215                    ; 0x5AFFFFFF
MSR CPSR_C, #513                ; 0xE328F201
BVS 16777215                    ; 0x6AFFFFFF
MSR CPSR_C, #0                  ; 0xE328F000
BVC 16777215                    ; 0x7AFFFFFF
MSR CPSR_C, #514                ; 0xE328F202
BHI 16777215                    ; 0x8AFFFFFF
MSR CPSR_C, #257                ; 0xE328F101
BLS 16777215                    ; 0x9AFFFFFF
MSR CPSR_C, #0                  ; 0xE328F000
BGE 16777215                    ; 0xAAFFFFFF
MSR CPSR_C, #521                ; 0xE328F209
BGE 16777215                    ; 0xAAFFFFFF
MSR CPSR_C, #258                ; 0xE328F102
BLT 16777215                    ; 0xBAFFFFFF
MSR CPSR_C, #513                ; 0xE328F201
BLT 16777215                    ; 0xBAFFFFFF
MSR CPSR_C, #0                  ; 0xE328F000
BGT 16777215                    ; 0xCAFFFFFF
MSR CPSR_C, #521                ; 0xE328F209
BGT 16777215                    ; 0xCAFFFFFF
MSR CPSR_C, #257                ; 0xE328F101
BLE 16777215                    ; 0xDAFFFFFF
MSR CPSR_C, #258                ; 0xE328F102
BLE 16777215                    ; 0xDAFFFFFF
MSR CPSR_C, #513                ; 0xE328F201
BLE 16777215                    ; 0xDAFFFFFF
B 16777215                      ; 0xEAFFFFFF