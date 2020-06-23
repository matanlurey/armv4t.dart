part of '../../instruction.dart';

/// Load multiple.
///
/// Loads the registers specified by [registerList], starting at the base
/// address in [baseRegister]. Write back the new base address.
///
/// Lo register operand | Hi register operand | Condition codes set
/// ------------------- | ------------------- | -------------------
/// ✔                   | 🗙                   | 🗙
class LDMIA extends ThumbInstruction {
  final int baseRegister;
  final int registerList;

  const LDMIA({
    @required this.baseRegister,
    @required this.registerList,
  }) : super._();
}
