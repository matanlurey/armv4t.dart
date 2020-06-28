part of '../../instruction.dart';

/// Multiply-Accumulate.
///
/// [MLA] performs a 32x32 multiply operation, then stores the sum of
/// [sourceRegister] (`Rn`) and the 32-bit multiplication result to
/// [destinationRegister] (`Rd`). Since only the least significant 32-bits of
/// the multiplication are used, the result is the same for signed and unsigned
/// numbers.
///
/// ## Syntax
/// `MLA{<cond>}{S} <Rd>, <Rm>, <Rs>, <Rn>`
///
/// ## RTL
/// ```
/// if (cond)
///   Rd <- Rn + (Rs * Rm)
/// ```
///
/// ## Flags updated if [s] is used:
/// `N`, `Z` (`C` is unpredictable)
class MLA extends ArmInstruction {
  /// Whether to set flags on the CPSR.
  final int s;

  /// `Rn`.
  final int sourceRegister;

  /// `Rd`.
  final int destinationRegister;

  /// `Rs`.
  final int operandRegister1;

  /// `Rm`.
  final int operandRegister2;

  const MLA({
    @required int condition,
    @required this.s,
    @required this.sourceRegister,
    @required this.destinationRegister,
    @required this.operandRegister1,
    @required this.operandRegister2,
  }) : super._(condition);

  @override
  R accept<R, C>(
    ArmInstructionVisitor<R, C> visitor, [
    C context,
  ]) =>
      visitor.visitMLA(this, context);
}
