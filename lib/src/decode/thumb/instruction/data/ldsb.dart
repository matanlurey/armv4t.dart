part of '../../instruction.dart';

/// Load sign-extended byte.
///
/// Lo register operand | Hi register operand | Condition codes set
/// ------------------- | ------------------- | -------------------
/// ✔                   | 🗙                   | 🗙
class LDSB extends ThumbInstruction {}
