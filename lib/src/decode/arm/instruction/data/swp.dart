part of '../../instruction.dart';

/// Swap.
///
/// The [SWP] instruction exchanges a word between a register and memory. This
/// instruction is intended to support sempahore manipulation by completing the
/// transfers as a single, atomic operation.
///
/// ## Syntax
/// `SWP{<cond>} <Rd>, <Rm>, [<Rn>]`
///
/// ## RTL
/// ```
/// if (cond)
///   temp <- [Rn]
///   [Rn] <- Rm
///   Rd <- temp
/// ```
class SWP extends ArmInstruction {
  final int sourceRegister1;

  final int destinationRegister;

  final int sbZ;

  final int sourceRegister2;

  const SWP({
    @required int condition,
    @required this.sourceRegister1,
    @required this.destinationRegister,
    @required this.sbZ,
    @required this.sourceRegister2,
  }) : super._(condition);

  @override
  R accept<R, C>(
    ArmInstructionVisitor<R, C> visitor, [
    C context,
  ]) =>
      visitor.visitSWP(this, context);
}
