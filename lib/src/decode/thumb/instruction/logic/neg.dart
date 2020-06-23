part of '../../instruction.dart';

/// Negate.
///
/// `Rd := -Rs`
///
/// Lo register operand | Hi register operand | Condition codes set
/// ------------------- | ------------------- | -------------------
/// ✔                   | 🗙                   | ✔
class NEG extends ThumbInstruction {
  final int sourceRegister;
  final int destinationRegister;

  const NEG({
    @required this.sourceRegister,
    @required this.destinationRegister,
  }) : super._();

  @override
  R accept<R, C>(
    ThumbInstructionVisitor<R, C> visitor, [
    C context,
  ]) =>
      visitor.visitNEG(this, context);
}
