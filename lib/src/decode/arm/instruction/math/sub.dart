part of '../../instruction.dart';

/// Subtract.
///
/// ## Syntax
/// `SUB{<cond>}{S} <Rd>, <Rn>, <shifter_operand>`
///
/// ## RTL
/// ```
/// if (cond)
///   Rd <- Rn - shifter_operand
/// ```
///
/// ## Flags updated if [s] is used:
/// `N`, `Z`, `V`, `C`
///
/// > NOTE: The carry flag (`C`) is the complement of the borrow flag. If a
/// > borrow is required by the operation, `C` will be set to `0`.
class SUB extends ArmInstruction {
  /// Whether to set flags on the CPSR.
  final int s;

  /// `Rn`.
  final int sourceRegister;

  /// `Rd`.
  final int destinationRegister;

  /// 12-bit.
  final int shifterOperand;

  const SUB({
    @required int condition,
    @required this.s,
    @required this.sourceRegister,
    @required this.destinationRegister,
    @required this.shifterOperand,
  }) : super._(condition);

  @override
  R accept<R, C>(
    ArmInstructionVisitor<R, C> visitor, [
    C context,
  ]) =>
      visitor.visitSUB(this, context);
}
