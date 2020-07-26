ldr r0, [r1]                     ;e5910000
ldr r0, [r1], r2                 ;e6910002
ldr r0, [r1], -r2                ;e6110002
ldr r0, [r1], -r2, lsl 3         ;e6110182
ldr r0, [r1], r2, lsr 3          ;e69101a2
ldr r0, [r1], r2, asr 3          ;e69101c2
ldr r0, [r1], r2, ror 3          ;e69101e2
ldr r0, [r1], -r2, lsl 3         ;e6110182
ldr r0, [r1], -r2, lsr 3         ;e61101a2
ldr r0, [r1], -r2, asr 3         ;e61101c2
ldr r0, [r1], -r2, ror 3         ;e61101e2
ldr r0, [r1], r2                 ;e6910062
ldr r0, [r1], -r2                ;e6110062
ldr r0, [r1], 2                  ;e4910002
ldr r0, [r1, 2]                  ;e5910002
ldr r0, [r1, 2]!                 ;e5b10002
ldr r0, [r1, r2]                 ;e7910002
ldr r0, [r1, -r2]                ;e7110002
ldr r0, [r1, r2]!                ;e7b10002
ldr r0, [r1, -r2]!               ;e7310002
ldr r0, [r1, r2, lsl 3]          ;e7910182
ldr r0, [r1, r2, lsr 3]          ;e79101a2
ldr r0, [r1, r2, asr 3]          ;e79101c2
ldr r0, [r1, r2, ror 3]          ;e79101e2
ldr r0, [r1, -r2, lsl 3]         ;e7110182
ldr r0, [r1, -r2, lsr 3]         ;e71101a2
ldr r0, [r1, -r2, asr 3]         ;e71101c2
ldr r0, [r1, -r2, ror 3]         ;e71101e2
ldr r0, [r1, r2, lsl 3]!         ;e7b10182
ldr r0, [r1, r2, lsr 3]!         ;e7b101a2
ldr r0, [r1, r2, asr 3]!         ;e7b101c2
ldr r0, [r1, r2, ror 3]!         ;e7b101e2
ldr r0, [r1, -r2, lsl 3]!        ;e7310182
ldr r0, [r1, -r2, lsr 3]!        ;e73101a2
ldr r0, [r1, -r2, asr 3]!        ;e73101c2
ldr r0, [r1, -r2, ror 3]!        ;e73101e2
ldr r0, [r1, r2]                 ;e7910062
ldr r0, [r1, -r2]                ;e7110062
ldr r0, [r1, r2]!                ;e7b10062
ldr r0, [r1, -r2]!               ;e7310062
ldrb r0, [r1]                    ;e5d10000
ldrb r0, [r1], r2                ;e6d10002
ldrb r0, [r1], -r2               ;e6510002
ldrb r0, [r1], -r2, lsl 3        ;e6510182
ldrb r0, [r1], r2, lsr 3         ;e6d101a2
ldrb r0, [r1], r2, asr 3         ;e6d101c2
ldrb r0, [r1], r2, ror 3         ;e6d101e2
ldrb r0, [r1], -r2, lsl 3        ;e6510182
ldrb r0, [r1], -r2, lsr 3        ;e65101a2
ldrb r0, [r1], -r2, asr 3        ;e65101c2
ldrb r0, [r1], -r2, ror 3        ;e65101e2
ldrb r0, [r1], r2                ;e6d10062
ldrb r0, [r1], -r2               ;e6510062
ldrb r0, [r1], 2                 ;e4d10002
ldrb r0, [r1, 2]                 ;e5d10002
ldrb r0, [r1, 2]!                ;e5f10002
ldrb r0, [r1, r2]                ;e7d10002
ldrb r0, [r1, -r2]               ;e7510002
ldrb r0, [r1, r2]!               ;e7f10002
ldrb r0, [r1, -r2]!              ;e7710002
ldrb r0, [r1, r2, lsl 3]         ;e7d10182
ldrb r0, [r1, r2, lsr 3]         ;e7d101a2
ldrb r0, [r1, r2, asr 3]         ;e7d101c2
ldrb r0, [r1, r2, ror 3]         ;e7d101e2
ldrb r0, [r1, -r2, lsl 3]        ;e7510182
ldrb r0, [r1, -r2, lsr 3]        ;e75101a2
ldrb r0, [r1, -r2, asr 3]        ;e75101c2
ldrb r0, [r1, -r2, ror 3]        ;e75101e2
ldrb r0, [r1, r2, lsl 3]!        ;e7f10182
ldrb r0, [r1, r2, lsr 3]!        ;e7f101a2
ldrb r0, [r1, r2, asr 3]!        ;e7f101c2
ldrb r0, [r1, r2, ror 3]!        ;e7f101e2
ldrb r0, [r1, -r2, lsl 3]!       ;e7710182
ldrb r0, [r1, -r2, lsr 3]!       ;e77101a2
ldrb r0, [r1, -r2, asr 3]!       ;e77101c2
ldrb r0, [r1, -r2, ror 3]!       ;e77101e2
ldrb r0, [r1, r2]                ;e7d10062
ldrb r0, [r1, -r2]               ;e7510062
ldrb r0, [r1, r2]!               ;e7f10062
ldrb r0, [r1, -r2]!              ;e7710062
ldrbt r0, [r1], 0                ;e4f10000
ldrbt r0, [r1], r2               ;e6f10002
ldrbt r0, [r1], -r2              ;e6710002
ldrbt r0, [r1], r2, lsl 3        ;e6f10182
ldrbt r0, [r1], r2, lsr 3        ;e6f101a2
ldrbt r0, [r1], r2, asr 3        ;e6f101c2
ldrbt r0, [r1], r2, ror 3        ;e6f101e2
ldrbt r0, [r1], -r2, lsl 3       ;e6710182
ldrbt r0, [r1], -r2, lsr 3       ;e67101a2
ldrbt r0, [r1], -r2, asr 3       ;e67101c2
ldrbt r0, [r1], -r2, ror 3       ;e67101e2
ldrbt r0, [r1], r2               ;e6f10062
ldrbt r0, [r1], -r2              ;e6710062
ldrbt r0, [r1], 2                ;e4f10002
ldrt r0, [r1], 0                 ;e4b10000
ldrt r0, [r1], r2                ;e6b10002
ldrt r0, [r1], -r2               ;e6310002
ldrt r0, [r1], r2, lsl 3         ;e6b10182
ldrt r0, [r1], r2, lsr 3         ;e6b101a2
ldrt r0, [r1], r2, asr 3         ;e6b101c2
ldrt r0, [r1], r2, ror 3         ;e6b101e2
ldrt r0, [r1], -r2, lsl 3        ;e6310182
ldrt r0, [r1], -r2, lsr 3        ;e63101a2
ldrt r0, [r1], -r2, asr 3        ;e63101c2
ldrt r0, [r1], -r2, ror 3        ;e63101e2
ldrt r0, [r1], r2                ;e6b10062
ldrt r0, [r1], -r2               ;e6310062
ldrt r0, [r1], 2                 ;e4b10002
ldr r1, [r0]                     ;e5901000
ldmia r0, {r1-r2}                ;e8900006
ldmia r0, {r1-r3}                ;e890000e
ldmia r0, {r1-r3, r5}            ;e890002e
ldmia r0, {r1}^                  ;e8d00002
ldmia r0, {r1-r2}^               ;e8d00006
ldmia r0, {r1-r3}^               ;e8d0000e
ldmia r0, {r1-r3, r5}^           ;e8d0002e
ldr r1, [r0], 4                  ;e4901004
ldmia r0!, {r1-r2}               ;e8b00006
ldmia r0!, {r1-r3}               ;e8b0000e
ldmia r0!, {r1-r3, r5}           ;e8b0002e
ldmia r0!, {r15}^                ;e8f08000
ldmia r0!, {r1-r2, r15}^         ;e8f08006
ldmia r0!, {r1-r3, r15}^         ;e8f0800e
ldmia r0!, {r1-r3, r15}^         ;e8f0800e
str r1, [r0]                     ;e5801000
stmia r0, {r1-r2}                ;e8800006
stmia r0, {r1-r3}                ;e880000e
stmia r0, {r1-r3, r5}            ;e880002e
stmia r0, {r1}^                  ;e8c00002
stmia r0, {r1-r2}^               ;e8c00006
stmia r0, {r1-r3}^               ;e8c0000e
stmia r0, {r1-r3, r5}^           ;e8c0002e
str r1, [r0], 4                  ;e4801004
stmia r0!, {r1-r2}               ;e8a00006
stmia r0!, {r1-r3}               ;e8a0000e
stmia r0!, {r1-r3, r5}           ;e8a0002e
str r1, [r0]                     ;e5801000
stmda r0, {r1-r2}                ;e8000006
stmda r0, {r1-r3}                ;e800000e
stmda r0, {r1-r3, r5}            ;e800002e
stmda r0, {r1}^                  ;e8400002
stmda r0, {r1-r2}^               ;e8400006
stmda r0, {r1-r3}^               ;e840000e
stmda r0, {r1-r3, r5}^           ;e840002e
str r1, [r0], -4                 ;e4001004
stmda r0!, {r1-r2}               ;e8200006
stmda r0!, {r1-r3}               ;e820000e
stmda r0!, {r1-r3, r5}           ;e820002e
str r1, [r0, -4]                 ;e5001004
stmdb r0, {r1-r2}                ;e9000006
stmdb r0, {r1-r3}                ;e900000e
stmdb r0, {r1-r3, r5}            ;e900002e
stmdb r0, {r1}^                  ;e9400002
stmdb r0, {r1-r2}^               ;e9400006
stmdb r0, {r1-r3}^               ;e940000e
stmdb r0, {r1-r3, r5}^           ;e940002e
str r1, [r0, -4]!                ;e5201004
stmdb r0!, {r1-r2}               ;e9200006
stmdb r0!, {r1-r3}               ;e920000e
stmdb r0!, {r1-r3, r5}           ;e920002e
str r1, [r0]                     ;e5801000
stmia r0, {r1-r2}                ;e8800006
stmia r0, {r1-r3}                ;e880000e
stmia r0, {r1-r3, r5}            ;e880002e
stmia r0, {r1}^                  ;e8c00002
stmia r0, {r1-r2}^               ;e8c00006
stmia r0, {r1-r3}^               ;e8c0000e
stmia r0, {r1-r3, r5}^           ;e8c0002e
str r1, [r0], 4                  ;e4801004
stmia r0!, {r1-r2}               ;e8a00006
stmia r0!, {r1-r3}               ;e8a0000e
stmia r0!, {r1-r3, r5}           ;e8a0002e
str r1, [r0]                     ;e5801000
stmda r0, {r1-r2}                ;e8000006
stmda r0, {r1-r3}                ;e800000e
stmda r0, {r1-r3, r5}            ;e800002e
stmda r0, {r1}^                  ;e8400002
stmda r0, {r1-r2}^               ;e8400006
stmda r0, {r1-r3}^               ;e840000e
stmda r0, {r1-r3, r5}^           ;e840002e
str r1, [r0], -4                 ;e4001004
stmda r0!, {r1-r2}               ;e8200006
stmda r0!, {r1-r3}               ;e820000e
stmda r0!, {r1-r3, r5}           ;e820002e
str r1, [r0, 4]                  ;e5801004
stmib r0, {r1-r2}                ;e9800006
stmib r0, {r1-r3}                ;e980000e
stmib r0, {r1-r3, r5}            ;e980002e
stmib r0, {r1}^                  ;e9c00002
stmib r0, {r1-r2}^               ;e9c00006
stmib r0, {r1-r3}^               ;e9c0000e
stmib r0, {r1-r3, r5}^           ;e9c0002e
str r1, [r0, 4]!                 ;e5a01004
stmib r0!, {r1-r2}               ;e9a00006
stmib r0!, {r1-r3}               ;e9a0000e
stmib r0!, {r1-r3, r5}           ;e9a0002e
str r1, [r0, -4]                 ;e5001004
stmdb r0, {r1-r2}                ;e9000006
stmdb r0, {r1-r3}                ;e900000e
stmdb r0, {r1-r3, r5}            ;e900002e
stmdb r0, {r1}^                  ;e9400002
stmdb r0, {r1-r2}^               ;e9400006
stmdb r0, {r1-r3}^               ;e940000e
stmdb r0, {r1-r3, r5}^           ;e940002e
str r1, [r0, -4]!                ;e5201004
stmdb r0!, {r1-r2}               ;e9200006
stmdb r0!, {r1-r3}               ;e920000e
stmdb r0!, {r1-r3, r5}           ;e920002e
str r1, [r0]                     ;e5801000
stmia r0, {r1-r2}                ;e8800006
stmia r0, {r1-r3}                ;e880000e
stmia r0, {r1-r3, r5}            ;e880002e
stmia r0, {r1}^                  ;e8c00002
stmia r0, {r1-r2}^               ;e8c00006
stmia r0, {r1-r3}^               ;e8c0000e
stmia r0, {r1-r3, r5}^           ;e8c0002e
str r1, [r0], 4                  ;e4801004
stmia r0!, {r1-r2}               ;e8a00006
stmia r0!, {r1-r3}               ;e8a0000e
stmia r0!, {r1-r3, r5}           ;e8a0002e
str r1, [r0, 4]                  ;e5801004
stmib r0, {r1-r2}                ;e9800006
stmib r0, {r1-r3}                ;e980000e
stmib r0, {r1-r3, r5}            ;e980002e
stmib r0, {r1}^                  ;e9c00002
stmib r0, {r1-r2}^               ;e9c00006
stmib r0, {r1-r3}^               ;e9c0000e
stmib r0, {r1-r3, r5}^           ;e9c0002e
str r1, [r0, 4]!                 ;e5a01004
stmib r0!, {r1-r2}               ;e9a00006
stmib r0!, {r1-r3}               ;e9a0000e
stmib r0!, {r1-r3, r5}           ;e9a0002e
ldrh r0, [r1]                    ;e1d100b0
ldrh r0, [r1], r2                ;e09100b2
ldrh r0, [r1], -r2               ;e01100b2
ldrh r0, [r1], 2                 ;e0d100b2
ldrh r0, [r1, 2]                 ;e1d100b2
ldrh r0, [r1, 2]!                ;e1f100b2
ldrh r0, [r1, r2]                ;e19100b2
ldrh r0, [r1, -r2]               ;e11100b2
ldrh r0, [r1, r2]!               ;e1b100b2
ldrh r0, [r1, -r2]!              ;e13100b2
ldrsb r0, [r1]                   ;e1d100d0
ldrsb r0, [r1], r2               ;e09100d2
ldrsb r0, [r1], -r2              ;e01100d2
ldrsb r0, [r1], 2                ;e0d100d2
ldrsb r0, [r1, 2]                ;e1d100d2
ldrsb r0, [r1, 2]!               ;e1f100d2
ldrsb r0, [r1, r2]               ;e19100d2
ldrsb r0, [r1, -r2]              ;e11100d2
ldrsb r0, [r1, r2]!              ;e1b100d2
ldrsb r0, [r1, -r2]!             ;e13100d2
ldrsh r0, [r1]                   ;e1d100f0
ldrsh r0, [r1], r2               ;e09100f2
ldrsh r0, [r1], -r2              ;e01100f2
ldrsh r0, [r1], 2                ;e0d100f2
ldrsh r0, [r1, 2]                ;e1d100f2
ldrsh r0, [r1, 2]!               ;e1f100f2
ldrsh r0, [r1, r2]               ;e19100f2
ldrsh r0, [r1, -r2]              ;e11100f2
ldrsh r0, [r1, r2]!              ;e1b100f2
ldrsh r0, [r1, -r2]!             ;e13100f2
strh r0, [r1]                    ;e1c100b0
strh r0, [r1], r2                ;e08100b2
strh r0, [r1], -r2               ;e00100b2
strh r0, [r1], 2                 ;e0c100b2
strh r0, [r1, 2]                 ;e1c100b2
strh r0, [r1, 2]!                ;e1e100b2
strh r0, [r1, r2]                ;e18100b2
strh r0, [r1, -r2]               ;e10100b2
strh r0, [r1, r2]!               ;e1a100b2
strh r0, [r1, -r2]!              ;e12100b2
swp r0, r1, [r2]                 ;e1020091
swpb r0, r1, [r2]                ;e1420091