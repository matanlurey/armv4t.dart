part of '../../instruction.dart';

/// Add.
///
/// Lo register operand | Hi register operand | Condition codes set
/// ------------------- | ------------------- | -------------------
/// ✔                   | ✔                   | ✔
///
/// `Rd := Rn + Op2`.
class ADD extends ThumbInstruction {}
