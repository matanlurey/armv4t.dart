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
class SMLAL extends MultiplyAndMultiplyLongArmInstruction {
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

  @override
  R accept<R, C>(ArmInstructionVisitor<R, C> visitor, [C context]) {
    return visitor.visitSMLAL(this, context);
  }
}
