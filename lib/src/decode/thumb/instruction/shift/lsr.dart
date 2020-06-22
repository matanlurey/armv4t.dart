part of '../../instruction.dart';

/// Logical Shift Right.
///
/// Perform logical shift right on [sourceRegister] by a 5-bit [immediateValue]
/// and store the result in [destinationRegister].
///
/// Lo register operand | Hi register operand | Condition codes set
/// ------------------- | ------------------- | -------------------
/// ✔                   | 🗙                   | ✔
class LSR extends ThumbInstruction {
  final int destinationRegister;
  final int sourceRegister;
  final int immediateValue;

  const LSR({
    @required this.destinationRegister,
    @required this.sourceRegister,
    @required this.immediateValue,
  }) : super._();
}
