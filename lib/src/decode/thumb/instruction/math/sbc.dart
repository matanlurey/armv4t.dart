part of '../../instruction.dart';

/// Subtract with Carry.
///
/// `Rd := Rd - Rs - NOT Carry`
///
/// Lo register operand | Hi register operand | Condition codes set
/// ------------------- | ------------------- | -------------------
/// ✔                   | 🗙                   | ✔
class SBC extends ThumbInstruction {
  final int sourceRegister;
  final int destinationRegister;

  const SBC({
    @required this.sourceRegister,
    @required this.destinationRegister,
  }) : super._();
}
