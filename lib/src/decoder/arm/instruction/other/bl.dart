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
class BL$Arm extends ArmInstruction {
  final Uint24 offset;

  BL$Arm({
    @required Condition condition,
    @required this.offset,
  }) : super._(condition: condition);

  @override
  R accept<R, C>(ArmInstructionVisitor<R, C> visitor, [C context]) {
    return visitor.visitBL(this, context);
  }

  @override
  List<Object> _values() => [condition, offset];
}
