part of '../../instruction.dart';

/// Load Register Signed Halfword.
///
/// The [LDRSH] instruction reads a halfword from memory, and sign-extends it to
/// 32-bits in the regsiter.
///
/// ## Syntax
/// `LDRSH{<cond>} <Rd>, <addressing_mode>`
///
/// ## RTL
/// ```
/// if (cond)
///   Rd[15:0] <- memory[memory_address]
///   Rd[31:16] <- Rd[15] (sign extension)
///   if (writeback)
///     Rn <- end_address
/// ```
class LDRSH extends ArmInstruction {
  final int p;

  final int u;

  final int w;

  final int sourceRegister;

  final int destinationRegister;

  final int addressingMode1;

  final int addressingMode2;

  const LDRSH({
    @required int condition,
    @required this.p,
    @required this.u,
    @required this.w,
    @required this.sourceRegister,
    @required this.destinationRegister,
    @required this.addressingMode1,
    @required this.addressingMode2,
  }) : super._(condition);

  @override
  R accept<R, C>(
    ArmInstructionVisitor<R, C> visitor, [
    C context,
  ]) =>
      visitor.visitLDRSH(this, context);
}
