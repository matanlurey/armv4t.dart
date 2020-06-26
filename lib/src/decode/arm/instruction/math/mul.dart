part of '../../instruction.dart';

/// Multiply Instruction (`MUL`) or Multiply-Accumulate (`MLA`).
///
/// The multiply form of the instruction gives `Rd := Rm * Rs`, where `Rn` is
/// ignored, and should be set to `0` for compatibility with possible future
/// upgrades to the instruction set.
///
/// The multiply-accumulate form gives `Rd := Rm * Rs + Rn` which can save an
/// explicit `ADD` instruction in some circumstances.
///
/// Both forms of the instruction work on operands that may be considered as
/// signed (2's complement) or unsigned integers.
///
/// The result of a signed multiply and of an unsigned multiply of 32-bit
/// operands differ only in the upper 32-bits - the low 32-bits of the signed
/// and unsigned results are indentical. As athese instructions only produce
/// the low 32-bits of a multiply, they can be used for both signed and unsigned
/// multiplies.
///
/// For example, consider the multiplication of these operands:
///
/// Operand A  | Operand B  | Result
/// ---------- | ---------- | ----------
/// 0xFFFFFFF6 | 0x00000014 | 0xFFFFFF38
///
/// **If the operands are interpreted as signed**:
///
/// Operand A has the value `-10`, operand B has the value `20`, and the result
/// is `-200`, which is correctly represented as `0xFFFFFF38`.
///
/// **If the operands are interpreted as unsigned**:
///
/// Operand A has the value `4294967286`, operand B has the value `20`, and the
/// result is `85899345720`, which is represented as `0x13FFFFFF38`, so the
/// least significant 32-bits are `0xFFFFFF38`.
abstract class MUL$MLA extends ArmInstruction {
  /// Set condition code (`0` = Do not, `1` = Set condition codes).
  final int s;

  final int destinationRegister;

  /// `Rn`.
  final int operandRegister1;

  /// `Rs`.
  final int operandRegister2;

  /// `Rm`.
  final int operandRegister3;

  const MUL$MLA._({
    @required int condition,
    @required this.s,
    @required this.destinationRegister,
    @required this.operandRegister1,
    @required this.operandRegister2,
    @required this.operandRegister3,
  }) : super._(condition);

  @override
  R accept<R, C>(
    ArmInstructionVisitor<R, C> visitor, [
    C context,
  ]) =>
      throw UnimplementedError();
}

/// A sub-type of [MUL$MLA] specifically for the `MUL` instruction.
class MUL extends MUL$MLA {
  const MUL({
    @required int condition,
    @required int s,
    @required int destinationRegister,
    @required int operandRegister1,
    @required int operandRegister2,
    @required int operandRegister3,
  }) : super._(
          condition: condition,
          s: s,
          destinationRegister: destinationRegister,
          operandRegister1: operandRegister1,
          operandRegister2: operandRegister2,
          operandRegister3: operandRegister3,
        );
}
