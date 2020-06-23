part of '../../instruction.dart';

/// Compare Negative.
///
/// Sets condition codes on `Rd + Rs`.
///
/// Lo register operand | Hi register operand | Condition codes set
/// ------------------- | ------------------- | -------------------
/// ✔                   | 🗙                   | ✔
class CMN extends ThumbInstruction {
  final int sourceRegister;
  final int destinationRegister;

  const CMN({
    @required this.sourceRegister,
    @required this.destinationRegister,
  }) : super._();
}
