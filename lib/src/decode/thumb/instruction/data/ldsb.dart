part of '../../instruction.dart';

/// Load sign-extended byte.
///
/// Add [offsetRegister] to the base address in [baseRegister]. Load bits 0-7
/// of [destinationRegister] from the reuslting address, and sets bits 8-31 of
/// [destinationRegister] to bit 7.
///
/// Lo register operand | Hi register operand | Condition codes set
/// ------------------- | ------------------- | -------------------
/// ✔                   | 🗙                   | 🗙
class LDSB extends ThumbInstruction {
  final int baseRegister;
  final int offsetRegister;
  final int destinationRegister;

  const LDSB({
    @required this.baseRegister,
    @required this.offsetRegister,
    @required this.destinationRegister,
  }) : super._();
}
