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
class TEQ extends DataProcessingArmInstruction {
  TEQ({
    @required Condition condition,
    @required bool setConditionCodes,
    @required RegisterAny operand1,
    @required RegisterAny destination,
    @required
        Or3<ShiftedRegister<Immediate<Uint8>>, ShiftedRegister<RegisterNotPC>,
                ShiftedImmediate<Uint4>>
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
    return visitor.visitTEQ(this, context);
  }
}
