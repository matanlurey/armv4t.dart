part of '../../instruction.dart';

/// Conditional Branch: Overflow.
///
/// If `V` set.
///
/// Lo register operand | Hi register operand | Condition codes set
/// ------------------- | ------------------- | -------------------
/// ✔                   | 🗙                   | 🗙
class BVS extends ThumbInstruction {
  const BVS() : super._();
}
