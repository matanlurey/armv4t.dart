; ARM MODE.
code32

processor CPU32_V1
  b   1024
  bl  1024

  swi 1024

processor CPU32_V4T
	bx	r0

processor CPU32_V3
	mrs	r0,apsr
	mrs	r0,cpsr
	mrs	r0,spsr

	msr	cpsr,r1
	msr	cpsr_fsxc,r1
	msr	cpsr,1
	msr	cpsr_fsxc,1
