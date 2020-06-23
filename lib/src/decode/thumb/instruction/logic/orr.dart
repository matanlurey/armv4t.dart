part of '../../instruction.dart';

/// Binary OR.
///
/// `Rd := Rd OR Rs`
///
/// Lo register operand | Hi register operand | Condition codes set
/// ------------------- | ------------------- | -------------------
/// ✔                   | 🗙                   | ✔
class ORR extends ThumbInstruction {
  final int sourceRegister;
  final int destinationRegister;

  const ORR({
    @required this.sourceRegister,
    @required this.destinationRegister,
  }) : super._();

  @override
  R accept<R, C>(
    ThumbInstructionVisitor<R, C> visitor, [
    C context,
  ]) =>
      visitor.visitORR(this, context);
}
