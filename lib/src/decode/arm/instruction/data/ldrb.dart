part of '../../instruction.dart';

/// Load Register Byte.
///
/// The [LDRB] instruction reads a byte from memory and zero-extends it into the
/// destination register.
///
/// ## Syntax
/// `LDRB{<cond>} <Rd>, <addressing_mode>`
///
/// ## RTL
/// ```
/// if (cond)
///   Rd[7:0] <- memory[memory_address], Rd[31:8] <- 0
///   if (writeback)
///     Rn <- end_address
/// ```
class LDRB extends ArmInstruction {
  final int p;

  final int u;

  final int w;

  final int sourceRegister;

  final int destinationRegister;

  final int addressingMode;

  const LDRB({
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
