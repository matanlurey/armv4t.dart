movs r0, r1, lsl 2               ;0x0088
movs r0, r1, lsr 2               ;0x0888
movs r0, r1, asr 2               ;0x1088
swi 1                            ;0xdf01

adds r0, r1, r2                  ;0x1888
adds r0, r1, 2                   ;0x1c88
subs r0, r1, r2                  ;0x1a88
subs r0, r1, 2                   ;0x1e88
swi 2                            ;0xdf02

movs r0, 1                       ;0x2001
cmp r0, 1                        ;0x2801
adds r0, r0, 1                   ;0x3001
subs r0, r0, 1                   ;0x3801
swi 3                            ;0xdf03

ands r0, r0, r1                  ;0x4008
eors r0, r0, r1                  ;0x4048
movs r0, r0, lsl r1              ;0x4088
movs r0, r0, lsr r1              ;0x40c8
movs r0, r0, asr r1              ;0x4108
adcs r0, r0, r1                  ;0x4148
sbcs r0, r0, r1                  ;0x4188
movs r0, r0, ror r1              ;0x41c8
tst r0, r1                       ;0x4208
rsbs r0, r0, 0                   ;0x4248
cmp r0, r1                       ;0x4288
cmn r0, r1                       ;0x42c8
orrs r0, r0, r1                  ;0x4308
muls r0, r1, r0                  ;0x4348
bics r0, r0, r1                  ;0x4388
mvns r0, r0, asr r1              ;0x43c8
swi 4                            ;0xdf04

add r0, r0, r8                   ;0x4440
add r8, r8, r0                   ;0x4480
add r8, r8, r9                   ;0x44c8
cmp r0, r8                       ;0x4540
cmp r8, r0                       ;0x4580
cmp r8, r9                       ;0x45c8
mov r0, r8                       ;0x4640
mov r8, r0                       ;0x4680
mov r8, r9                       ;0x46c8
bx r0                            ;0x4700
bx r8                            ;0x4740
swi 5                            ;0xdf05
