part of '../../instruction.dart';

class SWI extends ArmInstruction {
  final Comment comment;

  SWI({
    @required Condition condition,
    @required this.comment,
  }) : super._(condition: condition);
}
