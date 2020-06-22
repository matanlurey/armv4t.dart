part of '../../instruction.dart';

/// Add with carry.
///
/// Lo register operand | Hi register operand | Condition codes set
/// ------------------- | ------------------- | -------------------
/// ✔                   | 🗙                   | ✔
///
/// `Rd := Rn + Op2 + Carry`.
class ADC extends ThumbInstruction {}
