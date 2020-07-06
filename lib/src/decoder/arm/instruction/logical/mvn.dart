part of '../../instruction.dart';

/// `MVN{cond}{S} Rd,Op2`.
///
/// ## Execution
///
/// `Rd = NOT Op2`.
///
/// ## Cycles
///
/// `1S+x+y`.
///
/// ## Flags
///
/// `NZc-`.
@immutable
@sealed
class MVN$Arm extends DataProcessing$Arm {
  MVN$Arm({
    @required Condition condition,
    @required bool setConditionCodes,
    @required RegisterAny operand1,
    @required RegisterAny destination,
    @required
        Or3<
                ShiftedRegister<Immediate<Uint4>, RegisterAny>,
                ShiftedRegister<RegisterNotPC, RegisterAny>,
                ShiftedImmediate<Uint8>>
            operand2,
  }) : super._(
          condition: condition,
          setConditionCodes: setConditionCodes,
          operand1: operand1,
          destination: destination,
          operand2: operand2,
        );

  @override
  R accept<R, C>(ArmInstructionVisitor<R, C> visitor, [C context]) {
    return visitor.visitMVN(this, context);
  }
}
