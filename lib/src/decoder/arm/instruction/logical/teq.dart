part of '../../instruction.dart';

/// `TEQ{cond}{P} Rn,Op2`.
///
/// ## Execution
///
/// `Void = Rn XOR Op2`
///
/// ## Cycles
///
/// `1S+x`.
///
/// ## Flags
///
/// `NZc-`.
@immutable
@sealed
class TEQArmInstruction extends DataProcessingArmInstruction {
  TEQArmInstruction({
    @required Condition condition,
    @required RegisterAny operand1,
    @required RegisterAny destination,
    @required
        Or3<
                ShiftedRegister<Immediate<Uint5>, RegisterAny>,
                ShiftedRegister<RegisterNotPC, RegisterAny>,
                ShiftedImmediate<Uint8>>
            operand2,
  }) : super._(
          condition: condition,
          setConditionCodes: true,
          operand1: operand1,
          destination: destination,
          operand2: operand2,
        );

  @override
  R accept<R, C>(ArmInstructionVisitor<R, C> visitor, [C context]) {
    return visitor.visitTEQ(this, context);
  }
}
