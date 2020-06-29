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

  final int i;

  final int w;

  final int baseRegister;

  final int destinationRegister;

  final int addressingMode2HighNibble;

  final int addressingMode2LowNibble;

  const STRH({
    @required int condition,
    @required this.p,
    @required this.u,
    @required this.i,
    @required this.w,
    @required this.baseRegister,
    @required this.destinationRegister,
    @required this.addressingMode2HighNibble,
    @required this.addressingMode2LowNibble,
  }) : super._(condition);

  @override
  R accept<R, C>(
    ArmInstructionVisitor<R, C> visitor, [
    C context,
  ]) =>
      visitor.visitSTRH(this, context);
}
