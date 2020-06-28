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

    // TODO: Test. This seems to conflict with the other formats.
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

    expect(decodeImmediate(encode(7, 1)), _matchesASM('R1, LSL #7'));
  });

  test('REGISTER_OPERAND_LOGICAL_SHIFT_LEFT_BY_REGISTER', () {
    int encode(int s, int m) {
      return [
        s.toBinaryPadded(4),
        '0001',
        m.toBinaryPadded(4),
      ].join('').parseBits();
    }

    expect(decodeRegister(encode(1, 2)), _matchesASM('R1, LSL R2'));
  });

  test('REGISTER_OPERAND_LOGICAL_SHIFT_RIGHT_BY_IMMEDIATE', () {
    int encode(int s, int m) {
      return [
        s.toBinaryPadded(5),
        '010',
        m.toBinaryPadded(4),
      ].join('').parseBits();
    }

    expect(decodeImmediate(encode(7, 1)), _matchesASM('R1, LSL #7'));
  });

  test('REGISTER_OPERAND_LOGICAL_SHIFT_RIGHT_BY_REGISTER', () {});

  test('REGISTER_OPERAND_LOGICAL_SHIFT_RIGHT_BY_REGISTER', () {});

  test('REGISTER_OPERAND_ROTATE_RIGHT_BY_IMMEDIATE', () {});

  test('REGISTER_OPERAND_ROTATE_RIGHT_BY_REGISTER', () {});

  test('REGISTER_OPERAND_ROTATE_RIGHT_WITH_EXTEND', () {});
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
