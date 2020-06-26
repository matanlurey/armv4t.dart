part of '../../instruction.dart';

class CDP extends ArmInstruction {
  const CDP({
    @required int condition,
  }) : super._(condition);

  @override
  R accept<R, C>(
    ArmInstructionVisitor<R, C> visitor, [
    C context,
  ]) =>
      throw UnimplementedError();
}
