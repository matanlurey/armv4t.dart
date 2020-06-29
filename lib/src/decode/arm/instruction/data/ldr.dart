part of '../../instruction.dart';

/// Load Register.
///
/// The [LDR] instruction reads a word from memory and writes it to the
/// [destinationRegister]. If the memory address is not word-aligned, the value
/// read is rotated right by 8 times the value of bits `[1:0]` of the memory
/// address. If `R15` is specified as a destination, the value is laoded from
/// memory and written to the program counter (`PC`), effecting a branch.
///
/// ## Syntax
/// `LDR{<cond>} <Rd>, <addressing_mode>`
///
/// ## RTL
/// ```
/// if (cond)
///   Rd <- memory[memory_address]
///   if (writeback)
///     Rn <- end_address
/// ```
class LDR extends ArmInstruction {
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

  const LDR({
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
      visitor.visitLDR(this, context);
}
