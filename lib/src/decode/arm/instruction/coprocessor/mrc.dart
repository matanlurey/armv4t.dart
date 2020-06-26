part of '../../instruction.dart';

class MRC extends ArmInstruction {
  const MRC({
    @required int condition,
  }) : super._(condition);

  @override
  R accept<R, C>(
    ArmInstructionVisitor<R, C> visitor, [
    C context,
  ]) =>
      visitor.visitMRC(this, context);
}
