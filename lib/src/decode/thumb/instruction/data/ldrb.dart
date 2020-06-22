part of '../../instruction.dart';

/// Load byte.
///
/// Lo register operand | Hi register operand | Condition codes set
/// ------------------- | ------------------- | -------------------
/// ✔                   | 🗙                   | 🗙
class LDRB extends ThumbInstruction {}
