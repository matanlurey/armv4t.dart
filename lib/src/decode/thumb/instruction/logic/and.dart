part of '../../instruction.dart';

/// Bitwise AND.
///
/// `Rd := Rn AND Op2`.
///
/// Lo register operand | Hi register operand | Condition codes set
/// ------------------- | ------------------- | -------------------
/// ✔                   | 🗙                   | ✔
class AND extends ThumbInstruction {
  final int sourceRegister;
  final int destinationRegister;

  const AND({
    @required this.sourceRegister,
    @required this.destinationRegister,
  }) : super._();
}
