; ARM MODE.
code32

processor CPU32_V1
  gcd:
    CMP r0, r1      ; 0x00 | set condition codes based on r0 - r1
    BEQ done        ; 0x40 | if result was 0, goto done (0x30), we found the GCD
    BLT less        ; 0x08 | if result was - or + overflow, goto less (0x20)
    SUB r0, r0, r1  ; 0x12 | r0 = r0 - r1
    B gcd           ; 0x16 | goto gcd (0x0)
  less:
    SUB r1, r1, r0  ; 0x20 | r1 = r1 - r0
    B gcd           ; 0x24 | goto gcd (0x0)
  done:
                    ; 0x30
