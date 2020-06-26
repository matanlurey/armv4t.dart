part of '../../instruction.dart';

/// Load Register Half-Word.
///
/// The [LDRH] instruction reads a halfword from memory, and zero-extends it to
/// 32-bits in the register.
///
/// ## Syntax
/// `LDRH{<cond>} <Rd>, <addressing_mode>`
///
/// ## RTL
/// ```
/// if (cond)
///   Rd[15:0] <- memory[memory_address], Rd[31:16] <- 0
///   if (writeback)
///     Rn <- end_address
/// ```
class LDRH extends ArmInstruction {
  final int p;

  final int u;

  final int w;

  final int sourceRegister;

  final int destinationRegister;

  final int addressingMode;

  const LDRH({
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
      throw UnimplementedError();
}
