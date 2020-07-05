part of '../../instruction.dart';

/// `CMN{cond}{P} Rn,Op2`.
///
/// ## Execution
///
/// `Void = Rn + Op2`.
///
/// ## Cycles
///
/// `1S+x`.
///
/// ## Flags
///
/// `NZCV`.
@immutable
@sealed
class CMN extends DataProcessingArmInstruction {
  CMN({
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
    return visitor.visitCMN(this, context);
  }
}
