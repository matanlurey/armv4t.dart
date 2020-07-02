part of '../../instruction.dart';

@immutable
@sealed
abstract class SMLAL extends MultiplyAndMultiplyLongArmInstruction {
  SMLAL({
    @required Condition condition,
    @required bool setConditionCodes,
    @required RegisterNotPC operand1,
    @required RegisterNotPC operand2,
    @required RegisterNotPC destination,
  }) : super._(
          condition: condition,
          setConditionCodes: setConditionCodes,
          operand1: operand1,
          operand2: operand2,
          destination: destination,
        );
}
