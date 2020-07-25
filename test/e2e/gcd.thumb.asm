; ARM MODE (Entrypoint)
processor CPU32_V1
  code32
    MOV r2, gcd - 1
processor CPU32_V4T
    BX r2

; THUMB MODE.
processor CPU32_V4T
  code16
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
