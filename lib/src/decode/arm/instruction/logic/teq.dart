part of '../../instruction.dart';

/// Test Equivalence.
///
/// The [TEQ] instruction performs a non-destructive bit-wise XOR (the result is
/// not stored). The flags are _always updated_. The most common use for this
/// instruction is to determine if two operands are equal without affecting the
/// `V` flag. It can also be use to tell if two values have the same sign, since
/// the `N` flag will be the logical XOR of the two sign bits.
///
/// ## Syntax
/// `TEQ{<cond>}{S} <Rd>, <Rn>, <shifter_operand>`
///
/// ## RTL
/// ```
/// if (cond)
///   Rn XOR shifter_operand
/// ```
///
/// ## Flags updated:
/// `N`, `Z`, `C`
class TEQ extends ArmInstruction {
  /// Whether [shifterOperand] is an immediate vlaue.
  final int i;

  /// `Rn`.
  final int sourceRegister;

  /// `Rd`.
  final int destinationRegister;

  /// 12-bit.
  final int shifterOperand;

  const TEQ({
    @required int condition,
    @required this.i,
    @required this.sourceRegister,
    @required this.destinationRegister,
    @required this.shifterOperand,
  }) : super._(condition);

  @override
  R accept<R, C>(
    ArmInstructionVisitor<R, C> visitor, [
    C context,
  ]) =>
      visitor.visitTEQ(this, context);
}
