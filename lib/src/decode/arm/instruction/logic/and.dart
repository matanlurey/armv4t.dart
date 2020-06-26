part of '../../instruction.dart';

/// Bit-wise AND.
///
/// ## Syntax
/// `AND{<cond>}{S} <Rd>, <Rn>, <shifter_operand>`
///
/// ## RTL
/// ```
/// if (cond)
///   Rd <-- Rn AND shifter_operand
/// ```
///
/// ## Flags updated if [s] is used:
/// `N`, `Z`, `C`
class AND extends ArmInstruction {
  /// Whether [shifterOperand] is an immediate vlaue.
  final int i;

  /// Whether to set flags on the CPSR.
  final int s;

  /// `Rn`.
  final int sourceRegister;

  /// `Rd`.
  final int destinationRegister;

  /// 12-bit.
  final int shifterOperand;

  const AND({
    @required int condition,
    @required this.i,
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
      visitor.visitAND(this, context);
}
