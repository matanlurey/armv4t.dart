import 'package:armv4t/src/decode/arm/printer.dart';
import 'package:binary/binary.dart';
import 'package:meta/meta.dart';
import 'package:test/test.dart';

import '_common.dart';

enum _OpCode {
  AND,
  EOR,
  SUB,
  RSB,
  ADD,
  ADC,
  SBC,
  RSC,
  TST,
  TEQ,
  CMP,
  CMN,
  ORR,
  MOV,
  BIC,
  MVN,
}

void main() {
  _testCPSRorSPSR();
  _testLogicAndMath();
  _testSingleDataSwap();
  _testHalfwordDataTransferRegisterOffset();
  _testHalfwordDataTransferImmediateOffset();
  _testSingleDataTransfer();
  _testBlockDataTransfer();
}

void _testCPSRorSPSR() {
  // CCCC_00IP_PPPS_NNNN_DDDD_OOOO_OOOO_OOOO
  int build(int i, int p, int n, int d, int o) {
    return encode([
      '00$i',
      p.toBinaryPadded(4),
      '0',
      n.toBinaryPadded(4),
      d.toBinaryPadded(4),
      o.toBinaryPadded(12),
    ]);
  }

  test('MRS (SPSR -> Register)', () {
    expect(
      decode(build(0, 0xA, 2, 4, 6)),
      matchesASM('MRS R4, SPSR'),
    );
  });

  test('MRS (CPSR -> Register', () {
    expect(
      decode(build(0, 0x8, 2, 4, 6)),
      matchesASM('MRS R4, CPSR'),
    );
  });

  test('MSR (Register -> SPSR)', () {
    expect(
      decode(build(0, 0xB, 0, 0, 6)),
      matchesASM('MSR SPSR, R6'),
    );
  });

  test('MSR (Register -> CPSR)', () {
    expect(
      decode(build(0, 0x9, 0, 0, 6)),
      matchesASM('MSR CPSR, R6'),
    );
  });

  test('MSR (Immediate -> SPSR Flags)', () {
    expect(
      decode(build(1, 0xB, 0, 0, 6)),
      matchesASM('MSR SPSR, #6'),
    );
  });

  test('MSR (Immediate -> CPSR Flags)', () {
    expect(
      decode(build(1, 0x9, 0, 0, 6)),
      matchesASM('MSR CPSR, #6'),
    );
  });

  test('MSR: <Field Masks>', () {
    final results = <String>[];
    for (int i = 0; i < 16; i++) {
      results.add(decode(build(1, 0x9, i, 0, 6)).accept(
        ArmInstructionPrinter(),
      ));
    }
    expect(results.toSet(), hasLength(16));
    expect(results.toSet(), results, reason: 'Expected all unique masks');
  });
}

void _testLogicAndMath() {
  // CCCC_00IP_PPPS_NNNN_DDDD_OOOO_OOOO_OOOO
  int build(int i, int p, int s, int n, int d, int o) {
    return encode([
      '00$i',
      p.toBinaryPadded(4),
      s.toBinaryPadded(1),
      n.toBinaryPadded(4),
      d.toBinaryPadded(4),
      o.toBinaryPadded(12),
    ]);
  }

  group('[S = 1]', () {
    test('TST', () {
      expect(
        decode(build(1, _OpCode.TST.index, 1, 2, 4, 6)),
        matchesASM('TST R4, R2, R6'),
      );
    });

    test('TEQ', () {
      expect(
        decode(build(1, _OpCode.TEQ.index, 1, 2, 4, 6)),
        matchesASM('TEQ R4, R2, R6'),
      );
    });

    test('CMP', () {
      expect(
        decode(build(1, _OpCode.CMP.index, 1, 2, 4, 6)),
        matchesASM('CMP R4, R2, R6'),
      );
    });

    test('CMN', () {
      expect(
        decode(build(1, _OpCode.CMN.index, 1, 2, 4, 6)),
        matchesASM('CMN R4, R2, R6'),
      );
    });
  });

  group('[S = 0]', () {
    test('AND', () {
      expect(
        decode(build(1, _OpCode.AND.index, 0, 2, 4, 6)),
        matchesASM('AND R4, R2, R6'),
      );
    });

    test('EOR', () {
      expect(
        decode(build(1, _OpCode.EOR.index, 0, 2, 4, 6)),
        matchesASM('EOR R4, R2, R6'),
      );
    });

    test('SUB', () {
      expect(
        decode(build(1, _OpCode.SUB.index, 0, 2, 4, 6)),
        matchesASM('SUB R4, R2, R6'),
      );
    });

    test('RSB', () {
      expect(
        decode(build(1, _OpCode.RSB.index, 0, 2, 4, 6)),
        matchesASM('RSB R4, R2, R6'),
      );
    });

    test('ADD', () {
      expect(
        decode(build(1, _OpCode.ADD.index, 0, 2, 4, 6)),
        matchesASM('ADD R4, R2, R6'),
      );
    });

    test('ADC', () {
      expect(
        decode(build(1, _OpCode.ADC.index, 0, 2, 4, 6)),
        matchesASM('ADC R4, R2, R6'),
      );
    });

    test('SBC', () {
      expect(
        decode(build(1, _OpCode.SBC.index, 0, 2, 4, 6)),
        matchesASM('SBC R4, R2, R6'),
      );
    });

    test('RSC', () {
      expect(
        decode(build(1, _OpCode.RSC.index, 0, 2, 4, 6)),
        matchesASM('RSC R4, R2, R6'),
      );
    });

    test('ORR', () {
      expect(
        decode(build(1, _OpCode.ORR.index, 0, 2, 4, 6)),
        matchesASM('ORR R4, R2, R6'),
      );
    });

    test('MOV', () {
      expect(
        decode(build(1, _OpCode.MOV.index, 0, 2, 4, 6)),
        matchesASM('MOV R4, R6'),
      );
    });

    test('BIC', () {
      expect(
        decode(build(1, _OpCode.BIC.index, 0, 2, 4, 6)),
        matchesASM('BIC R4, R2, R6'),
      );
    });

    test('MVN', () {
      expect(
        decode(build(1, _OpCode.MVN.index, 0, 2, 4, 6)),
        matchesASM('MVN R4, R6'),
      );
    });
  });

  group('[S = 1]', () {
    test('ANDS', () {
      expect(
        decode(build(1, _OpCode.AND.index, 1, 2, 4, 6)),
        matchesASM('ANDS R4, R2, R6'),
      );
    });

    test('EORS', () {
      expect(
        decode(build(1, _OpCode.EOR.index, 1, 2, 4, 6)),
        matchesASM('EORS R4, R2, R6'),
      );
    });

    test('SUBS', () {
      expect(
        decode(build(1, _OpCode.SUB.index, 1, 2, 4, 6)),
        matchesASM('SUBS R4, R2, R6'),
      );
    });

    test('RSBS', () {
      expect(
        decode(build(1, _OpCode.RSB.index, 1, 2, 4, 6)),
        matchesASM('RSBS R4, R2, R6'),
      );
    });

    test('ADDS', () {
      expect(
        decode(build(1, _OpCode.ADD.index, 1, 2, 4, 6)),
        matchesASM('ADDS R4, R2, R6'),
      );
    });

    test('ADCS', () {
      expect(
        decode(build(1, _OpCode.ADC.index, 1, 2, 4, 6)),
        matchesASM('ADCS R4, R2, R6'),
      );
    });

    test('SBCS', () {
      expect(
        decode(build(1, _OpCode.SBC.index, 1, 2, 4, 6)),
        matchesASM('SBCS R4, R2, R6'),
      );
    });

    test('RSCS', () {
      expect(
        decode(build(1, _OpCode.RSC.index, 1, 2, 4, 6)),
        matchesASM('RSCS R4, R2, R6'),
      );
    });

    test('ORRS', () {
      expect(
        decode(build(1, _OpCode.ORR.index, 1, 2, 4, 6)),
        matchesASM('ORRS R4, R2, R6'),
      );
    });

    test('MOVS', () {
      expect(
        decode(build(1, _OpCode.MOV.index, 1, 2, 4, 6)),
        matchesASM('MOVS R4, R6'),
      );
    });

    test('BICS', () {
      expect(
        decode(build(1, _OpCode.BIC.index, 1, 2, 4, 6)),
        matchesASM('BICS R4, R2, R6'),
      );
    });

    test('MVN', () {
      expect(
        decode(build(1, _OpCode.MVN.index, 1, 2, 4, 6)),
        matchesASM('MVNS R4, R6'),
      );
    });
  });

  // See ../operand_test.dart for an exhaustive test suite.
  group('[I = 0]', () {
    test('AND', () {
      expect(
        decode(build(0, _OpCode.AND.index, 0, 2, 4, 6)),
        matchesASM('AND R4, R2, R6, LSL #0'),
      );
    });
  });
}

void _testSingleDataSwap() {
  // CCCC_0001_0B00_NNNN_DDDD_0000_1001_MMMM
  int build(int b, int n, int d, int m) {
    return encode([
      '0001',
      '0${b}00',
      n.toBinaryPadded(4),
      d.toBinaryPadded(4),
      '0000',
      '1001',
      m.toBinaryPadded(4),
    ]);
  }

  test('SWP', () {
    expect(
      decode(build(0, 2, 4, 6)),
      matchesASM('SWP R2, R4, [R6]'),
    );
  });

  test('SWPB', () {
    expect(
      decode(build(1, 2, 4, 6)),
      matchesASM('SWPB R2, R4, [R6]'),
    );
  });
}

void _testHalfwordDataTransferRegisterOffset() {
  // CCCC_000P_U0WL_NNNN_DDDD_0000_1SH1_MMMM
  int build({
    int p = 0,
    int u = 0,
    int w = 0,
    int l = 0,
    @required int n,
    @required int d,
    int s = 0,
    int h = 0,
    @required int m,
  }) {
    return encode([
      '000$p',
      '${u}0$w$l',
      n.toBinaryPadded(4),
      d.toBinaryPadded(4),
      '0000',
      '1$s${h}1',
      m.toBinaryPadded(4),
    ]);
  }

  test('LDRH', () {
    // LDR{cond}H Rd, <a_mode3>
    expect(
      decode(build(
        n: 2,
        d: 4,
        l: 1,
        m: 6,
        s: 0,
        h: 1,
      )),
      matchesASM('LDRH R4, [R2], #-6'),
    );
  });

  test('STRH', () {
    // STR{cond}H Rd, <a_mode3>
    expect(
      decode(build(
        n: 2,
        d: 4,
        l: 0,
        m: 6,
        s: 0,
        h: 1,
      )),
      matchesASM('STRH R4, [R2], #-6'),
    );
  });

  test('LDRSB', () {
    // LDR{cond}SB Rd, <a_mode3>
    expect(
      decode(build(
        n: 2,
        d: 4,
        l: 1,
        m: 6,
        s: 1,
        h: 0,
      )),
      matchesASM('LDRSB R4, [R2], #-6'),
    );
  });

  test('LDRSH', () {
    // LDR{cond}SH Rd, <a_mode3>
    expect(
      decode(build(
        n: 2,
        d: 4,
        l: 1,
        m: 6,
        s: 1,
        h: 1,
      )),
      matchesASM('LDRSH R4, [R2], #-6'),
    );
  });
}

void _testHalfwordDataTransferImmediateOffset() {
  // CCCC_000P_U1WL_NNNN_DDDD_OOOO_1SH1_KKKK
  int build({
    int p = 0,
    int u = 0,
    int w = 0,
    int l = 0,
    @required int n,
    @required int d,
    @required int offsetHigh,
    int s = 0,
    int h = 0,
    @required int offsetLow,
  }) {
    return encode([
      '000$p',
      '${u}1$w$l',
      n.toBinaryPadded(4),
      d.toBinaryPadded(4),
      offsetHigh.toBinaryPadded(4),
      '1$s${h}1',
      offsetLow.toBinaryPadded(4),
    ]);
  }
}

void _testSingleDataTransfer() {
  // CCCC_01IP_UBWL_NNNN_DDDD_OOOO_OOOO_OOOO
  int build(int i, int p, int u, int b, int w, int l, int n, int d, int o) {
    return encode([
      '01$i$p',
      '$u$b$w$l',
      n.toBinaryPadded(4),
      d.toBinaryPadded(4),
      o.toBinaryPadded(12),
    ]);
  }

  test('STR', () {
    expect(
      decode(build(0, 0, 0, 0, 0, 0, 2, 4, 6)),
      matchesASM('STR R4, [R2], -R6, LSL #0'),
    );
  });

  test('STRB', () {
    expect(
      decode(build(0, 0, 0, 1, 0, 0, 2, 4, 6)),
      matchesASM('STRB R4, [R2], -R6, LSL #0'),
    );
  });

  test('LDR', () {
    expect(
      decode(build(0, 0, 0, 0, 0, 1, 2, 4, 6)),
      matchesASM('LDR R4, [R2], -R6, LSL #0'),
    );
  });

  test('LDRB', () {
    expect(
      decode(build(0, 0, 0, 1, 0, 1, 2, 4, 6)),
      matchesASM('LDRB R4, [R2], -R6, LSL #0'),
    );
  });

  group('STR <Addressing Mode 2>', () {
    int build2({
      int i = 0,
      int p = 0,
      int u = 0,
      int b = 0,
      int w = 0,
      int l = 0,
      @required int rN,
      @required int rD,
      @required int offset,
    }) =>
        build(
          i,
          p,
          u,
          b,
          w,
          l,
          rN,
          rD,
          offset,
        );

    group('<Immdiate Offset>', () {
      test('', () {
        // [Rn, #+/-12bit_Offset]
        expect(
          decode(build2(
            // Pre-index.
            p: 1,
            // No write-back.
            w: 0,
            // Immediate value.
            i: 0,
            // Other elements.
            rD: 2,
            rN: 4,
            // Stored as an 8-bit value with a leading 4-bit rotation code.
            // RRRR_IIII_IIII
            offset: ('0000' '0111' '1010').parseBits(),
          )),
          matchesASM('STR R2, [R4, -#122]'),
        );
      });

      test('Register offset', () {
        // [Rn, +/-Rm]
        expect(
          decode(build2(
            // Pre-index.
            p: 1,
            // No write-back.
            w: 0,
            // Register value.
            i: 1,
            // Other elements.
            rD: 2,
            rN: 4,
            // Stored as an 8-bit value with a leading 4-bit rotation code.
            // RRRR_IIII_IIII
            offset: ('0000' '0000' '1010').parseBits(),
          )),
          matchesASM('STR R2, [R4, -R10]'),
        );
      });

      test('Scaled register offset', () {
        // [Rn, +/-Rm, LSL #5bit_shift_imm] or [Rn, +/-Rm, RRX]
        expect(
          decode(build2(
            // Pre-index.
            p: 1,
            // No write-back.
            w: 0,
            // Register value.
            i: 1,
            // Other elements.
            rD: 2,
            rN: 4,
            // Stored as an 8-bit value with a leading 4-bit rotation code.
            // RRRR_IIII_IIII
            offset: ('1100' '0000' '1010').parseBits(),
          )),
          matchesASM('STR R2, [R4, -R10, LSL R12]'),
        );
      });
    });

    group('Pre-indexed offset', () {
      test('Immediate', () {
        // [Rn, #+/-12bit_Offset]!
        expect(
          decode(build2(
            // Pre-index.
            p: 1,
            // Write-back.
            w: 1,
            // Immediate value.
            i: 0,
            // Other elements.
            rD: 2,
            rN: 4,
            // Stored as an 8-bit value with a leading 4-bit rotation code.
            // RRRR_IIII_IIII
            offset: ('0000' '0111' '1010').parseBits(),
          )),
          matchesASM('STR R2, [R4, -#122]!'),
        );
      });

      test('Register', () {
        // [Rn, +/-Rm]!
        expect(
          decode(build2(
            // Pre-index.
            p: 1,
            // Write-back.
            w: 1,
            // Register value.
            i: 1,
            // Other elements.
            rD: 2,
            rN: 4,
            // Stored as an 8-bit value with a leading 4-bit rotation code.
            // RRRR_IIII_IIII
            offset: ('0000' '0000' '1010').parseBits(),
          )),
          matchesASM('STR R2, [R4, -R10]!'),
        );
      });

      test('Scaled register', () {
        // [Rn, +/-Rm, LSL #5bit_shift_imm] or [Rn, +/-Rm, RRX]!
        expect(
          decode(build2(
            // Pre-index.
            p: 1,
            // Write-back.
            w: 1,
            // Register value.
            i: 1,
            // Other elements.
            rD: 2,
            rN: 4,
            // Stored as an 8-bit value with a leading 4-bit rotation code.
            // RRRR_IIII_IIII
            offset: ('1100' '0000' '1010').parseBits(),
          )),
          matchesASM('STR R2, [R4, -R10, LSL R12]!'),
        );
      });
    });

    group('Post-indexed offset', () {
      test('Immediate', () {
        // [Rn], #+/-12bit_Offset
        expect(
          decode(build2(
            // Post-index.
            p: 0,
            // Immediate value.
            i: 0,
            // Other elements.
            rD: 2,
            rN: 4,
            // Stored as an 8-bit value with a leading 4-bit rotation code.
            // RRRR_IIII_IIII
            offset: ('0000' '0111' '1010').parseBits(),
          )),
          matchesASM('STR R2, [R4], -#122'),
        );
      });

      test('Register', () {
        // [Rn], +/-Rm
        expect(
          decode(build2(
            // Post-index.
            p: 0,
            // Register value.
            i: 1,
            // Other elements.
            rD: 2,
            rN: 4,
            // Stored as an 8-bit value with a leading 4-bit rotation code.
            // RRRR_IIII_IIII
            offset: ('0000' '0000' '1010').parseBits(),
          )),
          matchesASM('STR R2, [R4], -R10'),
        );
      });

      test('Scaled register', () {
        // [Rn], +/-Rm, LSL #5bit_shift_imm or [Rn, +/-Rm, RRX].
        expect(
          decode(build2(
            // Post-index.
            p: 0,
            // Register value.
            i: 1,
            // Other elements.
            rD: 2,
            rN: 4,
            // Stored as an 8-bit value with a leading 4-bit rotation code.
            // RRRR_IIII_IIII
            offset: ('1100' '0000' '1010').parseBits(),
          )),
          matchesASM('STR R2, [R4], -R10, LSL R12'),
        );
      });
    });
  });
}

void _testBlockDataTransfer() {
  const increment = 1;
  const decrement = 0;
  const after = 0;
  const before = 1;

  // CCCC_100P_USWL_NNNN_RRRR_RRRR_RRRR_RRRR
  int build({
    int p = 0,
    int u = 0,
    int s = 0,
    int w = 0,
    int l = 0,
    @required int n,
    @required int r,
  }) {
    return encode([
      '100$p',
      '$u$s$w$l',
      n.toBinaryPadded(4),
      r.toBinaryPadded(16),
    ]);
  }

  group('LDM', () {
    test('IB (Increment Before)', () {
      expect(
        decode(build(
          // Increment.
          u: increment,

          // Before.
          p: before,

          // Register.
          n: 4,

          // Register list.
          r: '1000' '0000'.parseBits(),
        )),
        matchesASM('LDMIB R4, {R7}'),
      );
    });

    test('IA (Increment After)', () {
      expect(
        decode(build(
          // Increment.
          u: increment,

          // After.
          p: after,

          // Register.
          n: 4,

          // Register list.
          r: '1000' '0000'.parseBits(),
        )),
        matchesASM('LDMIA R4, {R7}'),
      );
    });

    test('DB (Decrement Before)', () {
      expect(
        decode(build(
          // Decrement.
          u: decrement,

          // Before.
          p: before,

          // Register.
          n: 4,

          // Register list.
          r: '1000' '0000'.parseBits(),
        )),
        matchesASM('LDMDB R4, {R7}'),
      );
    });

    test('DA (Decrement After)', () {
      expect(
        decode(build(
          // Decrement.
          u: decrement,

          // After.
          p: after,

          // Register.
          n: 4,

          // Register list.
          r: '1000' '0000'.parseBits(),
        )),
        matchesASM('LDMDA R4, {R7}'),
      );
    });

    test('... with user registers', () {
      // LDM{cond}<a_mode4L> Rd{!}, <reglist>^
      expect(
        decode(build(
          // Register.
          n: 4,

          // Save SPSR.
          s: 1,

          // Write-back.
          w: 1,

          // Register list.
          r: '1000' '0000'.parseBits(),
        )),
        matchesASM('LDMDA R4!, {R7}^'),
      );
    });
  });

  test('STM', () {
    expect(
      decode(build(
        // Increment.
        u: increment,

        // Before.
        p: before,

        // Store
        l: 1,

        // Register.
        n: 4,

        // Register list.
        r: '1000' '0000'.parseBits(),
      )),
      matchesASM('STMIB R4, {R7}'),
    );
  });
}
