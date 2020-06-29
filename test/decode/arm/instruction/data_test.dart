import 'package:armv4t/src/decode/arm/printer.dart';
import 'package:binary/binary.dart';
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
        const ArmInstructionPrinter(),
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
