part of '../../instruction.dart';

/// `BL{cond} label`.
///
/// ## Execution
///
/// `PC = $+8 +/- 32M, LR=$+4`.
///
/// ## Cycles
///
/// `2S+1N`.
class BLArmInstruction extends ArmInstruction {
  final Int24 offset;

  /// Whether this instruction originates from the `THUMB` `BL`.
  ///
  /// If `null` then this instruction should be treated as the `ARM` `BL`.
  ///
  /// If `true`, the following instructions should be executed:
  /// ```txt
  /// temp := next instruction address
  /// PC   := LR   + OffsetLow << 1
  /// LR   := temp | 1
  /// ```
  ///
  /// If `false`, the following instruction should be executed:
  /// ```txt
  /// LR   := PC + OffsetHigh << 12
  /// ```
  final bool thumbLongBranch;

  BLArmInstruction({
    @required Condition condition,
    @required this.offset,
    this.thumbLongBranch,
  }) : super._(condition: condition);

  @override
  R accept<R, C>(ArmInstructionVisitor<R, C> visitor, [C context]) {
    return visitor.visitBL(this, context);
  }

  @override
  List<Object> _values() => [condition, offset, thumbLongBranch];
}
