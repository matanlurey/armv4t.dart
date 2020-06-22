part of '../../instruction.dart';

/// Arithmetic Shift Right.
///
/// Performs arithmetic shift right on [sourceRegister] by a 5-bit
/// [immediateValue] and stores the result in [destinationRegister].
///
/// Lo register operand | Hi register operand | Condition codes set
/// ------------------- | ------------------- | -------------------
/// ✔                   | 🗙                   | ✔
class ASR extends ThumbInstruction {
  final int destinationRegister;
  final int sourceRegister;
  final int immediateValue;

  const ASR({
    @required this.destinationRegister,
    @required this.sourceRegister,
    @required this.immediateValue,
  }) : super._();
}
