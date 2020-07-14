mov r0, 1                        ;e3a00001
mov r0, 1073741824               ;e3a00101
mov r0, r1                       ;e1a00001
mov r0, r1, rrx                  ;e1a00061
mov r0, r1, lsl 2                ;e1a00101
mov r0, r1, lsr 2                ;e1a00121
mov r0, r1, asr 2                ;e1a00141
mov r0, r1, ror 2                ;e1a00161
mov r0, r1, lsl r2               ;e1a00211
mov r0, r1, lsr r2               ;e1a00231
mov r0, r1, asr r2               ;e1a00251
mov r0, r1, ror r2               ;e1a00271
movs r0, 1                       ;e3b00001
movs r0, 1073741824              ;e3b00101
movs r0, r1                      ;e1b00001
movs r0, r1, rrx                 ;e1b00061
movs r0, r1, lsl 2               ;e1b00101
movs r0, r1, lsr 2               ;e1b00121
movs r0, r1, asr 2               ;e1b00141
movs r0, r1, ror 2               ;e1b00161
movs r0, r1, lsl r2              ;e1b00211
movs r0, r1, lsr r2              ;e1b00231
movs r0, r1, asr r2              ;e1b00251
movs r0, r1, ror r2              ;e1b00271
orr r0, r0, 1                    ;e3800001
orr r0, r0, 1073741824           ;e3800101
orr r0, r0, r1                   ;e1800001
orr r0, r0, r1, rrx              ;e1800061
orr r0, r0, r1, lsl 2            ;e1800101
orr r0, r0, r1, lsr 2            ;e1800121
orr r0, r0, r1, asr 2            ;e1800141
orr r0, r0, r1, ror 2            ;e1800161
orr r0, r0, r1, lsl r2           ;e1800211
orr r0, r0, r1, lsr r2           ;e1800231
orr r0, r0, r1, asr r2           ;e1800251
orr r0, r0, r1, ror r2           ;e1800271
orr r0, r1, 2                    ;e3810002
orr r0, r1, 536870912            ;e3810202
orr r0, r1, r2                   ;e1810002
orr r0, r1, r2, rrx              ;e1810062
orr r0, r1, r2, lsl 3            ;e1810182
orr r0, r1, r2, lsr 3            ;e18101a2
orr r0, r1, r2, asr 3            ;e18101c2
orr r0, r1, r2, ror 3            ;e18101e2
orr r0, r1, r2, lsl r3           ;e1810312
orr r0, r1, r2, lsr r3           ;e1810332
orr r0, r1, r2, asr r3           ;e1810352
orr r0, r1, r2, ror r3           ;e1810372
teq r0, 1                        ;e3300001
teq r0, 1073741824               ;e3300101
teq r0, r1                       ;e1300001
teq r0, r1, rrx                  ;e1300061
teq r0, r1, lsl 2                ;e1300101
teq r0, r1, lsr 2                ;e1300121
teq r0, r1, asr 2                ;e1300141
teq r0, r1, ror 2                ;e1300161
teq r0, r1, lsl r2               ;e1300211
teq r0, r1, lsr r2               ;e1300231
teq r0, r1, asr r2               ;e1300251
teq r0, r1, ror r2               ;e1300271
teqp r0, 1                       ;e330f001
teqp r0, 1073741824              ;e330f101
teqp r0, r1                      ;e130f001
teqp r0, r1, rrx                 ;e130f061
teqp r0, r1, lsl 2               ;e130f101
teqp r0, r1, lsr 2               ;e130f121
teqp r0, r1, asr 2               ;e130f141
teqp r0, r1, ror 2               ;e130f161
teqp r0, r1, lsl r2              ;e130f211
teqp r0, r1, lsr r2              ;e130f231
teqp r0, r1, asr r2              ;e130f251
teqp r0, r1, ror r2              ;e130f271