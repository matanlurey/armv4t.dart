part of '../../instruction.dart';

/// `SMULL{cond}{S} RdLo,RdHi,Rm,Rs`.
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
class SMLALArmInstruction extends MultiplyLongArmInstruction {
  SMLALArmInstruction({
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
    return visitor.visitSMLAL(this, context);
  }
}
