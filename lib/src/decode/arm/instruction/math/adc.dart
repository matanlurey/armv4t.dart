part of '../../instruction.dart';

/// Add with Carry.
///
/// The ADC instruction is used to implement efficient multiword addition.
///
/// ## Syntax
/// `ADC{<cond>}{S} <Rd>, <Rn>, <shifter_operand>`
///
/// ## RTL
/// ```
/// if (cond)
///   Rd <-- Rn + shifter_operand + C
/// ```
///
/// ## Flags updated if [s] is used:
/// `N`, `Z`, `V`, `C`
class ADC extends ArmInstruction {
  /// Whether to set flags on the CPSR.
  final int s;

  /// `Rn`.
  final int sourceRegister;

  /// `Rd`.
  final int destinationRegister;

  /// 12-bit.
  final int shifterOperand;

  const ADC({
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
