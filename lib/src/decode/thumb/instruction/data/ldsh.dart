part of '../../instruction.dart';

/// Load sign-extended half-word.
///
/// Lo register operand | Hi register operand | Condition codes set
/// ------------------- | ------------------- | -------------------
/// ✔                   | 🗙                   | 🗙
class LDSH extends ThumbInstruction {}
