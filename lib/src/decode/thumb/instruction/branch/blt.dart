part of '../../instruction.dart';

/// Conditional Branch: Less than.
///
/// If `N` set and `V` clear, or `N` clear and `V` set.
///
/// Lo register operand | Hi register operand | Condition codes set
/// ------------------- | ------------------- | -------------------
/// ✔                   | 🗙                   | 🗙
class BLT extends ThumbInstruction {
  /// 8-bit signed immediate (label).
  ///
  /// > **NOTE**: While [label] specifies a full 9-bit two's complement address,
  /// > this must always be halfword-aligned (i.e. with bit `0` set to `0`)
  /// since the assembler actually places `label >> 1` in field `SOffset8`.
  final int label;

  const BLT({@required this.label}) : super._();

  @override
  R accept<R, C>(
    ThumbInstructionVisitor<R, C> visitor, [
    C context,
  ]) =>
      visitor.visitBLT(this, context);
}
