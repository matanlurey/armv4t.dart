part of '../../instruction.dart';

/// `UMULL{cond}{S} RdLo,RdHi,Rm,Rs`.
///
/// ## Execution
///
/// `RdHiLo = Rm * Rs`.
///
/// ## Cycles
///
/// `1S+mI+1I`.
///
/// ## Flags
///
/// `NZx-`.
@immutable
@sealed
class UMULL extends MultiplyAndMultiplyLongArmInstruction {
  UMULL({
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
