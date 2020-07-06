part of '../../instruction.dart';

/// `MLA{cond}{S} Rd,Rm,Rs,Rn`.
///
/// ## Execution
///
/// `Rd = Rm * Rs + Rn`.
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
class MLA$Arm extends Multiply$Arm {
  MLA$Arm({
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
    return visitor.visitMLA(this, context);
  }
}
