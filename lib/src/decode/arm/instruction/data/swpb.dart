part of '../../instruction.dart';

/// Swap Byte.
///
/// The [SWPB] instruction excahnges a single byte between a register and
/// memory. This instruction is intended to support semaphore manipulation by
/// completing the transfers as a single, atomic operation.
///
/// ## Syntax
/// `SWPB{<cond>} <Rd>, <Rm>, [<Rn>]`
///
/// ## RTL
/// ```
/// if (cond)
///   temp <- [Rn]
///   [Rn] <- Rm
///   Rd <- temp
/// ```
class SWPB extends ArmInstruction {
  final int sourceRegister1;

  final int destinationRegister;

  final int sourceRegister2;

  const SWPB({
    @required int condition,
    @required this.sourceRegister1,
    @required this.destinationRegister,
    @required this.sourceRegister2,
  }) : super._(condition);

  @override
  R accept<R, C>(
    ArmInstructionVisitor<R, C> visitor, [
    C context,
  ]) =>
      visitor.visitSWPB(this, context);
}
