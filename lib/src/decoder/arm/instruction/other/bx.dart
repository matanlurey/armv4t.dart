part of '../../instruction.dart';

/// `BX{cond} Rn`.
///
/// ## Execution
///
/// `PC = Rn, T = Rn.0`
///
/// ## Cycles
///
/// `2S+1N`.
class BXArmInstruction extends ArmInstruction {
  /// Operand register.
  final RegisterNotPC operand;

  BXArmInstruction({
    @required Condition condition,
    @required this.operand,
  }) : super._(condition: condition);

  @override
  R accept<R, C>(ArmInstructionVisitor<R, C> visitor, [C context]) {
    return visitor.visitBX(this, context);
  }

  /// Whether to switch to _THUMB_ mode when branching.
  bool get switchToThumbMode => operand.index.isSet(0);

  @override
  List<Object> _values() => [condition, operand];
}
