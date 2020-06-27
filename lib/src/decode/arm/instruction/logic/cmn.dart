part of '../../instruction.dart';

/// Compare Negative.
///
/// The [CMN] instruction performs an addition of the operands (equivalent to a
/// subtraction of the negative), but does not store the result. The flags are
/// _always updated_.
///
/// ## Syntax
/// `CMN{<cond>} <Rd>, <Rn>, <shifter_operand>`
///
/// ## RTL
/// ```
/// if (cond)
///   Rn + shifter_operand
/// ```
///
/// ## Flags updated:
/// `N`, `Z`, `V`, `C`
class CMN extends ArmInstruction {
  /// Whether [shifterOperand] is an immediate vlaue.
  final int i;

  /// `Rn`.
  final int sourceRegister;

  /// `Rd`.
  final int destinationRegister;

  /// 12-bit.
  final int shifterOperand;

  const CMN({
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
      visitor.visitCMN(this, context);
}
