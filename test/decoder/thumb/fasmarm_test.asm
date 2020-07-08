code16

processor CPU32_V4T
  lsl r0, r1, 2   ; -> MOVS Rd, Rs, LSL #Offset5
  lsr r0, r1, 2   ; -> MOVS Rd, Rs, LSR #Offset5
  asr r0, r1, 2   ; -> MOVS Rd, Rs, ASR #Offset5
  swi 1           ; -> SWI 1

  add r0, r1, r2  ; -> ADDS Rd, Rs, Rn
  add r0, r1, 2   ; -> ADDS Rd, Rs, #Offset3
  sub r0, r1, r2  ; -> SUBS Rd, Rs, Rn
  sub r0, r1, 2   ; -> SUBS Rd, Rs, #Offset3
  swi 2           ; -> SWI 2

  mov r0, 1       ; -> MOVS Rd, #Offset8
  cmp r0, 1       ; -> CMP  "
  add r0, 1       ; -> ADDS Rd, Rd, #Offset8
  sub r0, 1       ; -> SUBS Rd, Rd, #Offset8
  swi 3           ; -> SWI 3

  and r0, r1      ; -> ANDS Rd, Rd, Rs
  eor r0, r1      ; -> EORS Rd, Rd, Rs
  lsl r0, r1      ; -> MOVS Rd, Rd, LSL Rs
  lsr r0, r1      ; -> MOVS Rd, Rd, LSR Rs
  asr r0, r1      ; -> MOVS Rd, Rd, ASR Rs
  adc r0, r1      ; -> ADCS Rd, Rd, Rs
  sbc r0, r1      ; -> SBCS Rd, Rd, Rs
  ror r0, r1      ; -> MOVS Rd, Rd, ROR Rs
  tst r0, r1      ; -> TST  Rd, Rs
  neg r0, r1      ; -> RSBS Rd, Rs, #0
  cmp r0, r1      ; -> CMP  Rd, Rs
  cmn r0, r1      ; -> CMN  Rd, Rs
  orr r0, r1      ; -> ORRS Rd, Rd, Rs
  mul r0, r1      ; -> MULS Rd, Rd, Rs
  bic r0, r1      ; -> BICS Rd, Rd, Rs
  mvn r0, r1      ; -> MVNS Rd, Rs
  swi 4           ; -> SWI 4

  add r0, r8      ; -> ADD  Rd, Rd, Hs
  add r8, r0      ; -> ADD  Hd, Hd, Rs
  add r8, r9      ; -> ADD  Hd, Hd, Hs
  cmp r0, r8      ; -> ADD  Rd, Hs
  cmp r8, r0      ; -> ADD  Hd, Rs
  cmp r8, r9      ; -> ADD  Hd, Hs
  mov r0, r8      ; -> MOV  Rd, Hs
  mov r8, r0      ; -> MOV  Hd, Rs
  mov r8, r9      ; -> MOV  Hd, Hs
  bx r0           ; -> BX Rs
  bx r8           ; -> BX Hs
  swi 5           ; -> SWI 5
