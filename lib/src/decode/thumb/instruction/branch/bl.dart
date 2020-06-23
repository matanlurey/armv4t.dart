part of '../../instruction.dart';

/// Branch and Link.
///
/// Lo register operand | Hi register operand | Condition codes set
/// ------------------- | ------------------- | -------------------
/// 🗙                   | 🗙                   | 🗙
abstract class BL extends ThumbInstruction {
  final int offset;

  const BL._({
    @required this.offset,
  }) : super._();
}

/// Sub-type of [BL].
///
/// `LR := PC + OffsetHigh << 12`
///
/// ## "Instruction 1" (`H` = 0)
///
/// In the first instruction, the [offset] field contains the upper 11-bits of
/// the target address. This is shifted left by 12-bits and added to the
/// current program counter (`PC`) address. The resulting address is placed in
/// the link register (`LR`).
class BL$1 extends BL {
  const BL$1({
    @required int offset,
  }) : super._(
          offset: offset,
        );
}

/// Sub-type of [BL].
///
/// ```
/// temp := next instruction address
/// PC := LR + OffsetLow << 1
/// LR := temp | 1
/// ```
///
/// ## "Instruction 2" (`H` = 1)
///
/// In the second instruction, the [offset] field contains an 11-bit
/// representation lower half of the target address. This is shifted left by
/// 1 bit and added to the link register (`LR`). The link register (`LR`), which
/// now contains thee full 23-bit address, is placed in the program counter
/// (`PC`), the address of the instruction following this instruction (`BL`) is
/// placed in the link register (`LR`) and bit 0 of the link register (`LR`) is
/// set.
///
/// The branch [offset] must take account of the prefetch operation, which
/// causes the program counter (`PC`) to be 1 word (4 bytes) ahead of the
/// current instruction.
class BL$2 extends BL {
  const BL$2({
    @required int offset,
  }) : super._(
          offset: offset,
        );
}
