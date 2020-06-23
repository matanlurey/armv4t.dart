part of '../../instruction.dart';

/// Conditional Branch: Negative.
///
/// Uf `N` set.
///
/// Lo register operand | Hi register operand | Condition codes set
/// ------------------- | ------------------- | -------------------
/// ✔                   | 🗙                   | 🗙
class BMI extends ThumbInstruction {
  const BMI() : super._();
}
