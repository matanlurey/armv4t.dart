part of '../../instruction.dart';

/// Load Register Signed Byte.
///
/// The [LDRSB] instruction reads a byte from memory, and sign-extends it to
/// 32-bits in the regsiter.
///
/// ## Syntax
/// `LDRSB{<cond>} <Rd>, <addressing_mode>`
///
/// ## RTL
/// ```
/// if (cond)
///   Rd[7:0] <- memory[memory_address]
///   Rd[31:8] <- Rd[7] (sign-extension)
///   if (writeback)
///     Rn <- end_address
/// ```
class LDRSB extends ArmInstruction {
  final int p;

  final int u;

  final int i;

  final int w;

  final int baseRegister;

  final int sourceRegister;

  final int addressingMode2HighNibble;

  final int addressingMode2LowNibble;

  const LDRSB({
    @required int condition,
    @required this.p,
    @required this.u,
    @required this.i,
    @required this.w,
    @required this.baseRegister,
    @required this.sourceRegister,
    @required this.addressingMode2HighNibble,
    @required this.addressingMode2LowNibble,
  }) : super._(condition);

  @override
  R accept<R, C>(
    ArmInstructionVisitor<R, C> visitor, [
    C context,
  ]) =>
      visitor.visitLDRSB(this, context);
}
