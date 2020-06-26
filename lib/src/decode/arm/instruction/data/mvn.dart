part of '../../instruction.dart';

/// Move Negative.
///
/// [MVN] complements the value of a regsiter or an immediate value and stores
/// it in the destination register.
///
/// ## Syntax
/// `MVN{<cond>}{S} <Rd>, <shifter_operand>`
///
/// ## RTL
/// ```
/// if (cond)
///   Rd <- NOT shifter_operand
///   if (S == 1 and Rd == 15)
///     CPSR <- SPSR
/// ```
///
/// ## Flags updated if [s] is used and [destinationRegister] is not `R15`:
/// `N`, `Z`, `C`
class MVN extends ArmInstruction {
  /// Whether [shifterOperand] is an immediate value (not a register).
  final int i;

  /// Whether to set flags on the CPSR.
  final int s;

  /// `Rd`.
  final int destinationRegister;

  /// 12-bit.
  final int shifterOperand;

  const MVN({
    @required int condition,
    @required this.i,
    @required this.s,
    @required this.destinationRegister,
    @required this.shifterOperand,
  }) : super._(condition);

  @override
  R accept<R, C>(
    ArmInstructionVisitor<R, C> visitor, [
    C context,
  ]) =>
      visitor.visitMVN(this, context);
}
