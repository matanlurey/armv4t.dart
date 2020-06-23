part of '../../instruction.dart';

/// Conditional Branch: Greater than.
///
/// If `Z` clear, and either `N` set and `V` set or `N` clear and `V` clear.
///
/// Lo register operand | Hi register operand | Condition codes set
/// ------------------- | ------------------- | -------------------
/// ✔                   | 🗙                   | 🗙
class BGT extends ThumbInstruction {
  const BGT() : super._();
}
