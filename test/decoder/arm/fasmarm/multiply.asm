; ARM MODE.
code32

processor CPU32_V2
	mul	r0,r1
	mul	r0,r1,r2
  mla	r0,r1,r2,r3

processor CPU32_M
  smlal	r0,r1,r2,r3
	smull	r0,r1,r2,r3
	umlal	r0,r1,r2,r3
	umull	r0,r1,r2,r3
