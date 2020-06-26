part of '../../instruction.dart';

/// Unsigned Multiply-Accumulate Long.
///
/// [UMLAL] performs an unsigned 32x32 multiply operation with a 64-bit
/// accumulation. The result of `Rm` and `Rs` is added to the 64-bit unsigned
/// value contain in the register pair `Rd_MSW:Rd_LSW`. All values are
/// interppreted as unsigned binary.
///
/// ## Syntax
/// `UMLAL{<cond>}{S} <Rd_LSW>, <Rd_MSW>, <Rm>, <Rs>`
///
/// ## RTL
/// ```
/// if (cond)
///   Rd_MSW:Rd_LSW <- Rd_MSW:Rd_LSW + (Rs * Rm)
/// ```
///
/// ## Flags updated if [s] is used:
/// `N`, `Z` (`V`, `C` are unpredictable)
class UMLAL extends ArmInstruction {
  /// Whether to set flags on the CPSR.
  final int s;

  final int destinationRegisterMSW;

  final int destinationRegisterLSW;

  final int sourceRegister;

  final int operandRegister;

  const UMLAL({
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
      visitor.visitUMLAL(this, context);
}
