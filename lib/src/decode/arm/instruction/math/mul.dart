part of '../../instruction.dart';

/// Multiply.
///
/// [MLA] performs a 32x32 multiply operation, and stores a 32-bit result. Since
/// only the least significant 32-bits are stored, the result is the same for
/// both signed and unsigned numbers.
///
/// ## Syntax
/// `MUL{<cond>}{S} <Rd>, <Rm>, <Rs>
///
/// ## RTL
/// ```
/// if (cond)
///   Rd <- Rm * Rs
/// ```
///
/// ## Flags updated if [s] is used:
/// `N`, `Z` (`C` is unpredictable)
class MUL extends ArmInstruction {
  /// Whether to set flags on the CPSR.
  final int s;

  /// `Rn`.
  final int sourceRegister;

  /// `Rd`.
  final int destinationRegister;

  /// `Rs`.
  final int operandRegister;

  const MUL({
    @required int condition,
    @required this.s,
    @required this.sourceRegister,
    @required this.destinationRegister,
    @required this.operandRegister,
  }) : super._(condition);

  @override
  R accept<R, C>(
    ArmInstructionVisitor<R, C> visitor, [
    C context,
  ]) =>
      throw UnimplementedError();
}
