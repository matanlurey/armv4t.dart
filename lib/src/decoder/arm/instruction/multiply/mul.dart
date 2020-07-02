part of '../../instruction.dart';

/// `MUL{cond}{S} Rd,Rm,Rs`.
///
/// ## Execution
///
/// `Rd = Rm * Rs`.
///
/// ## Cycles
///
/// `1S+mI`.
///
/// ## Flags
///
/// `NZx-`.
@immutable
@sealed
class MUL extends MultiplyAndMultiplyLongArmInstruction {
  MUL({
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
