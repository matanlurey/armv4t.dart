part of '../../instruction.dart';

/// `ORR{cond}{S} Rd,Rn,Op2`.
///
/// ## Execution
///
/// `Rd = Rn OR Op2`.
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
class ORR$Arm extends DataProcessing$Arm {
  ORR$Arm({
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
    return visitor.visitORR(this, context);
  }
}
