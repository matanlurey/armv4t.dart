part of '../../instruction.dart';

class BL extends ArmInstruction {
  final Uint24 offset;

  BL({
    @required Condition condition,
    @required this.offset,
  }) : super._(condition: condition);
}
