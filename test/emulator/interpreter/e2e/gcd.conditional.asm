; ARM MODE.
code32

processor CPU32_V1
  gcd:
    CMP r0, r1          ; set condition codes based on r0 - r1
    SUBGT r0, r0, r1    ; if not zero and signed == overflow, r0 = r0 - 1
    SUBLT r1, r1, r0    ; if signed != overflow, r1 = r1 - r0
    BNE gcd             ; if not zero, goto gcd
