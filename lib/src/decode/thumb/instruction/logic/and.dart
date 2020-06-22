part of '../../instruction.dart';

/// Bitwise AND.
///
/// Lo register operand | Hi register operand | Condition codes set
/// ------------------- | ------------------- | -------------------
/// ✔                   | 🗙                   | ✔
///
/// `Rd := Rn AND Op2`.
class AND extends ThumbInstruction {}
