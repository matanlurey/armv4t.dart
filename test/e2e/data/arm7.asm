; expected result: 0x1fc = 1, 0x200 = 1, 0x204 = 0x200

mov r13, #0x200       ; r13 = 512

mov r0, #1            ; r00 = 1

stmed r13, {r0, r13}  ; starting @512 store memory
                      ; ed == da == decrement after
                      ;
                      ; @512   = 1
                      ; @508   = 512
                      ;
                      ; ... then writeback (implicit)
                      ; r13    = 508

swp r1, r0, [r13]     ; load r1 with word associated at r13
                      ; store r0 at r13
                      ;
                      ; r1     = [r13] (r1   = #508)
                      ; [r13]  = r0    (@508 = #1)

str r1, [r13, #4]     ; @r13 + 4 = 
                      ; #508 + 4 = 512
                      ;
                      ; store @512 #512
