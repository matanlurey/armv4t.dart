part of '../../instruction.dart';

class B extends ArmInstruction {
  final Uint24 offset;

  B({
    @required Condition condition,
    @required this.offset,
  }) : super._(condition: condition);
}
