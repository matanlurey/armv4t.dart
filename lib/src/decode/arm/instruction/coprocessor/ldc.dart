part of '../../instruction.dart';

class LDC extends ArmInstruction {
  const LDC({
    @required int condition,
  }) : super._(condition);

  @override
  R accept<R, C>(
    ArmInstructionVisitor<R, C> visitor, [
    C context,
  ]) =>
      throw UnimplementedError();
}
