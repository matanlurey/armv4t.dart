part of '../../instruction.dart';

/// Reverse Subtract.
///
/// If a 64-bit number is stored in `R1:0`, it can be negated (2's complement).
///
/// ## Syntax
/// `RSC{<cond>}{S} <Rd>, <Rn>, <shifter_operand>`
///
/// ## RTL
/// ```
/// if (cond)
///   Rd <-- shifter_operand - Rn - NOT C
/// ```
///
/// ## Flags updated if [s] is used:
/// `N`, `Z`, `V`, `C`
///
/// > NOTE: The carry flag (`C`) is the complement of the borrow flag. If a
/// > borrow is required by the operation, `C` will be set to `0`.
class RSC extends ArmInstruction {
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

  const RSC({
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
      visitor.visitRSC(this, context);
}
