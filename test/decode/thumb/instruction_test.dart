import 'package:armv4t/src/decode/thumb/format.dart';
import 'package:armv4t/src/decode/thumb/instruction.dart';
import 'package:armv4t/src/decode/thumb/printer.dart';
import 'package:binary/binary.dart';
import 'package:test/test.dart';

void main() {
  final visitor = ThumbDecoder();

  ThumbInstruction decode(int bits) {
    final pattern = ThumbInstructionSet.allFormats.match(bits);
    final format = ThumbInstructionSet.mapDecoders[pattern];
    return format.decodeBits(bits).accept(visitor);
  }

  group('Move Shifted Register: should decode', () {
    int encode(int op, int offset5, int rs, int rd) {
      return [
        0x0.toBinaryPadded(3),
        op.toBinaryPadded(3),
        offset5.toBinaryPadded(5),
        rs.toBinaryPadded(3),
        rd.toBinaryPadded(3)
      ].join('').parseBits();
    }

    test('LSL', () {
      expect(
        decode(encode(0, 10, 2, 4)),
        _matchesASM('LSL R4, R2, #10'),
      );
    });

    test('LSR', () {
      expect(
        decode(encode(1, 10, 2, 4)),
        _matchesASM('LSR R4, R2, #10'),
      );
    });

    test('ASR', () {
      expect(
        decode(encode(2, 10, 2, 4)),
        _matchesASM('ASR R4, R2, #10'),
      );
    });
  });

  group('Add or Subtract: should decode', () {
    int encode(int i, int op, int rnOrOffset3, int rs, int rd) {
      return [
        '00011',
        i.toBinaryPadded(1),
        op.toBinaryPadded(1),
        rnOrOffset3.toBinaryPadded(3),
        rs.toBinaryPadded(3),
        rd.toBinaryPadded(3),
      ].join('').parseBits();
    }

    test('ADD (Rn)', () {
      expect(
        decode(encode(0, 0, 2, 4, 6)),
        _matchesASM('ADD R6, R4, R2'),
      );
    });

    test('ADD (#Offset3)', () {
      expect(
        decode(encode(1, 0, 2, 4, 6)),
        _matchesASM('ADD R6, R4, #2'),
      );
    });

    test('SUB (Rn)', () {
      expect(
        decode(encode(0, 1, 2, 4, 6)),
        _matchesASM('SUB R6, R4, R2'),
      );
    });

    test('SUB (#Offset3)', () {
      expect(
        decode(encode(1, 1, 2, 4, 6)),
        _matchesASM('SUB R6, R4, #2'),
      );
    });
  });

  group('Move or Compare or Add or Subtract [Immediate]: should decode', () {
    int encode(int op, int rd, int offset8) {
      return [
        '001',
        op.toBinaryPadded(2),
        rd.toBinaryPadded(3),
        offset8.toBinaryPadded(8),
      ].join('').parseBits();
    }

    test('MOV', () {
      expect(
        decode(encode(0, 2, 16)),
        _matchesASM('MOV R2, #16'),
      );
    });

    test('CMP', () {
      expect(
        decode(encode(1, 2, 16)),
        _matchesASM('CMP R2, #16'),
      );
    });

    test('ADD', () {
      expect(
        decode(encode(2, 2, 16)),
        _matchesASM('ADD R2, #16'),
      );
    });

    test('SUB', () {
      expect(
        decode(encode(3, 2, 16)),
        _matchesASM('SUB R2, #16'),
      );
    });
  });

  group('ALU Operations: should decode', () {
    int encode(int op, int rs, int rd) {
      return [
        '010000',
        op.toBinaryPadded(4),
        rs.toBinaryPadded(3),
        rd.toBinaryPadded(3),
      ].join('').parseBits();
    }

    test('AND', () {
      expect(
        decode(encode(0, 2, 4)),
        _matchesASM('AND R4, R2'),
      );
    });

    test('EOR', () {
      expect(
        decode(encode(1, 2, 4)),
        _matchesASM('EOR R4, R2'),
      );
    });

    test('LSL', () {
      expect(
        decode(encode(2, 2, 4)),
        _matchesASM('LSL R4, R2'),
      );
    });

    test('LSR', () {
      expect(
        decode(encode(3, 2, 4)),
        _matchesASM('LSR R4, R2'),
      );
    });

    test('ASR', () {
      expect(
        decode(encode(4, 2, 4)),
        _matchesASM('ASR R4, R2'),
      );
    });

    test('ADC', () {
      expect(
        decode(encode(5, 2, 4)),
        _matchesASM('ADC R4, R2'),
      );
    });

    test('SBC', () {
      expect(
        decode(encode(6, 2, 4)),
        _matchesASM('SBC R4, R2'),
      );
    });

    test('ROR', () {
      expect(
        decode(encode(7, 2, 4)),
        _matchesASM('ROR R4, R2'),
      );
    });

    test('TST', () {
      expect(
        decode(encode(8, 2, 4)),
        _matchesASM('TST R4, R2'),
      );
    });

    test('NEG', () {
      expect(
        decode(encode(9, 2, 4)),
        _matchesASM('NEG R4, R2'),
      );
    });

    test('CMP', () {
      expect(
        decode(encode(10, 2, 4)),
        _matchesASM('CMP R4, R2'),
      );
    });

    test('CMN', () {
      expect(
        decode(encode(11, 2, 4)),
        _matchesASM('CMN R4, R2'),
      );
    });

    test('ORR', () {
      expect(
        decode(encode(12, 2, 4)),
        _matchesASM('ORR R4, R2'),
      );
    });

    test('MUL', () {
      expect(
        decode(encode(13, 2, 4)),
        _matchesASM('MUL R4, R2'),
      );
    });

    test('BIC', () {
      expect(
        decode(encode(14, 2, 4)),
        _matchesASM('BIC R4, R2'),
      );
    });

    test('MVN', () {
      expect(
        decode(encode(15, 2, 4)),
        _matchesASM('MVN R4, R2'),
      );
    });
  });

  group('Hi register operations/branch exchange: should decode', () {
    int encode(int op, int h1, int h2, int rsOrHs, int rdOrHd) {
      return [
        '010001',
        op.toBinaryPadded(2),
        h1.toBinaryPadded(1),
        h2.toBinaryPadded(1),
        rsOrHs.toBinaryPadded(3),
        rdOrHd.toBinaryPadded(3),
      ].join('').parseBits();
    }

    test('ADD (Rd, Hs)', () {
      expect(
        decode(encode(0, 0, 1, 2, 4)),
        _matchesASM('ADD R4, H2'),
      );
    });

    test('ADD (Hd, Rs)', () {
      expect(
        decode(encode(0, 1, 0, 2, 4)),
        _matchesASM('ADD H4, R2'),
      );
    });

    test('ADD (Hd, Hs)', () {
      expect(
        decode(encode(0, 1, 1, 2, 4)),
        _matchesASM('ADD H4, H2'),
      );
    });

    test('CMP (Rd, Hs)', () {
      expect(
        decode(encode(1, 0, 1, 2, 4)),
        _matchesASM('CMP R4, H2'),
      );
    });

    test('CMP (Hd, Rs)', () {
      expect(
        decode(encode(1, 1, 0, 2, 4)),
        _matchesASM('CMP H4, R2'),
      );
    });

    test('CMP (Hd, Hs)', () {
      expect(
        decode(encode(1, 1, 1, 2, 4)),
        _matchesASM('CMP H4, H2'),
      );
    });

    test('MOV (Rd, Hs)', () {
      expect(
        decode(encode(2, 0, 1, 2, 4)),
        _matchesASM('MOV R4, H2'),
      );
    });

    test('MOV (Hd, Rs)', () {
      expect(
        decode(encode(2, 1, 0, 2, 4)),
        _matchesASM('MOV H4, R2'),
      );
    });

    test('MOV (Hd, Hs)', () {
      expect(
        decode(encode(2, 1, 1, 2, 4)),
        _matchesASM('MOV H4, H2'),
      );
    });

    test('BX Rs', () {
      expect(
        decode(encode(3, 0, 0, 2, 0)),
        _matchesASM('BX R2'),
      );
    });

    test('BX Hs', () {
      expect(
        decode(encode(3, 0, 1, 2, 0)),
        _matchesASM('BX H2'),
      );
    });
  });

  group('PC-relative: should decode', () {
    int encode(int rd, int word8) {
      return [
        '01001',
        rd.toBinaryPadded(3),
        word8.toBinaryPadded(8),
      ].join('').parseBits();
    }

    test('LDR', () {
      expect(
        decode(encode(2, 16)),
        _matchesASM('LDR R2, [PC, #16]'),
      );
    });
  });

  group('Load/store with register offset: should decode', () {
    int encode(int l, int b, int ro, int rb, int rd) {
      return [
        '0101',
        l.toBinaryPadded(1),
        b.toBinaryPadded(1),
        '0',
        ro.toBinaryPadded(3),
        rb.toBinaryPadded(3),
        rd.toBinaryPadded(3),
      ].join('').parseBits();
    }

    test('STR', () {
      expect(
        decode(encode(0, 0, 2, 4, 6)),
        _matchesASM('STR R6, [R4, R2]'),
      );
    });

    test('STRB', () {
      expect(
        decode(encode(0, 1, 2, 4, 6)),
        _matchesASM('STRB R6, [R4, R2]'),
      );
    });

    test('LDR', () {
      expect(
        decode(encode(1, 0, 2, 4, 6)),
        _matchesASM('LDR R6, [R4, R2]'),
      );
    });

    test('LDRB', () {
      expect(
        decode(encode(1, 1, 2, 4, 6)),
        _matchesASM('LDRB R6, [R4, R2]'),
      );
    });
  });

  group('Load/store sign-extended byte/halfword: should decode', () {
    int encode(int h, int s, int ro, int rb, int rd) {
      return [
        '0101',
        h.toBinaryPadded(1),
        s.toBinaryPadded(1),
        '1',
        ro.toBinaryPadded(3),
        rb.toBinaryPadded(3),
        rd.toBinaryPadded(3),
      ].join('').parseBits();
    }

    test('STRH', () {
      expect(
        decode(encode(0, 0, 2, 4, 6)),
        _matchesASM('STRH R6, [R4, R2]'),
      );
    });

    test('LDRH', () {
      expect(
        decode(encode(1, 0, 2, 4, 6)),
        _matchesASM('LDRH R6, [R4, R2]'),
      );
    });

    test('LDSB', () {
      expect(
        decode(encode(0, 1, 2, 4, 6)),
        _matchesASM('LDSB R6, [R4, R2]'),
      );
    });

    test('LDSH', () {
      expect(
        decode(encode(1, 1, 2, 4, 6)),
        _matchesASM('LDSH R6, [R4, R2]'),
      );
    });
  });

  group('Load/store with immediate offset: should decode', () {
    int encode(int b, int l, int offset5, int rb, int rd) {
      return [
        '011',
        b.toBinaryPadded(1),
        l.toBinaryPadded(1),
        offset5.toBinaryPadded(5),
        rb.toBinaryPadded(3),
        rd.toBinaryPadded(3),
      ].join('').parseBits();
    }

    test('STR', () {
      expect(
        decode(encode(0, 0, 16, 2, 4)),
        _matchesASM('STR R4, [R2, #16]'),
      );
    });

    test('LDR', () {
      expect(
        decode(encode(1, 0, 16, 2, 4)),
        _matchesASM('LDR R4, [R2, #16]'),
      );
    });

    test('STRB', () {
      expect(
        decode(encode(0, 1, 16, 2, 4)),
        _matchesASM('STRB R4, [R2, #16]'),
      );
    });

    test('LDRB', () {
      expect(
        decode(encode(1, 1, 16, 2, 4)),
        _matchesASM('LDRB R4, [R2, #16]'),
      );
    });
  });

  group('Load/store halfword: should decode', () {
    int encode(int l, int offset5, int rb, int rd) {
      return [
        '1000',
        l.toBinaryPadded(1),
        offset5.toBinaryPadded(5),
        rb.toBinaryPadded(3),
        rd.toBinaryPadded(3),
      ].join('').parseBits();
    }

    test('STRH', () {
      expect(
        decode(encode(0, 16, 2, 4)),
        _matchesASM('STRH R4, [R2, #16]'),
      );
    });

    test('LDRH', () {
      expect(
        decode(encode(1, 16, 2, 4)),
        _matchesASM('LDRH R4, [R2, #16]'),
      );
    });
  });

  group('SP-relative load/store: should decode', () {
    int encode(int l, int rd, int word8) {
      return [
        '1001',
        l.toBinaryPadded(1),
        rd.toBinaryPadded(3),
        word8.toBinaryPadded(8),
      ].join('').parseBits();
    }

    test('STR', () {
      expect(
        decode(encode(0, 2, 16)),
        _matchesASM('STR R2, [SP, #16]'),
      );
    });

    test('LDR', () {
      expect(
        decode(encode(1, 2, 16)),
        _matchesASM('LDR R2, [SP, #16]'),
      );
    });
  });

  group('Load address: should decode', () {
    int encode(int sp, int rd, int word8) {
      return [
        '1010',
        sp.toBinaryPadded(1),
        rd.toBinaryPadded(3),
        word8.toBinaryPadded(8),
      ].join('').parseBits();
    }

    test('ADD [PC]', () {
      expect(
        decode(encode(0, 2, 16)),
        _matchesASM('ADD R2, PC, #16'),
      );
    });

    test('ADD [SP]', () {
      expect(
        decode(encode(1, 2, 16)),
        _matchesASM('ADD R2, SP, #16'),
      );
    });
  });

  group('Add offset to stack pointer: should decode', () {
    int encode(int s, int sWord7) {
      return [
        '10110000',
        s.toBinaryPadded(1),
        sWord7.toBinaryPadded(7),
      ].join('').parseBits();
    }

    test('ADD [SP] +#', () {
      expect(
        decode(encode(0, 16)),
        _matchesASM('ADD SP, #16'),
      );
    });

    test('ADD [SP] -#', () {
      expect(
        decode(encode(1, 16)),
        _matchesASM('ADD SP, #-16'),
      );
    });
  });

  group('Push/pop register: should decode', () {
    int encode(int l, int r, int rlist) {
      return [
        '1011',
        l.toBinaryPadded(1),
        '10',
        r.toBinaryPadded(1),
        rlist.toBinaryPadded(8),
      ].join('').parseBits();
    }

    test('PUSH', () {
      expect(
        () => decode(encode(0, 0, 16)).accept(_printer),
        throwsUnimplementedError,
      );
    });

    test('PUSH [LR]', () {
      expect(
        () => decode(encode(0, 1, 16)).accept(_printer),
        throwsUnimplementedError,
      );
    });

    test('POP', () {
      expect(
        () => decode(encode(1, 0, 16)).accept(_printer),
        throwsUnimplementedError,
      );
    });

    test('POP [LR]', () {
      expect(
        () => decode(encode(1, 1, 16)).accept(_printer),
        throwsUnimplementedError,
      );
    });
  });

  group('Multiple load/store: should decode', () {
    int encode(int l, int rb, int rlist) {
      return [
        '1100',
        l.toBinaryPadded(1),
        rb.toBinaryPadded(3),
        rlist.toBinaryPadded(8),
      ].join('').parseBits();
    }

    test('STMIA', () {
      expect(
        () => decode(encode(0, 2, 16)).accept(_printer),
        throwsUnimplementedError,
      );
    });

    test('LDMIA', () {
      expect(
        () => decode(encode(1, 2, 16)).accept(_printer),
        throwsUnimplementedError,
      );
    });
  });

  group('Conditional branch: should decode', () {
    int encode(int cond, int sOffset8) {
      return [
        '1101',
        cond.toBinaryPadded(4),
        sOffset8.toBinaryPadded(8),
      ].join('').parseBits();
    }

    final result = [
      'BEQ',
      'BNE',
      'BCS',
      'BCC',
      'BMI',
      'BPL',
      'BVS',
      'BVC',
      'BHI',
      'BLS',
      'BGE',
      'BLT',
      'BGT',
      'BLE',
    ];

    for (var cond = 0; cond < '1101'.parseBits(); cond++) {
      final name = result[cond];
      test(name, () {
        expect(decode(encode(cond, 16)), _matchesASM('$name 16'));
      });
    }
  });

  test('Software interrupt: should decode', () {
    int encode(int value8) {
      return [
        '11011111',
        value8.toBinaryPadded(8),
      ].join('').parseBits();
    }

    expect(decode(encode(16)), _matchesASM('SWI 16'));
  });

  test('Unconditional branch: should decode', () {
    int encode(int offset11) {
      return [
        '11100',
        offset11.toBinaryPadded(11),
      ].join('').parseBits();
    }

    expect(decode(encode(16)), _matchesASM('B 16'));
  });

  group('Long branch with link: should decode', () {
    int encode(int h, int offset) {
      return [
        '1111',
        h.toBinaryPadded(1),
        offset.toBinaryPadded(11),
      ].join('').parseBits();
    }

    test('BL1', () {
      expect(decode(encode(0, 16)), _matchesASM('BL 16'));
    });

    test('BL2', () {
      expect(
        () => decode(encode(1, 16)).accept(_printer),
        throwsUnimplementedError,
      );
    });
  });
}

const _printer = ThumbInstructionPrinter();

Matcher _matchesASM(String asm) => _ThumbAssemblyMatcher(asm);

class _ThumbAssemblyMatcher extends Matcher {
  final String _assembly;

  const _ThumbAssemblyMatcher(this._assembly);

  @override
  Description describe(Description description) {
    return description.add(_assembly);
  }

  @override
  bool matches(Object describe, Map<Object, Object> _) {
    if (describe is ThumbInstruction) {
      return equals(_assembly).matches(
        describe.accept(_printer),
        <Object, Object>{},
      );
    } else {
      return false;
    }
  }
}
