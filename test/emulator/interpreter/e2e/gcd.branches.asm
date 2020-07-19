; ARM MODE.
code32

processor CPU32_V1
  gcd:
    CMP r0, r1      ; set condition codes based on r0 - r1
    BEQ done        ; if result was 0, goto done (+4), we found the GCD
    BLT less        ; if result was signed != overflow, goto less (+1)
    SUB r0, r0, r1  ; r0 = r0 - r1
    B gcd           ; goto gcd
  less:
    SUB r1, r1, r0  ; r1 = r1 - r0
    B gcd           ; goto gcd
  done:
