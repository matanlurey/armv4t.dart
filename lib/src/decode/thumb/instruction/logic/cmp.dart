part of '../../instruction.dart';

/// Compare.
///
/// Lo register operand | Hi register operand | Condition codes set
/// ------------------- | ------------------- | -------------------
/// ✔                   | ✔                   | ✔
abstract class CMP extends ThumbInstruction {
  final int destinationRegister;

  const CMP._({
    @required this.destinationRegister,
  }) : super._();
}

/// A sub-type of [CMP].
///
/// Compare contents of [destinationRegister] with 8-bit [immediateValue].
class CMP$MoveCompareAddSubtractImmediate extends CMP {
  final int immediateValue;

  const CMP$MoveCompareAddSubtractImmediate({
    @required this.immediateValue,
    @required int destinationRegister,
  }) : super._(
          destinationRegister: destinationRegister,
        );

  @override
  R accept<R, C>(
    ThumbInstructionVisitor<R, C> visitor, [
    C context,
  ]) =>
      visitor.visitCMP$MoveCompareAddSubtractImmediate(this, context);
}

/// A sub-type of [CMP].
///
/// Sets condition codes on `Rd - Rs`.
class CMP$ALU extends CMP {
  final int sourceRegister;

  const CMP$ALU({
    @required this.sourceRegister,
    @required int destinationRegister,
  }) : super._(
          destinationRegister: destinationRegister,
        );

  @override
  R accept<R, C>(
    ThumbInstructionVisitor<R, C> visitor, [
    C context,
  ]) =>
      visitor.visitCMP$ALU(this, context);
}

/// A sub-type of [CMP].
///
/// Compare a register in the range 0-7 with a register in the range 8-15. Sets
/// the condition code flags on the result.
class CMP$HiToLo extends CMP {
  final int sourceRegister;

  const CMP$HiToLo({
    @required int destinationRegister,
    @required this.sourceRegister,
  }) : super._(
          destinationRegister: destinationRegister,
        );

  @override
  R accept<R, C>(
    ThumbInstructionVisitor<R, C> visitor, [
    C context,
  ]) =>
      visitor.visitCMP$HiToLo(this, context);
}

/// A sub-type of [CMP].
///
/// Compare a register in the range 8-15 with a register in the range 0-7. Sets
/// the condition code flags on the result.
class CMP$LoToHi extends CMP {
  final int sourceRegister;

  const CMP$LoToHi({
    @required this.sourceRegister,
    @required int destinationRegister,
  }) : super._(
          destinationRegister: destinationRegister,
        );

  @override
  R accept<R, C>(
    ThumbInstructionVisitor<R, C> visitor, [
    C context,
  ]) =>
      visitor.visitCMP$LoToHi(this, context);
}

/// A sub-type of [CMP].
///
/// Compares two registers in the range 8-15. Sets the condition flags on the
/// result.
class CMP$HiToHi extends CMP {
  final int sourceRegister;

  const CMP$HiToHi({
    @required this.sourceRegister,
    @required int destinationRegister,
  }) : super._(
          destinationRegister: destinationRegister,
        );

  @override
  R accept<R, C>(
    ThumbInstructionVisitor<R, C> visitor, [
    C context,
  ]) =>
      visitor.visitCMP$HiToHi(this, context);
}
