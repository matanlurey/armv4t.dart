; ARM MODE.
code32

processor CPU32_V1
  gcd:
    CMP r0, r1
    SUBGT r0, r0, r1
    SUBLT r1, r1, r0
    BNE gcd
