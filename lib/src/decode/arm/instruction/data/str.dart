part of '../../instruction.dart';

/// Store Register.
///
/// The [STR] instruction stores a single register to memroy.
///
/// ## Syntax
/// `STR{<cond>} <Rd>, <addressing_mode>`
///
/// ## RTL
/// ```
/// if (cond)
///   memory[memory_address] <- Rd
///   if (writeback)
///     Rn <- end_address
/// ```
class STR extends ArmInstruction {
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

  const STR({
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
      visitor.visitSTR(this, context);
}
