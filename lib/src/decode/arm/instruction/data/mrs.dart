part of '../../instruction.dart';

/// Transfers PSR contents to a Register.
class MRS extends ArmInstruction {
  /// Source `PSR` (`0` = `CPSR`, `1` = `SPSR_{currentMode}`).
  final int sourcePSR;

  /// Destination regsiter.
  final int destinationRegister;

  const MRS({
    @required int condition,
    @required this.sourcePSR,
    @required this.destinationRegister,
  }) : super._(condition);

  @override
  R accept<R, C>(
    ArmInstructionVisitor<R, C> visitor, [
    C context,
  ]) =>
      throw UnimplementedError();
}
