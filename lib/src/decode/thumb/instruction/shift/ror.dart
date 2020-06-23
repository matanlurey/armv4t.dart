part of '../../instruction.dart';

/// Rotate Right.
///
/// `Rd := Rd ROR Rs`
///
/// Lo register operand | Hi register operand | Condition codes set
/// ------------------- | ------------------- | -------------------
/// ✔                   | 🗙                   | ✔
class ROR extends ThumbInstruction {
  final int sourceRegister;
  final int destinationRegister;

  const ROR({
    @required this.sourceRegister,
    @required this.destinationRegister,
  }) : super._();
}
