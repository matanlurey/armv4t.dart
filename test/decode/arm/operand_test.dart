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

    expect(decodeImmediate(encode(2, 16)), _matchesASM('256'));
  });

  test('REGISTER_OPERAND', () {
    int encode(int m) {
      return [
        '0000',
        '0000',
        m.toBinaryPadded(4),
      ].join('').parseBits();
    }

    expect(decodeRegister(encode(1)), _matchesASM('r1'));
  });

  test('REGISTER_OPERAND_LOGICAL_SHIFT_LEFT_BY_IMMEDIATE', () {
    int encode(int s, int m) {
      return [
        s.toBinaryPadded(5),
        '000',
        m.toBinaryPadded(4),
      ].join('').parseBits();
    }

    expect(decodeRegister(encode(7, 1)), _matchesASM('r1, lsl 7'));
  });

  test('REGISTER_OPERAND_LOGICAL_SHIFT_LEFT_BY_REGISTER', () {
    int encode(int s, int m) {
      return [
        s.toBinaryPadded(4),
        '0000',
        m.toBinaryPadded(4),
      ].join('').parseBits();
    }

    expect(decodeRegister(encode(1, 2)), _matchesASM('r2, lsl r1'));
  });

  test('REGISTER_OPERAND_LOGICAL_SHIFT_RIGHT_BY_IMMEDIATE', () {
    int encode(int s, int m) {
      return [
        s.toBinaryPadded(5),
        '010',
        m.toBinaryPadded(4),
      ].join('').parseBits();
    }

    expect(decodeRegister(encode(7, 1)), _matchesASM('r1, lsr 7'));
  });

  test('REGISTER_OPERAND_LOGICAL_SHIFT_RIGHT_BY_REGISTER', () {
    int encode(int s, int m) {
      return [
        s.toBinaryPadded(4),
        '0011',
        m.toBinaryPadded(4),
      ].join('').parseBits();
    }

    expect(decodeRegister(encode(1, 2)), _matchesASM('r2, lsr r1'));
  });

  test('REGISTER_OPERAND_LOGICAL_SHIFT_RIGHT_BY_REGISTER', () {
    int encode(int s, int m) {
      return [
        s.toBinaryPadded(4),
        '0101',
        m.toBinaryPadded(4),
      ].join('').parseBits();
    }

    expect(decodeRegister(encode(1, 2)), _matchesASM('r2, asr r1'));
  });

  test('REGISTER_OPERAND_ROTATE_RIGHT_BY_IMMEDIATE', () {
    int encode(int s, int m) {
      return [
        s.toBinaryPadded(5),
        '110',
        m.toBinaryPadded(4),
      ].join('').parseBits();
    }

    expect(decodeRegister(encode(7, 1)), _matchesASM('r1, ror 7'));
  });

  test('REGISTER_OPERAND_ROTATE_RIGHT_BY_REGISTER', () {
    int encode(int s, int m) {
      return [
        s.toBinaryPadded(4),
        '0111',
        m.toBinaryPadded(4),
      ].join('').parseBits();
    }

    expect(decodeRegister(encode(1, 2)), _matchesASM('r2, ror r1'));
  });

  test('REGISTER_OPERAND_ROTATE_RIGHT_WITH_EXTEND', () {
    int encode(int m) {
      return [
        '0000',
        '0110',
        m.toBinaryPadded(4),
      ].join('').parseBits();
    }

    expect(decodeRegister(encode(2)), _matchesASM('r2, rrx'));
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
