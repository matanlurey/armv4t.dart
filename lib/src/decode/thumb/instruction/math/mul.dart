part of '../../instruction.dart';

/// Multiply.
///
/// `Rd := Rs * Rd`
///
/// Lo register operand | Hi register operand | Condition codes set
/// ------------------- | ------------------- | -------------------
/// ✔                   | 🗙                   | ✔
class MUL extends ThumbInstruction {
  final int sourceRegister;
  final int destinationRegister;

  const MUL({
    @required this.sourceRegister,
    @required this.destinationRegister,
  }) : super._();
}
