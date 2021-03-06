part of '../../instruction.dart';

/// `B{cond} label`.
///
/// ## Execution
///
/// `PC = $+8 +/- 32M`.
///
/// ## Cycles
///
/// `2S+1N`.
class BArmInstruction extends ArmInstruction {
  final Int24 offset;

  BArmInstruction({
    @required Condition condition,
    @required this.offset,
  }) : super._(condition: condition);

  @override
  R accept<R, C>(ArmInstructionVisitor<R, C> visitor, [C context]) {
    return visitor.visitB(this, context);
  }

  @override
  List<Object> _values() => [condition, offset];
}
