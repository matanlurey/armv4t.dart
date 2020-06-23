part of '../../instruction.dart';

/// Conditional Branch: Equal.
///
/// If `Z` set.
///
/// Lo register operand | Hi register operand | Condition codes set
/// ------------------- | ------------------- | -------------------
/// ✔                   | 🗙                   | 🗙
class BEQ extends ThumbInstruction {
  const BEQ() : super._();
}
