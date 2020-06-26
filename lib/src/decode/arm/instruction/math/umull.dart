part of '../../instruction.dart';

/// Unsigned Multiply Long.
///
/// [UMULL] performs an unsigned 32x32 multiply operation. The product of `Rm`
/// and `Rs` is stored as a 64-bit unsigned value in the register pair
/// `Rd_MSW:Rd_LSW`. All values are interpreted as unsigned binary.
///
/// ## Syntax
/// `UMULL{<cond>}{S} <Rd_LSW>, <Rd_MSW>, <Rm>, <Rs>`
///
/// ## RTL
/// ```
/// if (cond)
///   Rd_MSW:Rd_LSW <- Rd_MSW:Rd_LSW + (Rs * Rm)
/// ```
///
/// ## Flags updated if [s] is used:
/// `N`, `Z` (`V`, `C` are unpredictable)
class UMULL extends ArmInstruction {
  /// Whether to set flags on the CPSR.
  final int s;

  final int destinationRegisterMSW;

  final int destinationRegisterLSW;

  final int sourceRegister;

  final int operandRegister;

  const UMULL({
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
      visitor.visitUMULL(this, context);
}
