part of '../../instruction.dart';

/// `SMULL{cond}{S} RdLo,RdHi,Rm,Rs`.
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
class SMULLArmInstruction extends MultiplyLongArmInstruction {
  SMULLArmInstruction({
    @required Condition condition,
    @required bool setConditionCodes,
    @required RegisterNotPC operand1,
    @required RegisterNotPC operand2,
    @required RegisterNotPC destinationHiBits,
    @required RegisterNotPC destinationLoBits,
  }) : super._(
          condition: condition,
          setConditionCodes: setConditionCodes,
          operand1: operand1,
          operand2: operand2,
          destinationHiBits: destinationHiBits,
          destinationLoBits: destinationLoBits,
        );

  @override
  R accept<R, C>(ArmInstructionVisitor<R, C> visitor, [C context]) {
    return visitor.visitSMULL(this, context);
  }
}
