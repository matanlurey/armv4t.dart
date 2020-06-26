part of '../../instruction.dart';

/// Move.
class MOV extends ArmInstruction {
  final int s;
  final int destinationRegister;
  final int operand2;

  const MOV({
    @required int condition,
    @required this.s,
    @required this.destinationRegister,
    @required this.operand2,
  }) : super._(condition);

  @override
  R accept<R, C>(
    ArmInstructionVisitor<R, C> visitor, [
    C context,
  ]) =>
      throw UnimplementedError();
}
