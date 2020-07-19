; ARM MODE.
code32

processor CPU32_V1
  gcd:
    CMP r0, r1
    BEQ done
    BLT less
    SUB r0, r0, r1
    B gcd
  less:
    SUB r1, r1, r0
    B gcd
  done:
