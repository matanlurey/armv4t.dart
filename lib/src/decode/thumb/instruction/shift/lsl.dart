part of '../../instruction.dart';

/// Logical shift left.
///
/// Shifts [soruceRegister] by a 5-bit [immediateValue] and store the result in
/// [destinationRegister].
///
/// Lo register operand | Hi register operand | Condition codes set
/// ------------------- | ------------------- | -------------------
/// ✔                   | 🗙                   | ✔
class LSL extends ThumbInstruction {
  final int destinationRegister;
  final int sourceRegister;
  final int immediateValue;

  const LSL({
    @required this.destinationRegister,
    @required this.sourceRegister,
    @required this.immediateValue,
  }) : super._();
}
