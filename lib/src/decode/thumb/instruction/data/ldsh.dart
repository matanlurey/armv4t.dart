part of '../../instruction.dart';

/// Load sign-extended half-word.
///
/// Adds [offsetRegister] to the base address in [baseRegister]. Loads bits 0-15
/// of [destinationRegister] from the resulting address, and sets bits 16-31 of
/// [destinationRegister] to bit 15.
///
/// Lo register operand | Hi register operand | Condition codes set
/// ------------------- | ------------------- | -------------------
/// ✔                   | 🗙                   | 🗙
class LDSH extends ThumbInstruction {
  final int baseRegister;
  final int offsetRegister;
  final int destinationRegister;

  const LDSH({
    @required this.baseRegister,
    @required this.offsetRegister,
    @required this.destinationRegister,
  }) : super._();

  @override
  R accept<R, C>(
    ThumbInstructionVisitor<R, C> visitor, [
    C context,
  ]) =>
      visitor.visitLDSH(this, context);
}
