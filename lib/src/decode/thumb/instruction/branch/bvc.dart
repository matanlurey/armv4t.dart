part of '../../instruction.dart';

/// Conditional Branch: No overflow.
///
/// If `V` clear.
///
/// Lo register operand | Hi register operand | Condition codes set
/// ------------------- | ------------------- | -------------------
/// ✔                   | 🗙                   | 🗙
class BVC extends ThumbInstruction {
  const BVC() : super._();
}
