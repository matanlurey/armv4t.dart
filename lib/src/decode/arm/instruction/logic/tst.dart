part of '../../instruction.dart';

/// Test.
///
/// The [TST] instruction performs a non-destructive `AND` (the result is not
/// stored). The flags are _always updated_. The msot common use for this
/// instruction is to determine the value of an individual bit of a register.
///
/// ## Syntax
/// `TST{<cond>}{S} <Rd>, <Rn>, <shifter_operand>`
///
/// ## RTL
/// ```
/// if (cond)
///   Rn AND shifter_operand
/// ```
///
/// ## Flags updated:
/// `N`, `Z`, `C`
class TST extends ArmInstruction {
  /// `Rn`.
  final int sourceRegister;

  /// `Rd`.
  final int destinationRegister;

  /// 12-bit.
  final int shifterOperand;

  const TST({
    @required int condition,
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
