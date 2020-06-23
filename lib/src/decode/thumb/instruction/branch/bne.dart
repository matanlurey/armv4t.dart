part of '../../instruction.dart';

/// Conditional Branch: Not equal.
///
/// If `Z` clear.
///
/// Lo register operand | Hi register operand | Condition codes set
/// ------------------- | ------------------- | -------------------
/// ✔                   | 🗙                   | 🗙
class BNE extends ThumbInstruction {
  const BNE() : super._();
}
