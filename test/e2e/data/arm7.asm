; expected results:
;
; 0x1fc (508) = 1
; 0x200 (512) = 1
; 0x204 (516) = 0x200

mov r13, #0x200       ; r13      = 512

mov r0, #1            ; r0       = 1

stmed r13, {r0, r13}  ; starting @512 store memory
                      ; ed == da == decrement after
                      ;
                      ; @512     = r0  = 1
                      ; @508     = r13 = 512

swp r1, r0, [r13]     ; load r1 with word associated at r13
                      ; store r0 at r13
                      ;
                      ; r1       = [r13]
                      ; r1       = @512
                      ; r1       = 512
                      ;
                      ; [r13]    = r0
                      ; @512     = r0
                      ; @512     = 1

str r1, [r13, #4]     ; @r13 + 4 = r1
                      ; @512 + 4 = r1
                      ; @516     = r1
                      ; @516     = 512
