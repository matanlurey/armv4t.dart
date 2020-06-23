part of '../../instruction.dart';

/// Conditional Branch: Greater or equal.
///
/// If `N` set and `V` set, or `N` clear and `V` clear
///
/// Lo register operand | Hi register operand | Condition codes set
/// ------------------- | ------------------- | -------------------
/// ✔                   | 🗙                   | 🗙
class BGE extends ThumbInstruction {
  const BGE() : super._();
}
