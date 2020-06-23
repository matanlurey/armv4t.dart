part of '../../instruction.dart';

/// Move Negative Register.
///
/// `Rd := NOT Rs`
///
/// Lo register operand | Hi register operand | Condition codes set
/// ------------------- | ------------------- | -------------------
/// ✔                   | 🗙                   | ✔
class MVN extends ThumbInstruction {
  final int sourceRegister;
  final int destinationRegister;

  const MVN({
    @required this.sourceRegister,
    @required this.destinationRegister,
  }) : super._();

  @override
  R accept<R, C>(
    ThumbInstructionVisitor<R, C> visitor, [
    C context,
  ]) =>
      visitor.visitMVN(this, context);
}
