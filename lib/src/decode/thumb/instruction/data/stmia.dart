part of '../../instruction.dart';

/// Store Multiple.
///
/// Store the registers specified by [registerList], starting at the base
/// address in [baseRegister]. Write back the new base address.
///
/// Lo register operand | Hi register operand | Condition codes set
/// ------------------- | ------------------- | -------------------
/// ✔                   | 🗙                   | 🗙
class STMIA extends ThumbInstruction {
  final int baseRegister;
  final int registerList;

  const STMIA({
    @required this.baseRegister,
    @required this.registerList,
  }) : super._();

  @override
  R accept<R, C>(
    ThumbInstructionVisitor<R, C> visitor, [
    C context,
  ]) =>
      visitor.visitSTMIA(this, context);
}
