part of '../../instruction.dart';

/// Load half-word.
///
/// Lo register operand | Hi register operand | Condition codes set
/// ------------------- | ------------------- | -------------------
/// ✔                   | 🗙                   | 🗙
class LDRH extends ThumbInstruction {}
