part of '../../instruction.dart';

/// Unconditional Branch.
///
/// Branch program counter (`PC`) relative +/- [immdediateValue] << 1, where
/// label is program conter (`PC`) +/- 2048 bytes.
///
/// Lo register operand | Hi register operand | Condition codes set
/// ------------------- | ------------------- | -------------------
/// ✔                   | 🗙                   | 🗙
class B extends ThumbInstruction {
  /// 11-bit offset.
  final int immdediateValue;

  const B({
    @required this.immdediateValue,
  }) : super._();

  @override
  R accept<R, C>(
    ThumbInstructionVisitor<R, C> visitor, [
    C context,
  ]) =>
      visitor.visitB(this, context);
}
