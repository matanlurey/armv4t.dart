part of '../../instruction.dart';

/// `UMLAL{cond}{S} RdLo,RdHi,Rm,Rs`.
///
/// ## Execution
///
/// `RdHiLo = Rm * Rs + RdHiLo`.
///
/// ## Cycles
///
/// `1S+mI+2I`.
///
/// ## Flags
///
/// `NZx-`.
@immutable
@sealed
class UMLAL extends MultiplyAndMultiplyLongArmInstruction {
  UMLAL({
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
