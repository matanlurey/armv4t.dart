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
      matchesASM('mrs r4, spsr'),
    );
  });

  test('MRS (CPSR -> Register', () {
    expect(
      decode(build(0, 0x8, 2, 4, 6)),
      matchesASM('mrs r4, cpsr'),
    );
  });

  test('MSR (Register -> SPSR)', () {
    expect(
      decode(build(0, 0xB, 0, 0, 6)),
      matchesASM('msr spsr, r6'),
    );
  });

  test('MSR (Register -> CPSR)', () {
    expect(
      decode(build(0, 0x9, 0, 0, 6)),
      matchesASM('msr cpsr, r6'),
    );
  });

  test('MSR (Immediate -> SPSR Flags)', () {
    expect(
      decode(build(1, 0xB, 0, 0, 6)),
      matchesASM('msr spsr, 6'),
    );
  });

  test('MSR (Immediate -> CPSR Flags)', () {
    expect(
      decode(build(1, 0x9, 0, 0, 6)),
      matchesASM('msr cpsr, 6'),
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
        decode(build(0, _OpCode.TST.index, 1, 2, 0, 6)),
        matchesASM('tst r2, r6'),
      );
    });

    test('TEQ', () {
      expect(
        decode(build(0, _OpCode.TEQ.index, 1, 2, 0, 6)),
        matchesASM('teq r2, r6'),
      );
    });

    test('CMP', () {
      expect(
        decode(build(0, _OpCode.CMP.index, 1, 2, 0, 6)),
        matchesASM('cmp r2, r6'),
      );
    });

    test('CMN', () {
      expect(
        decode(build(0, _OpCode.CMN.index, 1, 2, 0, 6)),
        matchesASM('cmn r2, r6'),
      );
    });
  });

  group('[S = 0]', () {
    test('AND', () {
      expect(
        decode(build(0, _OpCode.AND.index, 0, 2, 4, 6)),
        matchesASM('and r4, r2, r6'),
      );
    });

    test('EOR', () {
      expect(
        decode(build(0, _OpCode.EOR.index, 0, 2, 4, 6)),
        matchesASM('eor r4, r2, r6'),
      );
    });

    test('SUB', () {
      expect(
        decode(build(0, _OpCode.SUB.index, 0, 2, 4, 6)),
        matchesASM('sub r4, r2, r6'),
      );
    });

    test('RSB', () {
      expect(
        decode(build(0, _OpCode.RSB.index, 0, 2, 4, 6)),
        matchesASM('rsb r4, r2, r6'),
      );
    });

    test('ADD', () {
      expect(
        decode(build(0, _OpCode.ADD.index, 0, 2, 4, 6)),
        matchesASM('add r4, r2, r6'),
      );
    });

    test('ADC', () {
      expect(
        decode(build(0, _OpCode.ADC.index, 0, 2, 4, 6)),
        matchesASM('adc r4, r2, r6'),
      );
    });

    test('SBC', () {
      expect(
        decode(build(0, _OpCode.SBC.index, 0, 2, 4, 6)),
        matchesASM('sbc r4, r2, r6'),
      );
    });

    test('RSC', () {
      expect(
        decode(build(0, _OpCode.RSC.index, 0, 2, 4, 6)),
        matchesASM('rsc r4, r2, r6'),
      );
    });

    test('ORR', () {
      expect(
        decode(build(0, _OpCode.ORR.index, 0, 2, 4, 6)),
        matchesASM('orr r4, r2, r6'),
      );
    });

    test('MOV', () {
      expect(
        decode(build(0, _OpCode.MOV.index, 0, 2, 4, 6)),
        matchesASM('mov r4, r6'),
      );
    });

    test('BIC', () {
      expect(
        decode(build(0, _OpCode.BIC.index, 0, 2, 4, 6)),
        matchesASM('bic r4, r2, r6'),
      );
    });

    test('MVN', () {
      expect(
        decode(build(0, _OpCode.MVN.index, 0, 2, 4, 6)),
        matchesASM('mvn r4, r6'),
      );
    });
  });

  group('[S = 1]', () {
    test('ANDS', () {
      expect(
        decode(build(0, _OpCode.AND.index, 1, 2, 4, 6)),
        matchesASM('ands r4, r2, r6'),
      );
    });

    test('EORS', () {
      expect(
        decode(build(0, _OpCode.EOR.index, 1, 2, 4, 6)),
        matchesASM('eors r4, r2, r6'),
      );
    });

    test('SUBS', () {
      expect(
        decode(build(0, _OpCode.SUB.index, 1, 2, 4, 6)),
        matchesASM('subs r4, r2, r6'),
      );
    });

    test('RSBS', () {
      expect(
        decode(build(0, _OpCode.RSB.index, 1, 2, 4, 6)),
        matchesASM('rsbs r4, r2, r6'),
      );
    });

    test('ADDS', () {
      expect(
        decode(build(0, _OpCode.ADD.index, 1, 2, 4, 6)),
        matchesASM('adds r4, r2, r6'),
      );
    });

    test('ADCS', () {
      expect(
        decode(build(0, _OpCode.ADC.index, 1, 2, 4, 6)),
        matchesASM('adcs r4, r2, r6'),
      );
    });

    test('SBCS', () {
      expect(
        decode(build(0, _OpCode.SBC.index, 1, 2, 4, 6)),
        matchesASM('sbcs r4, r2, r6'),
      );
    });

    test('RSCS', () {
      expect(
        decode(build(0, _OpCode.RSC.index, 1, 2, 4, 6)),
        matchesASM('rscs r4, r2, r6'),
      );
    });

    test('ORRS', () {
      expect(
        decode(build(0, _OpCode.ORR.index, 1, 2, 4, 6)),
        matchesASM('orrs r4, r2, r6'),
      );
    });

    test('MOVS', () {
      expect(
        decode(build(0, _OpCode.MOV.index, 1, 2, 4, 6)),
        matchesASM('movs r4, r6'),
      );
    });

    test('BICS', () {
      expect(
        decode(build(0, _OpCode.BIC.index, 1, 2, 4, 6)),
        matchesASM('bics r4, r2, r6'),
      );
    });

    test('MVN', () {
      expect(
        decode(build(0, _OpCode.MVN.index, 1, 2, 4, 6)),
        matchesASM('mvns r4, r6'),
      );
    });
  });

  // See ../operand_test.dart for an exhaustive test suite.
  group('[I = 1]', () {
    test('AND', () {
      expect(
        decode(build(1, _OpCode.AND.index, 0, 2, 4, 6)),
        matchesASM('and r4, r2, 6'),
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
      matchesASM('swp r2, r4, [r6]'),
    );
  });

  test('SWPB', () {
    expect(
      decode(build(1, 2, 4, 6)),
      matchesASM('swpb r2, r4, [r6]'),
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
      matchesASM('ldrh r4, [r2], -6'),
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
      matchesASM('strh r4, [r2], -6'),
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
      matchesASM('ldrsb r4, [r2], -6'),
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
      matchesASM('ldrsh r4, [r2], -6'),
    );
  });
}

void _testHalfwordDataTransferImmediateOffset() {
  // CCCC_000P_U1WL_NNNN_DDDD_OOOO_1SH1_KKKK
  // ignore: unused_element
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
      matchesASM('str r4, [r2], -6'),
    );
  });

  test('STRB', () {
    expect(
      decode(build(0, 0, 0, 1, 0, 0, 2, 4, 6)),
      matchesASM('strb r4, [r2], -6'),
    );
  });

  test('LDR', () {
    expect(
      decode(build(0, 0, 0, 0, 0, 1, 2, 4, 6)),
      matchesASM('ldr r4, [r2], -6'),
    );
  });

  test('LDRB', () {
    expect(
      decode(build(0, 0, 0, 1, 0, 1, 2, 4, 6)),
      matchesASM('ldrb r4, [r2], -6'),
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
          matchesASM('str r2, [r4, -122]'),
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
          matchesASM('str r2, [r4, -r10]'),
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
          matchesASM('str r2, [r4, -r10, lsl r12]'),
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
          matchesASM('str r2, [r4, -122]!'),
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
          matchesASM('str r2, [r4, -r10]!'),
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
          matchesASM('str r2, [r4, -r10, lsl r12]!'),
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
          matchesASM('str r2, [r4], -122'),
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
          matchesASM('str r2, [r4], -r10'),
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
          matchesASM('str r2, [r4], -r10, lsl r12'),
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
        matchesASM('ldmib r4, {r7}'),
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
        matchesASM('ldmia r4, {r7}'),
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
        matchesASM('ldmdb r4, {r7}'),
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
        matchesASM('ldmda r4, {r7}'),
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
        matchesASM('ldmda r4!, {r7}^'),
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
      matchesASM('stmib r4, {r7}'),
    );
  });
}
