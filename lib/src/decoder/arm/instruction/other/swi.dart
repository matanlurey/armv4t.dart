part of '../../instruction.dart';

/// `SWI{cond} <Imm24Bit>`.
///
/// ## Execution
///
/// `PC = 8, ARM Svc Mode, LR=$+4`
///
/// ## Cycles
///
/// `2S+1N`.
class SWI extends ArmInstruction {
  final Comment comment;

  SWI({
    @required Condition condition,
    @required this.comment,
  }) : super._(condition: condition);

  @override
  R accept<R, C>(ArmInstructionVisitor<R, C> visitor, [C context]) {
    return visitor.visitSWI(this, context);
  }
}
