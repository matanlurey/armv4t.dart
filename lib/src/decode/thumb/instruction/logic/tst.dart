part of '../../instruction.dart';

/// Test bits.
///
/// Sets conditions codees on [destinationRegister] and [sourceRegister].
///
/// Lo register operand | Hi register operand | Condition codes set
/// ------------------- | ------------------- | -------------------
/// ✔                   | 🗙                   | ✔
class TST extends ThumbInstruction {
  final int sourceRegister;
  final int destinationRegister;

  const TST({
    @required this.sourceRegister,
    @required this.destinationRegister,
  }) : super._();

  @override
  R accept<R, C>(
    ThumbInstructionVisitor<R, C> visitor, [
    C context,
  ]) =>
      visitor.visitTST(this, context);
}
