part of '../../instruction.dart';

/// `ADD{cond}{S} Rd,Rn,Op2`.
///
/// ## Execution
///
/// `Rd = Rn + Op2`.
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
class ADD extends DataProcessingArmInstruction {
  ADD({
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
