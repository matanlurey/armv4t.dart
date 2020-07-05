; ARM MODE.
code32

processor CPU32_V1
	mov	r0,1
	mov	r0,1,2
	mov	r0,r1
	mov	r0,r1,rrx
	mov	r0,r1,lsl 2
	mov	r0,r1,lsr 2
	mov	r0,r1,asr 2
	mov	r0,r1,ror 2
	mov	r0,r1,lsl r2
	mov	r0,r1,lsr r2
	mov	r0,r1,asr r2
	mov	r0,r1,ror r2

  movs r0,1
	movs r0,1,2
	movs r0,r1
	movs r0,r1,rrx
	movs r0,r1,lsl 2
	movs r0,r1,lsr 2
	movs r0,r1,asr 2
	movs r0,r1,ror 2
	movs r0,r1,lsl r2
	movs r0,r1,lsr r2
	movs r0,r1,asr r2
	movs r0,r1,ror r2

  orr	r0,1
	orr	r0,1,2
	orr	r0,r1
	orr	r0,r1,rrx
	orr	r0,r1,lsl 2
	orr	r0,r1,lsr 2
	orr	r0,r1,asr 2
	orr	r0,r1,ror 2
	orr	r0,r1,lsl r2
	orr	r0,r1,lsr r2
	orr	r0,r1,asr r2
	orr	r0,r1,ror r2
	orr	r0,r1,2
	orr	r0,r1,2,4
	orr	r0,r1,r2
	orr	r0,r1,r2,rrx
	orr	r0,r1,r2,lsl 3
	orr	r0,r1,r2,lsr 3
	orr	r0,r1,r2,asr 3
	orr	r0,r1,r2,ror 3
	orr	r0,r1,r2,lsl r3
	orr	r0,r1,r2,lsr r3
	orr	r0,r1,r2,asr r3
	orr	r0,r1,r2,ror r3

  teq	r0,1
	teq	r0,1,2
	teq	r0,r1
	teq	r0,r1,rrx
	teq	r0,r1,lsl 2
	teq	r0,r1,lsr 2
	teq	r0,r1,asr 2
	teq	r0,r1,ror 2
	teq	r0,r1,lsl r2
	teq	r0,r1,lsr r2
	teq	r0,r1,asr r2
	teq	r0,r1,ror r2

processor CPU32_26BIT
  teqp	r0,1
	teqp	r0,1,2
	teqp	r0,r1
	teqp	r0,r1,rrx
	teqp	r0,r1,lsl 2
	teqp	r0,r1,lsr 2
	teqp	r0,r1,asr 2
	teqp	r0,r1,ror 2
	teqp	r0,r1,lsl r2
	teqp	r0,r1,lsr r2
	teqp	r0,r1,asr r2
	teqp	r0,r1,ror r2
