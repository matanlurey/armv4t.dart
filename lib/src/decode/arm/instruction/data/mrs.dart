part of '../../instruction.dart';

/// Move PSR into General-Purpose Regsiter.
///
/// Moves the value of `CPSR` or the current `SPSR` into a register.
///
/// ## Syntax
/// `MRS{<cond>} <Rd>, {CPSR|SPSR}`
///
/// ## RTL
/// ```
/// if (cond)
///   Rd <- CPSR/SPSR
/// ```
class MRS extends ArmInstruction {
  final int r;

  final int sb0_1;

  final int destinationRegister;

  final int sb0_2;

  const MRS({
    @required int condition,
    @required this.r,
    @required this.sb0_1,
    @required this.destinationRegister,
    @required this.sb0_2,
  }) : super._(condition);

  @override
  R accept<R, C>(
    ArmInstructionVisitor<R, C> visitor, [
    C context,
  ]) =>
      visitor.visitMRS(this, context);
}
