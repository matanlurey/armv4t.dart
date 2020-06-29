import 'package:armv4t/src/decode/arm/operands.dart';
import 'package:binary/binary.dart';
import 'package:test/test.dart';

void main() {
  final decoder = ShifterOperandDecoder();

  ArmShifterOperand decodeImmediate(int bits) {
    return decoder.decodeImmediate(bits);
  }

  ArmShifterOperand decodeRegister(int bits) {
    return decoder.decodeRegister(bits);
  }

  test('IMMEDIATE_OPERAND', () {
    int encode(int r, int i) {
      return [
        r.toBinaryPadded(4),
        i.toBinaryPadded(8),
      ].join('').parseBits();
    }

    expect(decodeImmediate(encode(2, 16)), _matchesASM('#256'));
  });

  test('REGISTER_OPERAND', () {
    int encode(int m) {
      return [
        '0000',
        '0000',
        m.toBinaryPadded(4),
      ].join('').parseBits();
    }

    expect(decodeRegister(encode(1)), _matchesASM('R1'));
  });

  test('REGISTER_OPERAND_LOGICAL_SHIFT_LEFT_BY_IMMEDIATE', () {
    int encode(int s, int m) {
      return [
        s.toBinaryPadded(5),
        '000',
        m.toBinaryPadded(4),
      ].join('').parseBits();
    }

    expect(decodeRegister(encode(7, 1)), _matchesASM('R1, LSL #7'));
  });

  test('REGISTER_OPERAND_LOGICAL_SHIFT_LEFT_BY_REGISTER', () {
    int encode(int s, int m) {
      return [
        s.toBinaryPadded(4),
        '0000',
        m.toBinaryPadded(4),
      ].join('').parseBits();
    }

    expect(decodeRegister(encode(1, 2)), _matchesASM('R2, LSL R1'));
  });

  test('REGISTER_OPERAND_LOGICAL_SHIFT_RIGHT_BY_IMMEDIATE', () {
    int encode(int s, int m) {
      return [
        s.toBinaryPadded(5),
        '010',
        m.toBinaryPadded(4),
      ].join('').parseBits();
    }

    expect(decodeRegister(encode(7, 1)), _matchesASM('R1, LSR #7'));
  });

  test('REGISTER_OPERAND_LOGICAL_SHIFT_RIGHT_BY_REGISTER', () {
    int encode(int s, int m) {
      return [
        s.toBinaryPadded(4),
        '0011',
        m.toBinaryPadded(4),
      ].join('').parseBits();
    }

    expect(decodeRegister(encode(1, 2)), _matchesASM('R2, LSR R1'));
  });

  test('REGISTER_OPERAND_LOGICAL_SHIFT_RIGHT_BY_REGISTER', () {
    int encode(int s, int m) {
      return [
        s.toBinaryPadded(4),
        '0101',
        m.toBinaryPadded(4),
      ].join('').parseBits();
    }

    expect(decodeRegister(encode(1, 2)), _matchesASM('R2, ASR R1'));
  });

  test('REGISTER_OPERAND_ROTATE_RIGHT_BY_IMMEDIATE', () {
    int encode(int s, int m) {
      return [
        s.toBinaryPadded(5),
        '110',
        m.toBinaryPadded(4),
      ].join('').parseBits();
    }

    expect(decodeRegister(encode(7, 1)), _matchesASM('R1, ROR #7'));
  });

  test('REGISTER_OPERAND_ROTATE_RIGHT_BY_REGISTER', () {
    int encode(int s, int m) {
      return [
        s.toBinaryPadded(4),
        '0111',
        m.toBinaryPadded(4),
      ].join('').parseBits();
    }

    expect(decodeRegister(encode(1, 2)), _matchesASM('R2, ROR R1'));
  });

  test('REGISTER_OPERAND_ROTATE_RIGHT_WITH_EXTEND', () {
    int encode(int m) {
      return [
        '0000',
        '0110',
        m.toBinaryPadded(4),
      ].join('').parseBits();
    }

    expect(decodeRegister(encode(2)), _matchesASM('R2, RRX'));
  });
}

const _printer = ShifterOperandPrinter();

Matcher _matchesASM(String asm) => _ShifterOperandMatcher(asm);

class _ShifterOperandMatcher extends Matcher {
  final String _assembly;

  const _ShifterOperandMatcher(this._assembly);

  @override
  Description describe(Description description) {
    return description.add(_assembly);
  }

  @override
  bool matches(Object describe, Map<Object, Object> matchState) {
    if (describe is ArmShifterOperand) {
      final matcher = equals(_assembly);
      final result = describe.accept(_printer);
      return matcher.matches(result, matchState);
    } else {
      return false;
    }
  }
}
