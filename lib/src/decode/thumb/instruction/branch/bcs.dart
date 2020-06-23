part of '../../instruction.dart';

/// Conditional Branch: Unsigned higher or same.
///
/// If `C` set.
///
/// Lo register operand | Hi register operand | Condition codes set
/// ------------------- | ------------------- | -------------------
/// ✔                   | 🗙                   | 🗙
class BCS extends ThumbInstruction {
  const BCS._() : super._();
}
