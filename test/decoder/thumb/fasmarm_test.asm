code16

processor CPU32_V4T
  lsl r0, r1, 2   ; -> MOVS Rd, Rs, LSL #Offset5
  lsr r0, r1, 2   ; -> MOVS Rd, Rs, LSR #Offset5
  asr r0, r1, 2   ; -> MOVS Rd, Rs, ASR #Offset5

  add r0, r1, r2  ; -> ADDS Rd, Rs, Rn
  add r0, r1, 2   ; -> ADDS Rd, Rs, #Offset3
  sub r0, r1, r2  ; -> SUBS Rd, Rs, Rn
  sub r0, r1, 2   ; -> SUBS Rd, Rs, #Offset3

  mov r0, 1       ; -> MOVS Rd, #Offset8
  cmp r0, 1       ; -> CMP  "
  add r0, 1       ; -> ADDS Rd, Rd, #Offset8
  sub r0, 1       ; -> SUBS Rd, Rd, #Offset8

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

processor CPU32_7M
  ldr r0, [PC, 1] ; -> LDR Rd, [R15, #Imm]

  str  r0, [r1, r2] ; -> STR  Rd, [Rb, Ro]
  strb r0, [r1, r2] ; -> STRB Rd, [Rb, Ro]
  ldr  r0, [r1, r2] ; -> LDR  Rd, [Rb, Ro]
  ldrb r0, [r1, r2] ; -> LDRB Rd, [Rb, Ro]

  strh r0, [r1, r2] ; -> STRH  Rd, [Rb, Ro]
  ldrh r0, [r1, r2] ; -> LDRH  Rd, [Rb, Ro]
  ;TODO: Figure out what is needed to compile these.
  ;ldsb r0, [r1, r2] ; -> LDRSB Rd, [Rb, Ro]
  ;ldsh r0, [r1, r2] ; -> LDRSH Rd, [Rb, Ro]

  str  r0, [r1, 2]  ; -> STR  Rd, [Rb, #Imm]
  ldr  r0, [r1, 2]  ; -> LDR  Rd, [Rb, #Imm]
  strb r0, [r1, 2]  ; -> STRB Rd, [Rb, #Imm]
  ldrb r0, [r1, 2]  ; -> LDRB Rd, [Rb, #Imm]

  strh r0, [r1, 2]  ; -> STRH Rd, [Rb, #Imm]
  ;TODO: Figure out what is needed to compile these.
  ;lrdh r0, [r1, 2]  ; -> LDRH Rd, [Rb, #Imm]

  str  r0, [sp, 1]  ; -> STR  Rd, [R13, #Imm]
  ldr  r0, [sp, 1]  ; -> LDR  Rd, [R13, #Imm]

  add r0, pc, 1     ; -> ADD  Rd, R15, #Imm
  add r0, sp, 1     ; -> ADD  Rd, R13, #Imm

  add sp, 1         ; -> ADD  R13, R13, #Imm
  add sp, -1        ; -> ADD  R13, R13, #Imm

  push {r0, r1-r2}  ; -> STMDB R13!, { Rlist }
  push {r0, lr}     ; -> STMBD R13!, { Rlist, R14 }
  pop  {r0, r1-r2}  ; -> LDMIA R13!, { Rlist }
  pop  {r0, pc}     ; -> LDMIA R13!, { Rlist, R15 }

  stmia r0!, {r1}   ; -> STMIA Rb!, { Rlist }
  ldmia r0!, {r1}   ; -> LDMIA Rb!, { Rlist }

  beq 84
  bne 84
  bcs 84
  bcc 84
  bmi 84
  bpl 84
  bvs 84
  bvc 84
  bhi 84
  bls 84
  bge 84
  blt 84
  bgt 84
  ble 84

processor CPU32_V4T
  swi 1

  b 84
