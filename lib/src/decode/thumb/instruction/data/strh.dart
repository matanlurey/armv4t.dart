part of '../../instruction.dart';

/// Store halfword.
///
/// Lo register operand | Hi register operand | Condition codes set
/// ------------------- | ------------------- | -------------------
/// ✔                   | 🗙                   | 🗙
class STRH extends ThumbInstruction {}
