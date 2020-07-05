; ARM MODE.
code32

processor CPU32_V1
  add	r0,1
	add	r0,1,2
	add	r0,r1
	add	r0,r1,rrx
	add	r0,r1,lsl 2
	add	r0,r1,lsr 2
	add	r0,r1,asr 2
	add	r0,r1,ror 2
	add	r0,r1,lsl r2
	add	r0,r1,lsr r2
	add	r0,r1,asr r2
	add	r0,r1,ror r2
	add	r0,r1,2
	add	r0,r1,2,4
	add	r0,r1,r2
	add	r0,r1,r2,rrx
	add	r0,r1,r2,lsl 3
	add	r0,r1,r2,lsr 3
	add	r0,r1,r2,asr 3
	add	r0,r1,r2,ror 3
	add	r0,r1,r2,lsl r3
	add	r0,r1,r2,lsr r3
	add	r0,r1,r2,asr r3
	add	r0,r1,r2,ror r3

  cmp	r0,1
	cmp	r0,1,2
	cmp	r0,r1
	cmp	r0,r1,rrx
	cmp	r0,r1,lsl 2
	cmp	r0,r1,lsr 2
	cmp	r0,r1,asr 2
	cmp	r0,r1,ror 2
	cmp	r0,r1,lsl r2
	cmp	r0,r1,lsr r2
	cmp	r0,r1,asr r2
	cmp	r0,r1,ror r2

processor CPU32_26BIT
  cmpp	r0,1
	cmpp	r0,1,2
	cmpp	r0,r1
	cmpp	r0,r1,rrx
	cmpp	r0,r1,lsl 2
	cmpp	r0,r1,lsr 2
	cmpp	r0,r1,asr 2
	cmpp	r0,r1,ror 2
	cmpp	r0,r1,lsl r2
	cmpp	r0,r1,lsr r2
	cmpp	r0,r1,asr r2
	cmpp	r0,r1,ror r2
