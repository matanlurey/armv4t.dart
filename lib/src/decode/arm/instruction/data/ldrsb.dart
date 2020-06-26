part of '../../instruction.dart';

class LDRSB extends ArmInstruction {
  const LDRSB({
    @required int condition,
  }) : super._(condition);

  @override
  R accept<R, C>(
    ArmInstructionVisitor<R, C> visitor, [
    C context,
  ]) =>
      throw UnimplementedError();
}
