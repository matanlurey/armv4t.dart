part of '../../instruction.dart';

/// Conditional Branch: Less than.
///
/// If `N` set and `V` clear, or `N` clear and `V` set.
///
/// Lo register operand | Hi register operand | Condition codes set
/// ------------------- | ------------------- | -------------------
/// ✔                   | 🗙                   | 🗙
class BLT extends ThumbInstruction {
  const BLT() : super._();
}
