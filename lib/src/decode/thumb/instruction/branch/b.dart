part of '../../instruction.dart';

/// Unconditional Branch.
///
/// Lo register operand | Hi register operand | Condition codes set
/// ------------------- | ------------------- | -------------------
/// ✔                   | 🗙                   | 🗙
class B extends ThumbInstruction {}
