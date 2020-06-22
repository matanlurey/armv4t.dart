part of '../../instruction.dart';

/// Branch and Exchange.
///
/// Lo register operand | Hi register operand | Condition codes set
/// ------------------- | ------------------- | -------------------
/// ✔                   | ✔                   | 🗙
class BX extends ThumbInstruction {}
