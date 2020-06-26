part of '../../instruction.dart';

/// Store Register Half-word.
///
/// The [STRH] instruction stores the least significant half-word (2 bytes) of
/// a regsiter to memory.
///
/// ## Syntax
/// `STRH{<cond>} <Rd>, <addressing_mode>`
///
/// ## RTL
/// ```
/// if (cond)
///   memory[memory_address] <- Rd[15:0]
///   if (writeback)
///     Rn <- end_address
/// ```
class STRH extends ArmInstruction {
  final int p;

  final int u;

  final int w;

  final int sourceRegister;

  final int destinationRegister;

  final int addressingMode;

  const STRH({
    @required int condition,
    @required this.p,
    @required this.u,
    @required this.w,
    @required this.sourceRegister,
    @required this.destinationRegister,
    @required this.addressingMode,
  }) : super._(condition);

  @override
  R accept<R, C>(
    ArmInstructionVisitor<R, C> visitor, [
    C context,
  ]) =>
      visitor.visitSTRH(this, context);
}
