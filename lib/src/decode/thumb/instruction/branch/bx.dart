part of '../../instruction.dart';

/// Branch and Exchange.
///
/// Lo register operand | Hi register operand | Condition codes set
/// ------------------- | ------------------- | -------------------
/// ✔                   | ✔                   | 🗙
abstract class BX extends ThumbInstruction {
  const BX._() : super._();
}

/// A sub-type of [BX].
///
/// Perform branch (plus optional state change) to address in a register in the
/// range 0-7.
class BX$Lo extends BX {
  final int sourceRegister;

  const BX$Lo({@required this.sourceRegister}) : super._();

  @override
  R accept<R, C>(
    ThumbInstructionVisitor<R, C> visitor, [
    C context,
  ]) =>
      visitor.visitBX$Lo(this, context);
}

/// A sub-type of [BX].
///
/// Perform branch (plus optional state change) to address in a register in the
/// range 8-15.
class BX$Hi extends BX {
  final int sourceRegister;

  const BX$Hi({@required this.sourceRegister}) : super._();

  @override
  R accept<R, C>(
    ThumbInstructionVisitor<R, C> visitor, [
    C context,
  ]) =>
      visitor.visitBX$Hi(this, context);
}
