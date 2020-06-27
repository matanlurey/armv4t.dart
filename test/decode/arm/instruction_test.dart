import 'package:armv4t/src/decode/arm/condition.dart';
import 'package:armv4t/src/decode/arm/format.dart';
import 'package:armv4t/src/decode/arm/instruction.dart';
import 'package:armv4t/src/decode/arm/printer.dart';
import 'package:binary/binary.dart';
import 'package:test/test.dart';

void main() {
  final visitor = ArmDecoder();

  ArmInstruction decode(int bits) {
    final pattern = ArmInstructionSet.allFormats.match(bits);
    final format = ArmInstructionSet.mapDecoders[pattern];
    return format.decodeBits(bits).accept(visitor);
  }

  group('<Condition>', () {});

  group('Data processing or PSR transfer: should decode', () {
    // CCCC_00IP_PPPS_NNNN_DDDD_OOOO_OOOO_OOOO
    int encode(int i, int p, int s, int n, int d, int o) {
      return [
        Condition.AL.index.toBinaryPadded(4),
        '00$i',
        p.toBinaryPadded(4),
        s.toBinaryPadded(1),
        n.toBinaryPadded(4),
        d.toBinaryPadded(4),
        o.toBinaryPadded(12),
      ].join('').parseBits();
    }

    group('<Data processing>', () {
      final opCodes = [
        'AND',
        'EOR',
        'SUB',
        'RSB',
        'ADD',
        'ADC',
        'SBC',
        'RSC',
        'TST',
        'TEQ',
        'CMP',
        'CMN',
        'ORR',
        'MOV',
        'BIC',
        'MVN',
      ];

      for (var opCode = 0; opCode < opCodes.length; opCode++) {
        test('${opCodes[opCode]}', () {
          if (opCodes[opCode] == 'MOV' || opCodes[opCode] == 'MVN') {
            expect(
              decode(encode(0, opCode, 0, 2, 4, 6)),
              _matchesASM('${opCodes[opCode]} R4, R6'),
            );
          } else {
            expect(
              decode(encode(0, opCode, 0, 2, 4, 6)),
              _matchesASM('${opCodes[opCode]} R4, R2, R6'),
            );
          }
        });
      }

      test('AND{S}', () {
        expect(
          decode(encode(0, 0, 1, 2, 4, 6)),
          _matchesASM('ANDS R4, R2, R6'),
        );
      });

      test('AND[I]', () {
        expect(
          decode(encode(1, 0, 0, 2, 4, 6)),
          _matchesASM('AND R4, R2, #6'),
        );
      });
    });

    test('MRS', () {
      // TODO: Test.
    });

    test('MSR', () {
      // TODO: Test.
    });
  });

  group('Multiply: should decode', () {
    // CCCC_0000_00AS_DDDD_NNNN_FFFF_1001_MMMM
    int encode(int a, int s, int d, int n, int f, int m) {
      return [
        Condition.AL.index.toBinaryPadded(4),
        '0000',
        '00$a$s',
        d.toBinaryPadded(4),
        n.toBinaryPadded(4),
        f.toBinaryPadded(4),
        '1001',
        m.toBinaryPadded(4),
      ].join('').parseBits();
    }

    test('MUL', () {
      expect(
        decode(encode(0, 0, 2, 4, 6, 8)),
        _matchesASM('MUL R2, R4, R6'),
      );
    });

    test('MLA', () {
      expect(
        decode(encode(1, 0, 2, 4, 6, 8)),
        _matchesASM('MLA R2, R6, R4, R8'),
      );
    });
  });

  group('Multiply long: should decode', () {
    // CCCC_0000_1UAS_DDDD_FFFF_NNNN_1001_MMMM
    int encode(int u, int a, int s, int d, int f, int n, int m) {
      return [
        Condition.AL.index.toBinaryPadded(4),
        '0000',
        '1$u$a$s',
        d.toBinaryPadded(4),
        f.toBinaryPadded(4),
        n.toBinaryPadded(4),
        '1001',
        m.toBinaryPadded(4),
      ].join('').parseBits();
    }

    test('SMULL', () {
      expect(
        decode(encode(0, 0, 0, 2, 4, 6, 8)),
        _matchesASM('SMULL R4, R2, R6, R8'),
      );
    });

    test('SMLAL', () {
      expect(
        decode(encode(0, 1, 0, 2, 4, 6, 8)),
        _matchesASM('SMLAL R4, R2, R6, R8'),
      );
    });

    test('UMULL', () {
      expect(
        decode(encode(1, 0, 0, 2, 4, 6, 8)),
        _matchesASM('UMULL R4, R2, R6, R8'),
      );
    });

    test('UMLAL', () {
      expect(
        decode(encode(1, 1, 0, 2, 4, 6, 8)),
        _matchesASM('UMLAL R4, R2, R6, R8'),
      );
    });
  });

  group('Single data swap: should decode', () {
    // TODO: Test.
  });

  group('Branch and exchange: should decode', () {
    // CCCC_0001_0010_1111_1111_1111_0001_NNNN
    int encode(int rn) {
      return [
        Condition.AL.index.toBinaryPadded(4),
        '0001',
        '0010',
        '1111',
        '1111',
        '1111',
        '0001',
        rn.toBinaryPadded(4),
      ].join('').parseBits();
    }

    test('BX', () {
      expect(
        decode(encode(4)),
        _matchesASM('BX R4'),
      );
    });
  });

  group('Halfword data transfer register offset: should decode', () {
    // TODO: Test.
  });

  group('Halfword data transfer immediate offset: should decode', () {
    // TODO: Test.
  });

  group('Single data transfer: should decode', () {
    // TODO: Test.
  });

  group('Block data transfer: should decode', () {
    // TODO: Test.
  });

  group('Branch: should decode', () {
    // CCCC_101L_OOOO_OOOO_OOOO_OOOO_OOOO_OOOO
    int encode(int l, int o) {
      return [
        Condition.AL.index.toBinaryPadded(4),
        '101$l',
        o.toBinaryPadded(32 - 8),
      ].join('').parseBits();
    }

    test('B', () {
      expect(
        decode(encode(0, 16)),
        _matchesASM('B 16'),
      );
    });

    test('BL', () {
      expect(
        decode(encode(1, 16)),
        _matchesASM('BL 16'),
      );
    });
  });

  group('Coprocessor data transfer: should decode', () {
    // CCCC_110P_UNWL_MMMM_DDDD_KKKK_OOOO_OOOO
    int encode(int p, int u, int n, int w, int l, int m, int d, int k, int o) {
      return [
        Condition.AL.index.toBinaryPadded(4),
        '110$p',
        '$u$n$w$l',
        m.toBinaryPadded(4),
        d.toBinaryPadded(4),
        k.toBinaryPadded(4),
        o.toBinaryPadded(8),
      ].join('').parseBits();
    }

    test('STC', () {
      expect(
        decode(encode(0, 0, 0, 0, 0, 6, 8, 10, 12)),
        _matchesASM('STC P#10, C8, [R6, #12]'),
      );
    });

    test('LDP', () {
      expect(
        decode(encode(0, 0, 0, 0, 1, 6, 8, 10, 12)),
        _matchesASM('LDP P#10, C8, 12'),
      );
    });
  });

  group('Coprocessor data operation: should decode', () {
    // CCCC_1110_OOOO_NNNN_DDDD_PPPP_VVV0_MMMM
    int encode(int o, int n, int d, int p, int v, int m) {
      return [
        Condition.AL.index.toBinaryPadded(4),
        '1110',
        o.toBinaryPadded(4),
        n.toBinaryPadded(4),
        d.toBinaryPadded(4),
        p.toBinaryPadded(4),
        v.toBinaryPadded(3) + '0',
        m.toBinaryPadded(4),
      ].join('').parseBits();
    }

    test('CDP', () {
      expect(
        decode(encode(8, 16, 6, 8, 4, 6)),
        _matchesASM('CDP P#8, 8, C6, C0, C6, 4'),
      );
    });
  });

  group('Coprocessor register transfer: should decode', () {
    /// CCCC_1110_OOOL_NNNN_DDDD_PPPP_VVV1_MMMM
    int encode(int o, int l, int n, int d, int p, int v, int m) {
      return [
        Condition.AL.index.toBinaryPadded(4),
        '1110',
        o.toBinaryPadded(3) + l.toBinaryPadded(1),
        n.toBinaryPadded(4),
        d.toBinaryPadded(4),
        p.toBinaryPadded(4),
        v.toBinaryPadded(3) + '1',
        m.toBinaryPadded(4),
      ].join('').parseBits();
    }

    test('MCR', () {
      expect(
        decode(encode(8, 0, 4, 6, 8, 10, 12)),
        _matchesASM('MCR P8, 0, R6, C4, C12'),
      );
    });

    test('MRC', () {
      expect(
        decode(encode(8, 1, 4, 6, 8, 10, 12)),
        _matchesASM('MRC P8, 0, R6, C4, C12'),
      );
    });
  });

  group('Software interrupt: should decode', () {
    // TODO: Test.
  });
}

const _printer = ArmInstructionPrinter();

Matcher _matchesASM(String asm) => _ArmAssemblyMatcher(asm);

class _ArmAssemblyMatcher extends Matcher {
  final String _assembly;

  const _ArmAssemblyMatcher(this._assembly);

  @override
  Description describe(Description description) {
    return description.add(_assembly);
  }

  @override
  bool matches(Object describe, Map<Object, Object> matchState) {
    if (describe is ArmInstruction) {
      final matcher = equals(_assembly);
      final result = describe.accept(_printer);
      return matcher.matches(result, matchState);
    } else {
      return false;
    }
  }
}
