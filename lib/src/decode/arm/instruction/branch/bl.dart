part of '../../instruction.dart';

/// Branch.
///
/// The B/BL instructions are used to branch to a [targetAddress], based on an
/// optional [condition]. The BL instruction supports subroutine calls by
/// storing the next instruction's address in R14, the link register (`LR`).
/// Since the offset value is a 24-bit value, the branch target must be within
/// approximately +/-32Mb.
///
/// ## Syntax
/// `BL{<cond>} <target_address>`
///
/// ## RTL
/// ```
/// if (cond)
///   R14 <- address of next instruction
///   PC <- PC + (signed_immediate_24 << 2)
/// ```
class BL extends ArmInstruction {
  final int targetAddress;

  const BL({
    @required int condition,
    @required this.targetAddress,
  }) : super._(condition);

  @override
  R accept<R, C>(
    ArmInstructionVisitor<R, C> visitor, [
    C context,
  ]) =>
      visitor.visitBL(this, context);
}
