b 254                            ;ea0000fe
bl 253                           ;eb0000fd
swi 1024                         ;ef000400
bx r0                            ;e12fff10
msr cpsr, r0                     ;e10f0000
msr cpsr, r0                     ;e10f0000
mrs r0, cpsr                     ;e14f0000
msr spsr, r1                     ;e129f001
msr spsr, r1                     ;e12ff001
msr spsr, 1                      ;e329f001
msr spsr, 1                      ;e32ff001