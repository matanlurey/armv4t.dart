part of '../../instruction.dart';

class LDM extends ArmInstruction {
  const LDM({
    @required int condition,
  }) : super._(condition);

  @override
  R accept<R, C>(
    ArmInstructionVisitor<R, C> visitor, [
    C context,
  ]) =>
      throw UnimplementedError();
}
