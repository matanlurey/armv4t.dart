part of '../../instruction.dart';

/// Conditional Branch: Unsigned lower or same.
///
/// If `C` clear or `Z` set.
///
/// Lo register operand | Hi register operand | Condition codes set
/// ------------------- | ------------------- | -------------------
/// ✔                   | 🗙                   | 🗙
class BLS extends ThumbInstruction {
  const BLS() : super._();
}
