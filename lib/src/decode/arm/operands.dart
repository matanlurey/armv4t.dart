import 'package:armv4t/src/utils.dart';
import 'package:binary/binary.dart';
import 'package:meta/meta.dart';

/// Represents the least-significant 12-bits of an instruction.
///
/// It can take one of eleven forms (sub-types of [ArmShifterOperand]).
abstract class ArmShifterOperand {
  const ArmShifterOperand._();

  R accept<R, C>(
    ShifterOperandVisitor<R, C> visitor, [
    C context,
  ]);

  @override
  String toString() {
    if (assertionsEnabled) {
      return accept(const ShifterOperandPrinter());
    } else {
      return super.toString();
    }
  }
}

/// Decodes an [int] `bits` into an [ArmShifterOperand].
class ShifterOperandDecoder {
  static final _registerPatterns = [
    RegisterOperand._pattern,
    RegisterOperandLogicalShiftLeftByImmediate._pattern,
    RegisterOperandLogicalShiftLeftByRegister._pattern,
    RegisterOperandLogicalShiftRightByImmediate._pattern,
    RegisterOperandLogicalShiftRightByRegister._pattern,
    RegisterOperandArithmeticShiftRightByImmediate._pattern,
    RegisterOperandArithmeticShiftRightByRegister._pattern,
    RegisterOperandRotateRightByImmediate._pattern,
    RegisterOperandRotateRightByRegister._pattern,
    RegisterOperandRotateRightWithExtend._pattern,
  ].toGroup();

  const ShifterOperandDecoder();

  @alwaysThrows
  // ignore: prefer_void_to_null
  static Null _couldNotDecode(int bits) {
    throw FormatException('Could not decode operand', bits.toBinaryPadded(12));
  }

  /// Decodes [bits] into an [ArmShifterOperand].
  ArmShifterOperand decodeImmediate(int bits) {
    final c = ImmediateOperand._pattern.capture(bits);
    return ImmediateOperand(
      rotateImmediate: c[0],
      immediate8: c[1],
    );
  }

  /// Decodes [bits] into an [ArmShifterOperand].
  ArmShifterOperand decodeRegister(int bits) {
    final p = _registerPatterns.match(bits);
    if (p == null) {
      _couldNotDecode(bits);
    }
    final c = p.capture(bits);
    if (identical(p, RegisterOperand._pattern)) {
      return RegisterOperand(
        register: c[0],
      );
    }
    if (identical(p, RegisterOperandLogicalShiftLeftByImmediate._pattern)) {
      return RegisterOperandLogicalShiftLeftByImmediate(
        shiftImmediate: c[0],
        register: c[1],
      );
    }
    if (identical(p, RegisterOperandLogicalShiftLeftByRegister._pattern)) {
      return RegisterOperandLogicalShiftLeftByRegister(
        shiftRegister: c[0],
        register: c[1],
      );
    }
    if (identical(p, RegisterOperandLogicalShiftRightByImmediate._pattern)) {
      return RegisterOperandLogicalShiftRightByImmediate(
        shiftImmediate: c[0],
        register: c[1],
      );
    }
    if (identical(p, RegisterOperandLogicalShiftRightByRegister._pattern)) {
      return RegisterOperandLogicalShiftRightByRegister(
        shiftRegister: c[0],
        register: c[1],
      );
    }
    if (identical(p, RegisterOperandArithmeticShiftRightByImmediate._pattern)) {
      return RegisterOperandArithmeticShiftRightByImmediate(
        shiftImmediate: c[0],
        register: c[1],
      );
    }
    if (identical(p, RegisterOperandArithmeticShiftRightByRegister._pattern)) {
      return RegisterOperandArithmeticShiftRightByRegister(
        shiftRegister: c[0],
        register: c[1],
      );
    }
    if (identical(p, RegisterOperandRotateRightByImmediate._pattern)) {
      return RegisterOperandRotateRightByImmediate(
        shiftImmediate: c[0],
        register: c[1],
      );
    }
    if (identical(p, RegisterOperandRotateRightByRegister._pattern)) {
      return RegisterOperandRotateRightByRegister(
        shiftRegister: c[0],
        register: c[1],
      );
    }
    if (identical(p, RegisterOperandRotateRightWithExtend._pattern)) {
      return RegisterOperandRotateRightWithExtend(
        register: c[0],
      );
    }
    return _couldNotDecode(bits);
  }
}

abstract class ShifterOperandVisitor<R, C> {
  R visitImmediateOperand(
    ImmediateOperand operand, [
    C context,
  ]);

  R visitRegisterOperand(
    RegisterOperand operand, [
    C context,
  ]);

  R visitRegisterOperandLogicalShiftLeftByImmediate(
    RegisterOperandLogicalShiftLeftByImmediate operand, [
    C context,
  ]);

  R visitRegisterOperandLogicalShiftLeftByRegister(
    RegisterOperandLogicalShiftLeftByRegister operand, [
    C context,
  ]);

  R visitRegisterOperandLogicalShiftRightByImmediate(
    RegisterOperandLogicalShiftRightByImmediate operand, [
    C context,
  ]);

  R visitRegisterOperandLogicalShiftRightByRegister(
    RegisterOperandLogicalShiftRightByRegister operand, [
    C context,
  ]);

  R visitRegisterOperandArithmeticShiftRightByImmediate(
    RegisterOperandArithmeticShiftRightByImmediate operand, [
    C context,
  ]);

  R visitRegisterOperandArithmeticShiftRightByRegister(
    RegisterOperandArithmeticShiftRightByRegister operand, [
    C context,
  ]);

  R visitRegisterOperandRotateRightByImmediate(
    RegisterOperandRotateRightByImmediate operand, [
    C context,
  ]);

  R visitRegisterOperandRotateRightByRegister(
    RegisterOperandRotateRightByRegister operand, [
    C context,
  ]);

  R visitRegisterOperandRotateRightWithExtend(
    RegisterOperandRotateRightWithExtend operand, [
    C context,
  ]);
}

class ShifterOperandPrinter implements ShifterOperandVisitor<String, void> {
  const ShifterOperandPrinter();

  @override
  String visitImmediateOperand(
    ImmediateOperand operand, [
    void _,
  ]) {
    // #<immediate>
    //
    // Immediate values are signified by a leading # symbol. The operand is
    // actually stored in the instruction as an 8-bit value with a 4-bit
    // rotation code. The resultant value is the 8-th bit value rotated right
    // 0-30 bits (twice the rotation code amount).
    //
    // To undo the encoding, we rotate left 0-30 bits.
    final code = operand.rotateImmediate * 2;
    final bits = operand.immediate8;
    final undo = bits << code;
    return '#$undo';
  }

  @override
  String visitRegisterOperand(
    RegisterOperand operand, [
    void _,
  ]) {
    // <Rm>
    //
    // The register value is used directly.
    return 'R${operand.register}';
  }

  @override
  String visitRegisterOperandLogicalShiftLeftByImmediate(
    RegisterOperandLogicalShiftLeftByImmediate operand, [
    void _,
  ]) {
    // <Rm>, LSL #<immediate>
    // The register value is shifted left by an immedaite value in range 0-31.
    return 'R${operand.register}, LSL #${operand.shiftImmediate}';
  }

  @override
  String visitRegisterOperandLogicalShiftLeftByRegister(
    RegisterOperandLogicalShiftLeftByRegister operand, [
    void _,
  ]) {
    // <Rm>, LSL <Rs>
    // The register value is shifted left by a value contained in a register.
    return 'R${operand.register}, LSL R${operand.shiftRegister}';
  }

  @override
  String visitRegisterOperandLogicalShiftRightByImmediate(
    RegisterOperandLogicalShiftRightByImmediate operand, [
    void _,
  ]) {
    // <Rm>, LSR #<immediate>.
    return 'R${operand.register}, LSR #${operand.shiftImmediate}';
  }

  @override
  String visitRegisterOperandLogicalShiftRightByRegister(
    RegisterOperandLogicalShiftRightByRegister operand, [
    void _,
  ]) {
    // <Rm>, LSR <Rs>
    return 'R${operand.register}, LSR R${operand.shiftRegister}';
  }

  @override
  String visitRegisterOperandArithmeticShiftRightByImmediate(
    RegisterOperandArithmeticShiftRightByImmediate operand, [
    void _,
  ]) {
    // <Rm>, ASR #<immediate>
    return 'R${operand.register}, ASR #${operand.shiftImmediate}';
  }

  @override
  String visitRegisterOperandArithmeticShiftRightByRegister(
    RegisterOperandArithmeticShiftRightByRegister operand, [
    void _,
  ]) {
    // <Rm>, ASR <Rs>
    return 'R${operand.register}, ASR R${operand.shiftRegister}';
  }

  @override
  String visitRegisterOperandRotateRightByImmediate(
    RegisterOperandRotateRightByImmediate operand, [
    void _,
  ]) {
    // <Rm>, ROR #<immediate>
    return 'R${operand.register}, ROR #${operand.shiftImmediate}';
  }

  @override
  String visitRegisterOperandRotateRightByRegister(
    RegisterOperandRotateRightByRegister operand, [
    void _,
  ]) {
    // <Rm>, ROR <Rs>
    return 'R${operand.register}, ROR R${operand.shiftRegister}';
  }

  @override
  String visitRegisterOperandRotateRightWithExtend(
    RegisterOperandRotateRightWithExtend operand, [
    void _,
  ]) {
    // <Rm>, RRX
    return 'R${operand.register}, RRX';
  }
}

/// Immediate values are signified by a leading `#` symbol.
///
/// The operand is actually stored in the instruction as a 8-bit value with a
/// 4-bit rotation code, and the resultant value is the 8-bit value rotated
/// right 0-30 bits (twice the rotation code amount). Only values that can be
/// represented in this form can be encoded an immediate operands.
///
/// ```
/// 11 .... 08 | 07 ..... 00
/// ---------- | -----------
/// rotate_imm | immediate_8
/// ```
///
/// The assembler will make substiutions of comparable instructions if it
/// makes it possible to create the desired immediate operand. For example
/// `CMP R0, #-1` is not a legal instruction since it is not possible to specify
/// `-1` (0xFFFFFFF) as an immediate value, but this can be replaced by
/// `CMN R0, #1`. If the rotate value is non-zero, the `C` flag is set to bit
/// 31 of the immediate value, otherwise it is unchanged.
///
/// Syntax: `#<immediate>`.
/// Example: `CMP R0, #7`.
class ImmediateOperand extends ArmShifterOperand {
  static final _pattern = BitPatternBuilder.parse(
    'RRRR_IIII_IIII',
  ).build('IMMEDIATE_OPERAND');

  /// 4-bit rotation code.
  final int rotateImmediate;

  /// 8-bit immediate value.
  final int immediate8;

  const ImmediateOperand({
    @required this.rotateImmediate,
    @required this.immediate8,
  }) : super._();

  @override
  R accept<R, C>(
    ShifterOperandVisitor<R, C> visitor, [
    C context,
  ]) =>
      visitor.visitImmediateOperand(this, context);
}

/// The register value is used directly.
///
/// The `C` flag is unchanged. Note that this is actually a form of the register
/// operand, logical shift left by immediate option with a 0-bit shift:
///
/// ```
/// 11 ..... 04 | 03 ... 00
/// ----------- | ---------
/// 0  .....  0 |    Rm
/// ```
///
/// Syntax: `<Rm>`.
/// Example: `CMP R0, R1`.
class RegisterOperand extends ArmShifterOperand {
  static final _pattern = BitPatternBuilder.parse(
    '0000_0000_RRRR',
  ).build('REGISTER_OPERAND');

  /// 4-bit regsiter reference.
  final int register;

  const RegisterOperand({
    @required this.register,
  }) : super._();

  @override
  R accept<R, C>(
    ShifterOperandVisitor<R, C> visitor, [
    C context,
  ]) =>
      visitor.visitRegisterOperand(this, context);
}

/// The register value is shifted left by an immediate value in the range 0-31.
///
/// Note that a shift of zero is identical to the encoding for a register
/// operand with no shift. The `C` flag will be updated with the last value
/// shifted out of [register] unless [shiftImmediate] count is `0`.
///
/// ```
/// 11 ..... 07 | 06 ... 04 | 03 ... 00
/// ----------- | --------- | ---------
///  shift_imm  |   0 0 0   |    Rm
/// ```
///
/// Syntax: `<Rm>, LSL #<immediate>`.
/// Example: `CMP R0, R1, LSL #7`.
class RegisterOperandLogicalShiftLeftByImmediate extends ArmShifterOperand {
  static final _pattern = BitPatternBuilder.parse(
    'SSSS_S000_MMMM',
  ).build('REGISTER_OPERAND_LOGICAL_SHIFT_LEFT_BY_IMMEDIATE');

  /// 5-bit shift value for [register].
  final int shiftImmediate;

  /// 4-bit register reference.
  final int register;

  const RegisterOperandLogicalShiftLeftByImmediate({
    @required this.shiftImmediate,
    @required this.register,
  }) : super._();

  @override
  R accept<R, C>(
    ShifterOperandVisitor<R, C> visitor, [
    C context,
  ]) =>
      visitor.visitRegisterOperandLogicalShiftLeftByImmediate(this, context);
}

/// The register value is shifted left by a value contained in a register.
///
/// The `C` flag will be updated with the last value shifted out of [register]
/// unless the value in [shiftRegister] is `0`.
///
/// ```
/// 11 ..... 08 | 07 ... 04 | 03 ... 00
/// ----------- | --------- | ---------
///     Rs      |  0 0 0 0  |    Rm
/// ```
///
/// Syntax: `<Rm>, LSL <Rs>`.
/// Example: `CMP R0, R1, LSL R2`.
class RegisterOperandLogicalShiftLeftByRegister extends ArmShifterOperand {
  static final _pattern = BitPatternBuilder.parse(
    'SSSS_0000_MMMM',
  ).build('REGISTER_OPERAND_LOGICAL_SHIFT_LEFT_BY_REGISTER');

  /// 8-bit shift register for [register].
  final int shiftRegister;

  /// 4-bit register reference.
  final int register;

  const RegisterOperandLogicalShiftLeftByRegister({
    @required this.shiftRegister,
    @required this.register,
  }) : super._();

  @override
  R accept<R, C>(
    ShifterOperandVisitor<R, C> visitor, [
    C context,
  ]) =>
      visitor.visitRegisterOperandLogicalShiftLeftByRegister(this, context);
}

/// The register value is shifted right by an immediate value in the range 1-32.
///
/// The `C` flag will be updated with the last value shifted out of `Rm`.
///
/// ```
/// 11 ..... 07 | 06 ... 04 | 03 ... 00
/// ----------- | --------- | ---------
///  shift_imm  |   0 1 0   |    Rm
/// ```
///
/// Syntax: `<Rm>, LSR #<immediate>`.
/// Example: `CMP R0, R1, LSR #7`.
class RegisterOperandLogicalShiftRightByImmediate extends ArmShifterOperand {
  static final _pattern = BitPatternBuilder.parse(
    'SSSS_S010_MMMM',
  ).build('REGISTER_OPERAND_LOGICAL_SHIFT_LEFT_BY_IMMEDIATE');

  /// 5-bit shift value for [register].
  final int shiftImmediate;

  /// 4-bit register reference.
  final int register;

  const RegisterOperandLogicalShiftRightByImmediate({
    @required this.shiftImmediate,
    @required this.register,
  }) : super._();

  @override
  R accept<R, C>(
    ShifterOperandVisitor<R, C> visitor, [
    C context,
  ]) =>
      visitor.visitRegisterOperandLogicalShiftRightByImmediate(this, context);
}

/// The register value is shifted right by a value contained in a register.
///
/// The `C` flag will be updated with the last value shifted out of [register]
/// unless the value in [shiftRegister] is `0`.
///
/// ```
/// 11 ..... 08 | 07 ... 04 | 03 ... 00
/// ----------- | --------- | ---------
///     Rs      |  0 0 1 1  |    Rm
/// ```
///
/// Syntax: `<Rm>, LSR <Rs>`.
/// Example: `CMP R0, R1, LSR R2`.
class RegisterOperandLogicalShiftRightByRegister extends ArmShifterOperand {
  static final _pattern = BitPatternBuilder.parse(
    'SSSS_0011_MMMM',
  ).build('REGISTER_OPERAND_LOGICAL_SHIFT_RIGHT_BY_REGISTER');

  /// 8-bit shift register for [register].
  final int shiftRegister;

  /// 4-bit register reference.
  final int register;

  const RegisterOperandLogicalShiftRightByRegister({
    @required this.shiftRegister,
    @required this.register,
  }) : super._();

  @override
  R accept<R, C>(
    ShifterOperandVisitor<R, C> visitor, [
    C context,
  ]) =>
      visitor.visitRegisterOperandLogicalShiftRightByRegister(this, context);
}

/// The register is arithmetically shifted right by an immediate value 1-32.
///
/// The arithmetic shift fills from the left with the sign bit, preserving the
/// sign of the number. The `C` flag will be updated with the last value shifted
/// out of `Rm`.
///
/// ```
/// 11 ..... 07 | 06 ... 04 | 03 ... 00
/// ----------- | --------- | ---------
///  shift_imm  |   1 0 0   |    Rm
/// ```
///
/// Syntax: `<Rm>, ASR #<immediate>`.
/// Example: `CMP R0, R1, ASR #7`.
class RegisterOperandArithmeticShiftRightByImmediate extends ArmShifterOperand {
  static final _pattern = BitPatternBuilder.parse(
    'SSSS_S100_MMMM',
  ).build('REGISTER_OPERAND_LOGICAL_SHIFT_RIGHT_BY_IMMEDIATE');

  /// 5-bit shift value for [register].
  final int shiftImmediate;

  /// 4-bit register reference.
  final int register;

  const RegisterOperandArithmeticShiftRightByImmediate({
    @required this.shiftImmediate,
    @required this.register,
  }) : super._();

  @override
  R accept<R, C>(
    ShifterOperandVisitor<R, C> visitor, [
    C context,
  ]) =>
      visitor.visitRegisterOperandArithmeticShiftRightByImmediate(
        this,
        context,
      );
}

/// The register value is arithmetically shifted right by a value in a register.
///
/// The arithmetic shift fills from the left with the sign bit, preserving the
/// sign of the number. The `C` flag will be updated with the last value shifted
/// out of `Rm` unless the value in `Rs` is `0`.
///
/// ```
/// 11 ..... 08 | 07 ... 04 | 03 ... 00
/// ----------- | --------- | ---------
///     Rs      |  0 1 0 1  |    Rm
/// ```
///
/// Syntax: `<Rm>, ASR <Rs>`.
/// Example: `CMP R0, R1, ASR R2`.
class RegisterOperandArithmeticShiftRightByRegister extends ArmShifterOperand {
  static final _pattern = BitPatternBuilder.parse(
    'SSSS_0101_MMMM',
  ).build('REGISTER_OPERAND_LOGICAL_SHIFT_RIGHT_BY_REGISTER');

  /// 8-bit shift register for [register].
  final int shiftRegister;

  /// 4-bit register reference.
  final int register;

  const RegisterOperandArithmeticShiftRightByRegister({
    @required this.shiftRegister,
    @required this.register,
  }) : super._();

  @override
  R accept<R, C>(
    ShifterOperandVisitor<R, C> visitor, [
    C context,
  ]) =>
      visitor.visitRegisterOperandArithmeticShiftRightByRegister(this, context);
}

/// The register value is rotated right by an immediate value in range 1-31.
///
/// A rotate value of `0` in this encoding will cause an `RRX` operation to be
/// performed. The `C` flag will be updated with the last value shifted out of
/// `Rm`.
///
/// ```
/// 11 ..... 07 | 06 ... 04 | 03 ... 00
/// ----------- | --------- | ---------
///  shift_imm  |   1 1 0   |    Rm
/// ```
///
/// Syntax: `<Rm>, ROR #<immediate>`.
/// Example: `CMP R0, R1, ROR #7`.
class RegisterOperandRotateRightByImmediate extends ArmShifterOperand {
  static final _pattern = BitPatternBuilder.parse(
    'SSSS_S110_MMMM',
  ).build('REGISTER_OPERAND_ROTATE_RIGHT_BY_IMMEDIATE');

  /// 5-bit shift value for [register].
  final int shiftImmediate;

  /// 4-bit register reference.
  final int register;

  const RegisterOperandRotateRightByImmediate({
    @required this.shiftImmediate,
    @required this.register,
  }) : super._();

  @override
  R accept<R, C>(
    ShifterOperandVisitor<R, C> visitor, [
    C context,
  ]) =>
      visitor.visitRegisterOperandRotateRightByImmediate(this, context);
}

/// The register value is rotated right by a value contained in a register.
///
/// The `C` flag will be updated with the last value shifted out of `Rm` unless
/// the value is `Rs` is `0`.
///
/// ```
/// 11 ..... 08 | 07 ... 04 | 03 ... 00
/// ----------- | --------- | ---------
///     Rs      |  0 1 1 1  |    Rm
/// ```
///
/// Syntax: `<Rm>, ROR <Rs>`.
/// Example: `CMP R0, R1, ROR R2`.
class RegisterOperandRotateRightByRegister extends ArmShifterOperand {
  static final _pattern = BitPatternBuilder.parse(
    'SSSS_0111_MMMM',
  ).build('REGISTER_OPERAND_ROTATE_RIGHT_BY_REGISTER');

  /// 8-bit shift register for [register].
  final int shiftRegister;

  /// 4-bit register reference.
  final int register;

  const RegisterOperandRotateRightByRegister({
    @required this.shiftRegister,
    @required this.register,
  }) : super._();

  @override
  R accept<R, C>(
    ShifterOperandVisitor<R, C> visitor, [
    C context,
  ]) =>
      visitor.visitRegisterOperandRotateRightByRegister(this, context);
}

/// The register value is rotated right by one-bit through the `C` flag.
///
/// I.e. `C <- Rm[0], Rm[31] <- C, Rm[30] <- Rm[29]` (etc).
///
/// ```
/// 11 ......... 04 | 03 ... 00
/// --------------- | ---------
/// 0 0 0 0 0 1 1 0 |    Rm
/// ```
class RegisterOperandRotateRightWithExtend extends ArmShifterOperand {
  static final _pattern = BitPatternBuilder.parse(
    '0000_0110_MMMM',
  ).build('REGISTER_OPERAND_ROTATE_RIGHT_WITH_EXTEND');

  /// 4-bit register reference.
  final int register;

  const RegisterOperandRotateRightWithExtend({
    @required this.register,
  }) : super._();

  @override
  R accept<R, C>(
    ShifterOperandVisitor<R, C> visitor, [
    C context,
  ]) =>
      visitor.visitRegisterOperandRotateRightWithExtend(this, context);
}
