part of '../../instruction.dart';

/// Conditional Branch: Unsigned higher.
///
/// If `C` set and `Z` clear.
///
/// Lo register operand | Hi register operand | Condition codes set
/// ------------------- | ------------------- | -------------------
/// ✔                   | 🗙                   | 🗙
class BHI extends ThumbInstruction {
  const BHI() : super._();
}
