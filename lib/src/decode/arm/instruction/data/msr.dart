part of '../../instruction.dart';

/// Move to Status Register from ARM Register
///
/// Moves the value of a regsiter or immediate operand into the `CPSR` or the
/// current `SPSR`. This instruction is typically used by supervisory mode code.
///
/// The [fieldMask] indicates which fields of the CPSR/SPSR be written to should
/// be allowed to be changed. This limits any changes to just the fields
/// intended by the programmer. The allowed fields are:
///
/// - `c` - Sets the control field mask bit (bit 16).
/// - `x` - Sets the extension field mask bit (bit 17).
/// - `s` - Sets the status field mask bit (bit 18).
/// - `f` - Sets the flags field mask bit (bit 19).
///
/// One or more fields may be specified.
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
  final int r;

  final int fieldMask;

  final int sb0;

  final int rorateImmOrSbZ;

  final int immediateOrRegister;

  const MSR({
    @required int condition,
    @required this.r,
    @required this.fieldMask,
    @required this.sb0,
    @required this.rorateImmOrSbZ,
    @required this.immediateOrRegister,
  }) : super._(condition);

  @override
  R accept<R, C>(
    ArmInstructionVisitor<R, C> visitor, [
    C context,
  ]) =>
      visitor.visitMSR(this, context);
}
