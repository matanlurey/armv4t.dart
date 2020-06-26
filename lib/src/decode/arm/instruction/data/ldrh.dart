part of '../../instruction.dart';

class LDRH extends ArmInstruction {
  const LDRH({
    @required int condition,
  }) : super._(condition);

  @override
  R accept<R, C>(
    ArmInstructionVisitor<R, C> visitor, [
    C context,
  ]) =>
      throw UnimplementedError();
}
