; ARM MODE.
code32

processor CPU32_V1
	ldr	r0,[r1]
	ldr	r0,[r1],+r2
	ldr	r0,[r1],-r2
	ldr	r0,[r1],-r2,lsl 3
	ldr	r0,[r1],r2,lsr 3
	ldr	r0,[r1],r2,asr 3
	ldr	r0,[r1],r2,ror 3
	ldr	r0,[r1],-r2,lsl 3
	ldr	r0,[r1],-r2,lsr 3
	ldr	r0,[r1],-r2,asr 3
	ldr	r0,[r1],-r2,ror 3
	ldr	r0,[r1],r2,rrx
	ldr	r0,[r1],-r2,rrx
	ldr	r0,[r1],2
	ldr	r0,[r1,2]
	ldr	r0,[r1,2]!
	ldr	r0,[r1,r2]
	ldr	r0,[r1,-r2]
	ldr	r0,[r1,r2]!
	ldr	r0,[r1,-r2]!
	ldr	r0,[r1,r2,lsl 3]
	ldr	r0,[r1,r2,lsr 3]
	ldr	r0,[r1,r2,asr 3]
	ldr	r0,[r1,r2,ror 3]
	ldr	r0,[r1,-r2,lsl 3]
	ldr	r0,[r1,-r2,lsr 3]
	ldr	r0,[r1,-r2,asr 3]
	ldr	r0,[r1,-r2,ror 3]
	ldr	r0,[r1,r2,lsl 3]!
	ldr	r0,[r1,r2,lsr 3]!
	ldr	r0,[r1,r2,asr 3]!
	ldr	r0,[r1,r2,ror 3]!
	ldr	r0,[r1,-r2,lsl 3]!
	ldr	r0,[r1,-r2,lsr 3]!
	ldr	r0,[r1,-r2,asr 3]!
	ldr	r0,[r1,-r2,ror 3]!
	ldr	r0,[r1,r2,rrx]
	ldr	r0,[r1,-r2,rrx]
	ldr	r0,[r1,r2,rrx]!
	ldr	r0,[r1,-r2,rrx]!

  ldrb	r0,[r1]
	ldrb	r0,[r1],r2
	ldrb	r0,[r1],-r2
	ldrb	r0,[r1],-r2,lsl 3
	ldrb	r0,[r1],r2,lsr 3
	ldrb	r0,[r1],r2,asr 3
	ldrb	r0,[r1],r2,ror 3
	ldrb	r0,[r1],-r2,lsl 3
	ldrb	r0,[r1],-r2,lsr 3
	ldrb	r0,[r1],-r2,asr 3
	ldrb	r0,[r1],-r2,ror 3
	ldrb	r0,[r1],r2,rrx
	ldrb	r0,[r1],-r2,rrx
	ldrb	r0,[r1],2
	ldrb	r0,[r1,2]
	ldrb	r0,[r1,2]!
	ldrb	r0,[r1,r2]
	ldrb	r0,[r1,-r2]
	ldrb	r0,[r1,r2]!
	ldrb	r0,[r1,-r2]!
	ldrb	r0,[r1,r2,lsl 3]
	ldrb	r0,[r1,r2,lsr 3]
	ldrb	r0,[r1,r2,asr 3]
	ldrb	r0,[r1,r2,ror 3]
	ldrb	r0,[r1,-r2,lsl 3]
	ldrb	r0,[r1,-r2,lsr 3]
	ldrb	r0,[r1,-r2,asr 3]
	ldrb	r0,[r1,-r2,ror 3]
	ldrb	r0,[r1,r2,lsl 3]!
	ldrb	r0,[r1,r2,lsr 3]!
	ldrb	r0,[r1,r2,asr 3]!
	ldrb	r0,[r1,r2,ror 3]!
	ldrb	r0,[r1,-r2,lsl 3]!
	ldrb	r0,[r1,-r2,lsr 3]!
	ldrb	r0,[r1,-r2,asr 3]!
	ldrb	r0,[r1,-r2,ror 3]!
	ldrb	r0,[r1,r2,rrx]
	ldrb	r0,[r1,-r2,rrx]
	ldrb	r0,[r1,r2,rrx]!
	ldrb	r0,[r1,-r2,rrx]!

  ldrbt	r0,[r1]
	ldrbt	r0,[r1],r2
	ldrbt	r0,[r1],-r2
	ldrbt	r0,[r1],r2,lsl 3
	ldrbt	r0,[r1],r2,lsr 3
	ldrbt	r0,[r1],r2,asr 3
	ldrbt	r0,[r1],r2,ror 3
	ldrbt	r0,[r1],-r2,lsl 3
	ldrbt	r0,[r1],-r2,lsr 3
	ldrbt	r0,[r1],-r2,asr 3
	ldrbt	r0,[r1],-r2,ror 3
	ldrbt	r0,[r1],r2,rrx
	ldrbt	r0,[r1],-r2,rrx
	ldrbt	r0,[r1],2

  ldrt	r0,[r1]
	ldrt	r0,[r1],r2
	ldrt	r0,[r1],-r2
	ldrt	r0,[r1],r2,lsl 3
	ldrt	r0,[r1],r2,lsr 3
	ldrt	r0,[r1],r2,asr 3
	ldrt	r0,[r1],r2,ror 3
	ldrt	r0,[r1],-r2,lsl 3
	ldrt	r0,[r1],-r2,lsr 3
	ldrt	r0,[r1],-r2,asr 3
	ldrt	r0,[r1],-r2,ror 3
	ldrt	r0,[r1],r2,rrx
	ldrt	r0,[r1],-r2,rrx
	ldrt	r0,[r1],2

  ldm	r0,{r1}
	ldm	r0,{r1,r2}
	ldm	r0,{r1-r3}
	ldm	r0,{r1-r3,r5}
	ldm	r0,{r1}^
	ldm	r0,{r1,r2}^
	ldm	r0,{r1-r3}^
	ldm	r0,{r1-r3,r5}^
	ldm	r0!,{r1}
	ldm	r0!,{r1,r2}
	ldm	r0!,{r1-r3}
	ldm	r0!,{r1-r3,r5}
	ldm	r0!,{r15}^
	ldm	r0!,{r1,r2,r15}^
	ldm	r0!,{r1-r3,r15}^
	ldm	r0!,{r1-r3,r15}^

stm	r0,{r1}
	stm	r0,{r1,r2}
	stm	r0,{r1-r3}
	stm	r0,{r1-r3,r5}
	stm	r0,{r1}^
	stm	r0,{r1,r2}^
	stm	r0,{r1-r3}^
	stm	r0,{r1-r3,r5}^
	stm	r0!,{r1}
	stm	r0!,{r1,r2}
	stm	r0!,{r1-r3}
	stm	r0!,{r1-r3,r5}

	stmda	r0,{r1}
	stmda	r0,{r1,r2}
	stmda	r0,{r1-r3}
	stmda	r0,{r1-r3,r5}
	stmda	r0,{r1}^
	stmda	r0,{r1,r2}^
	stmda	r0,{r1-r3}^
	stmda	r0,{r1-r3,r5}^
	stmda	r0!,{r1}
	stmda	r0!,{r1,r2}
	stmda	r0!,{r1-r3}
	stmda	r0!,{r1-r3,r5}

	stmdb	r0,{r1}
	stmdb	r0,{r1,r2}
	stmdb	r0,{r1-r3}
	stmdb	r0,{r1-r3,r5}
	stmdb	r0,{r1}^
	stmdb	r0,{r1,r2}^
	stmdb	r0,{r1-r3}^
	stmdb	r0,{r1-r3,r5}^
	stmdb	r0!,{r1}
	stmdb	r0!,{r1,r2}
	stmdb	r0!,{r1-r3}
	stmdb	r0!,{r1-r3,r5}

	stmea	r0,{r1}
	stmea	r0,{r1,r2}
	stmea	r0,{r1-r3}
	stmea	r0,{r1-r3,r5}
	stmea	r0,{r1}^
	stmea	r0,{r1,r2}^
	stmea	r0,{r1-r3}^
	stmea	r0,{r1-r3,r5}^
	stmea	r0!,{r1}
	stmea	r0!,{r1,r2}
	stmea	r0!,{r1-r3}
	stmea	r0!,{r1-r3,r5}

	stmed	r0,{r1}
	stmed	r0,{r1,r2}
	stmed	r0,{r1-r3}
	stmed	r0,{r1-r3,r5}
	stmed	r0,{r1}^
	stmed	r0,{r1,r2}^
	stmed	r0,{r1-r3}^
	stmed	r0,{r1-r3,r5}^
	stmed	r0!,{r1}
	stmed	r0!,{r1,r2}
	stmed	r0!,{r1-r3}
	stmed	r0!,{r1-r3,r5}

	stmfa	r0,{r1}
	stmfa	r0,{r1,r2}
	stmfa	r0,{r1-r3}
	stmfa	r0,{r1-r3,r5}
	stmfa	r0,{r1}^
	stmfa	r0,{r1,r2}^
	stmfa	r0,{r1-r3}^
	stmfa	r0,{r1-r3,r5}^
	stmfa	r0!,{r1}
	stmfa	r0!,{r1,r2}
	stmfa	r0!,{r1-r3}
	stmfa	r0!,{r1-r3,r5}

	stmfd	r0,{r1}
	stmfd	r0,{r1,r2}
	stmfd	r0,{r1-r3}
	stmfd	r0,{r1-r3,r5}
	stmfd	r0,{r1}^
	stmfd	r0,{r1,r2}^
	stmfd	r0,{r1-r3}^
	stmfd	r0,{r1-r3,r5}^
	stmfd	r0!,{r1}
	stmfd	r0!,{r1,r2}
	stmfd	r0!,{r1-r3}
	stmfd	r0!,{r1-r3,r5}

	stmia	r0,{r1}
	stmia	r0,{r1,r2}
	stmia	r0,{r1-r3}
	stmia	r0,{r1-r3,r5}
	stmia	r0,{r1}^
	stmia	r0,{r1,r2}^
	stmia	r0,{r1-r3}^
	stmia	r0,{r1-r3,r5}^
	stmia	r0!,{r1}
	stmia	r0!,{r1,r2}
	stmia	r0!,{r1-r3}
	stmia	r0!,{r1-r3,r5}

	stmib	r0,{r1}
	stmib	r0,{r1,r2}
	stmib	r0,{r1-r3}
	stmib	r0,{r1-r3,r5}
	stmib	r0,{r1}^
	stmib	r0,{r1,r2}^
	stmib	r0,{r1-r3}^
	stmib	r0,{r1-r3,r5}^
	stmib	r0!,{r1}
	stmib	r0!,{r1,r2}
	stmib	r0!,{r1-r3}
	stmib	r0!,{r1-r3,r5}

processor CPU32_V4
  ldrh	r0,[r1]
	ldrh	r0,[r1],r2
	ldrh	r0,[r1],-r2
	ldrh	r0,[r1],2
	ldrh	r0,[r1,2]
	ldrh	r0,[r1,2]!
	ldrh	r0,[r1,r2]
	ldrh	r0,[r1,-r2]
	ldrh	r0,[r1,r2]!
	ldrh	r0,[r1,-r2]!

  ldrsb	r0,[r1]
	ldrsb	r0,[r1],r2
	ldrsb	r0,[r1],-r2
	ldrsb	r0,[r1],2
	ldrsb	r0,[r1,2]
	ldrsb	r0,[r1,2]!
	ldrsb	r0,[r1,r2]
	ldrsb	r0,[r1,-r2]
	ldrsb	r0,[r1,r2]!
	ldrsb	r0,[r1,-r2]!

  ldrsh	r0,[r1]
	ldrsh	r0,[r1],r2
	ldrsh	r0,[r1],-r2
	ldrsh	r0,[r1],2
	ldrsh	r0,[r1,2]
	ldrsh	r0,[r1,2]!
	ldrsh	r0,[r1,r2]
	ldrsh	r0,[r1,-r2]
	ldrsh	r0,[r1,r2]!
	ldrsh	r0,[r1,-r2]!

  strh	r0,[r1]
	strh	r0,[r1],r2
	strh	r0,[r1],-r2
	strh	r0,[r1],2
	strh	r0,[r1,2]
	strh	r0,[r1,2]!
	strh	r0,[r1,r2]
	strh	r0,[r1,-r2]
	strh	r0,[r1,r2]!
	strh	r0,[r1,-r2]!

processor CPU32_A
  swp	r0,r1,[r2]
	swpb	r0,r1,[r2]
