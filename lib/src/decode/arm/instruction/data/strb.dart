part of '../../instruction.dart';

/// Store Register Byte.
///
/// The [STRB] instruction stores the least significant byte of a regsiter to
/// memory.
///
/// ## Syntax
/// `STRB{<cond>} <Rd>, <addressing_mode>`
///
/// ## RTL
/// ```
/// if (cond)
///   memory[memory_address] <- Rd[15:0]
///   if (writeback)
///     Rn <- end_address
/// ```
class STRB extends ArmInstruction {
  final int p;

  final int u;

  final int w;

  final int sourceRegister;

  final int destinationRegister;

  final int addressingMode;

  const STRB({
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
