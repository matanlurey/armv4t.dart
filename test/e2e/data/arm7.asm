; expected result: 0x1fc = 1, 0x200 = 1, 0x204 = 0x200

mov r13, #0x200       ; r13 = 512

mov r0, #1            ; r00 = 1
stmed r13, {r0, r13}  ; starting @512 store memory
                      ; ed == da == decrement after
swp r1, r0, [r13]
str r1, [r13, #4]
