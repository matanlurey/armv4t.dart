part of '../../instruction.dart';

/// Add with carry.
///
/// `Rd := Rn + Op2 + Carry`.
///
/// Lo register operand | Hi register operand | Condition codes set
/// ------------------- | ------------------- | -------------------
/// ✔                   | 🗙                   | ✔
class ADC extends ThumbInstruction {
  final int sourceRegister;
  final int destinationRegister;

  const ADC({
    @required this.sourceRegister,
    @required this.destinationRegister,
  }) : super._();
}
