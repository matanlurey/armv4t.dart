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
  /// Immediate offset.
  final int i;

  /// Pre/Post indexing bit.
  final int p;

  /// Up/Down bit.
  final int u;

  /// Write-back bit.
  final int w;

  final int sourceRegister;

  final int destinationRegister;

  /// Addressing mode "2" offset.
  final int addressingMode2Offset;

  const STRB({
    @required int condition,
    @required this.i,
    @required this.p,
    @required this.u,
    @required this.w,
    @required this.sourceRegister,
    @required this.destinationRegister,
    @required this.addressingMode2Offset,
  }) : super._(condition);

  @override
  R accept<R, C>(
    ArmInstructionVisitor<R, C> visitor, [
    C context,
  ]) =>
      visitor.visitSTRB(this, context);
}
