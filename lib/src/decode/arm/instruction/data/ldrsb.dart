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

  final int w;

  final int sourceRegister;

  final int destinationRegister;

  final int addressingMode1;

  final int addressingMode2;

  const LDRSB({
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
      throw UnimplementedError();
}
