part of '../../instruction.dart';

/// Conditional Branch: Unsigned higher.
///
/// If `C` set and `Z` clear.
///
/// Lo register operand | Hi register operand | Condition codes set
/// ------------------- | ------------------- | -------------------
/// ✔                   | 🗙                   | 🗙
class BHI extends ThumbInstruction {
  /// 8-bit signed immediate (label).
  ///
  /// > **NOTE**: While [label] specifies a full 9-bit two's complement address,
  /// > this must always be halfword-aligned (i.e. with bit `0` set to `0`)
  /// since the assembler actually places `label >> 1` in field `SOffset8`.
  final int label;

  const BHI({@required this.label}) : super._();

  @override
  R accept<R, C>(
    ThumbInstructionVisitor<R, C> visitor, [
    C context,
  ]) =>
      visitor.visitBHI(this, context);
}
