part of '../../instruction.dart';

/// Signed Multiply-Accumulate Long.
///
/// [SMLAL] performs a signed 32x32 multiply operation with a 64-bit
/// accumulation. The product of `Rm` and `Rs` is added to the 64-bit signed
/// value contained in the register pair `Rd_MSW:Rd_LSW`. All values are
/// interpreted as 2's complement.
///
/// ## Syntax
/// `SMLAL{<cond>}{S} <Rd_LSW>, <Rd_MSW>, <Rm>, <Rs>`
///
/// ## RTL
/// ```
/// if (cond)
///   Rd_MSW:Rd_LSW <- Rd_MSW:Rd_LSW + (Rs * Rm)
/// ```
///
/// ## Flags updated if [s] is used:
/// `N`, `Z` (`V`, `C` are unpredictable)
class SMLAL extends ArmInstruction {
  /// Whether to set flags on the CPSR.
  final int s;

  final int destinationRegisterMSW;

  final int destinationRegisterLSW;

  final int sourceRegister;

  final int operandRegister;

  const SMLAL({
    @required int condition,
    @required this.s,
    @required this.destinationRegisterMSW,
    @required this.destinationRegisterLSW,
    @required this.sourceRegister,
    @required this.operandRegister,
  }) : super._(condition);

  @override
  R accept<R, C>(
    ArmInstructionVisitor<R, C> visitor, [
    C context,
  ]) =>
      throw UnimplementedError();
}
