part of '../../instruction.dart';

class BX extends ArmInstruction {
  /// Operand register.
  final RegisterNotPC operand;

  BX({
    @required Condition condition,
    @required this.operand,
  }) : super._(condition: condition);

  /// Whether to switch to _THUMB_ mode when branching.
  bool get switchToThumbMode => operand.index.isSet(0);
}
