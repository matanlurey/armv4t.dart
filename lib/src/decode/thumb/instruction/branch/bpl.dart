part of '../../instruction.dart';

/// Conditional Branch: Positive or zero.
///
/// If `N` clear.
///
/// Lo register operand | Hi register operand | Condition codes set
/// ------------------- | ------------------- | -------------------
/// ✔                   | 🗙                   | 🗙
class BPL extends ThumbInstruction {
  const BPL() : super._();
}
