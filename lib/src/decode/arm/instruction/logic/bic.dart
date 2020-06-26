part of '../../instruction.dart';

/// Bit clear.
///
/// ## Syntax
/// `BIC{<cond>}{S} <Rd>, <Rn>, <shifter_operand>`
///
/// ## RTL
/// ```
/// if (cond)
///   Rd <-- Rn AND NOT shifter_operand
/// ```
///
/// ## Flags updated if [s] is used:
/// `N`, `Z`
class BIC extends ArmInstruction {
  /// Whether to set flags on the CPSR.
  final int s;

  /// `Rn`.
  final int sourceRegister;

  /// `Rd`.
  final int destinationRegister;

  /// 12-bit.
  final int shifterOperand;

  const BIC({
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
      throw UnimplementedError();
}
