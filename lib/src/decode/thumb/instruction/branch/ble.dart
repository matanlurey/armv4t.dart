part of '../../instruction.dart';

/// Conditional Branch: Less than or equal.
///
/// If `Z` set, or `N` set and `V` clear, or `N` clear and `V` set.
///
/// Lo register operand | Hi register operand | Condition codes set
/// ------------------- | ------------------- | -------------------
/// ✔                   | 🗙                   | 🗙
class BLE extends ThumbInstruction {
  const BLE() : super._();
}
