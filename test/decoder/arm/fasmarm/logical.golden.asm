add r0, r0, 1                    ;e2800001
add r0, r0, 1073741824           ;e2800101
add r0, r0, r1                   ;e0800001
add r0, r0, r1, rrx              ;e0800061
add r0, r0, r1, lsl 2            ;e0800101
add r0, r0, r1, lsr 2            ;e0800121
add r0, r0, r1, asr 2            ;e0800141
add r0, r0, r1, ror 2            ;e0800161
add r0, r0, r1, lsl r2           ;e0800211
add r0, r0, r1, lsr r2           ;e0800231
add r0, r0, r1, asr r2           ;e0800251
add r0, r0, r1, ror r2           ;e0800271
add r0, r1, 2                    ;e2810002
add r0, r1, 536870912            ;e2810202
add r0, r1, r2                   ;e0810002
add r0, r1, r2, rrx              ;e0810062
add r0, r1, r2, lsl 3            ;e0810182
add r0, r1, r2, lsr 3            ;e08101a2
add r0, r1, r2, asr 3            ;e08101c2
add r0, r1, r2, ror 3            ;e08101e2
add r0, r1, r2, lsl r3           ;e0810312
add r0, r1, r2, lsr r3           ;e0810332
add r0, r1, r2, asr r3           ;e0810352
add r0, r1, r2, ror r3           ;e0810372
cmp r0, 1                        ;e3500001
cmp r0, 1073741824               ;e3500101
cmp r0, r1                       ;e1500001
cmp r0, r1, rrx                  ;e1500061
cmp r0, r1, lsl 2                ;e1500101
cmp r0, r1, lsr 2                ;e1500121
cmp r0, r1, asr 2                ;e1500141
cmp r0, r1, ror 2                ;e1500161
cmp r0, r1, lsl r2               ;e1500211
cmp r0, r1, lsr r2               ;e1500231
cmp r0, r1, asr r2               ;e1500251
cmp r0, r1, ror r2               ;e1500271
cmpp r0, 1                       ;e350f001
cmpp r0, 1073741824              ;e350f101
cmpp r0, r1                      ;e150f001
cmpp r0, r1, rrx                 ;e150f061
cmpp r0, r1, lsl 2               ;e150f101
cmpp r0, r1, lsr 2               ;e150f121
cmpp r0, r1, asr 2               ;e150f141
cmpp r0, r1, ror 2               ;e150f161
cmpp r0, r1, lsl r2              ;e150f211
cmpp r0, r1, lsr r2              ;e150f231
cmpp r0, r1, asr r2              ;e150f251
cmpp r0, r1, ror r2              ;e150f271