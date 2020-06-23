part of '../../instruction.dart';

/// Branch and Link.
///
/// Lo register operand | Hi register operand | Condition codes set
/// ------------------- | ------------------- | -------------------
/// 🗙                   | 🗙                   | 🗙
///
/// ## "Instruction 1" ([h] = 0)
///
/// `LR := PC + OffsetHigh << 12`
///
/// In the first instruction, the [offset] field contains the upper 11-bits of
/// the target address. This is shifted left by 12-bits and added to the
/// current program counter (`PC`) address. The resulting address is placed in
/// the link register (`LR`).
///
/// ## "Instruction 2" ([h] = 1)
///
/// ```
/// temp := next instruction address
/// PC := LR + OffsetLow << 1
/// LR := temp | 1
/// ```
///
/// In the second instruction, the [offset] field contains an 11-bit
/// representation lower half of the target address. This is shifted left by
/// 1 bit and added to the link register (`LR`). The link register (`LR`), which
/// now contains thee full 23-bit address, is placed in the program counter
class BL extends ThumbInstruction {
  final int h;
  final int offset;

  const BL({
    @required this.h,
    @required this.offset,
  }) : super._();

  @override
  R accept<R, C>(
    ThumbInstructionVisitor<R, C> visitor, [
    C context,
  ]) =>
      visitor.visitBL(this, context);
}
