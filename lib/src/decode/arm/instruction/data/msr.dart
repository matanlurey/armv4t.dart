part of '../../instruction.dart';

/// Move to Status Register from ARM Register
///
/// Moves the value of a regsiter or immediate operand into the `CPSR` or the
/// current `SPSR`. This instruction is typically used by supervisory mode code.
///
/// ## Syntax
/// `MRS{<cond>} CPSR|SPSR_<fields>, <Rm>|#<immediate>`
///
/// ## RTL
/// ```
/// if (cond)
///   CPSR/SPSR <- immediate/register value
/// ```
class MSR extends ArmInstruction {
  /// `0` = [sourceOperand] is a register, `1` = immediate unsigned 8-bit value.
  final int immediateOperand;

  /// `0` = CPSR, `1` = SPSR_<current mode>.
  final int destinationPSR;

  /// Determines what fields of the CPSR/SPSR should be allowed to be changed.
  final int fieldMask;

  /// See [immediateOperand] for details.
  final int sourceOperand;

  const MSR({
    @required int condition,
    @required this.immediateOperand,
    @required this.destinationPSR,
    @required this.fieldMask,
    @required this.sourceOperand,
  }) : super._(condition);

  @override
  R accept<R, C>(
    ArmInstructionVisitor<R, C> visitor, [
    C context,
  ]) =>
      visitor.visitMSR(this, context);
}
