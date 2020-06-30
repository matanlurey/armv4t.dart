MOV R12, #50                    ; 0xE3A0C032
ADD R0, R15, #1                 ; 0xE28F0001
BX R0                           ; 0xE12FFF10
???? <UnimplementedError>       ; 0x46842033
STRMI R10, [R0, -R0]            ; 0x4700A000
MOV R12, #52                    ; 0xE3A0C034
ADD R0, R15, #0                 ; 0xE28F0000
BX R0                           ; 0xE12FFF10
MOV R12, #53                    ; 0xE3A0C035
B 1                             ; 0xEA000001
MOV R12, #55                    ; 0xE3A0C037
B 3                             ; 0xEA000003
MOV R12, #54                    ; 0xE3A0C036
B 16777211                      ; 0xEAFFFFFB
MOV R12, #57                    ; 0xE3A0C039
MOV R15, R14                    ; 0xE1A0F00E
MOV R12, #56                    ; 0xE3A0C038
BL 16777211                     ; 0xEBFFFFFB
MOV R12, #0                     ; 0xE3A0C000