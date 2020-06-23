part of '../../instruction.dart';

/// Conditional Branch: Unsigned lower.
///
/// If `C` set.
///
/// Lo register operand | Hi register operand | Condition codes set
/// ------------------- | ------------------- | -------------------
/// ✔                   | 🗙                   | 🗙
class BCC extends ThumbInstruction {
  const BCC() : super._();
}
