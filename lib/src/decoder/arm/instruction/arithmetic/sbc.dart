part of '../../instruction.dart';

/// `SBC{cond}{S} Rd,Rn,Op2`.
///
/// ## Execution
///
/// `Rd = Rn - Op2 + Cy - 1`.
///
/// ## Cycles
///
/// `1S+x+y`.
///
/// ## Flags
///
/// `NZCV`.
@immutable
@sealed
class SBC extends DataProcessingArmInstruction {
  SBC({
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
}
