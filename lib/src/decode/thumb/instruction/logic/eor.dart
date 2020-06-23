part of '../../instruction.dart';

/// EOR (Exlusive OR, or XOR).
///
/// `Rd := Rd EOR Rs`
///
/// Lo register operand | Hi register operand | Condition codes set
/// ------------------- | ------------------- | -------------------
/// ✔                   | 🗙                   | ✔
class EOR extends ThumbInstruction {
  final int sourceRegister;
  final int destinationRegister;

  const EOR({
    @required this.sourceRegister,
    @required this.destinationRegister,
  }) : super._();
}
