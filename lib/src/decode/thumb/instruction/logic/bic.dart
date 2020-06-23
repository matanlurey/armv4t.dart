part of '../../instruction.dart';

/// Bit Clear.
///
/// `Rd := Rd AND NOT Rs`
///
/// Lo register operand | Hi register operand | Condition codes set
/// ------------------- | ------------------- | -------------------
/// ✔                   | 🗙                   | ✔
class BIC extends ThumbInstruction {
  final int sourceRegister;
  final int destinationRegister;

  const BIC({
    @required this.sourceRegister,
    @required this.destinationRegister,
  }) : super._();
}
