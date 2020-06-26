part of '../../instruction.dart';

/// Bit-wise Inclusive-OR.
///
/// ## Syntax
/// `EOR{<cond>}{S} <Rd>, <Rn>, <shifter_operand>`
///
/// ## RTL
/// ```
/// if (cond)
///   Rd <- Rn OR shifter_operand
/// ```
///
/// ## Flags updated:
/// `N`, `Z`, `C`
class ORR extends ArmInstruction {
  /// `Rn`.
  final int sourceRegister;

  /// `Rd`.
  final int destinationRegister;

  /// 12-bit.
  final int shifterOperand;

  const ORR({
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
      visitor.visitORR(this, context);
}
