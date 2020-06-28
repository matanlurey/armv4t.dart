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
  /// `0` = CPSR, `1` = SPSR_<current mode>.
  final int sourcePSR;
  final int destinationRegister;

  const MRS({
    @required int condition,
    @required this.sourcePSR,
    @required this.destinationRegister,
  }) : super._(condition);

  @override
  R accept<R, C>(
    ArmInstructionVisitor<R, C> visitor, [
    C context,
  ]) =>
      visitor.visitMRS(this, context);
}
