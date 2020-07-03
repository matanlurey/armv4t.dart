part of '../instruction.dart';

@immutable
@sealed
abstract class DataProcessingArmInstruction
    /**/ extends ArmInstruction
    /**/ implements
        MaySetConditionCodes {
  /// Whether to set condition codes on the PSR.
  ///
  /// Must be `true` for `TST`, `TEQ`, `CMP`, and `CMN`.
  @override
  final bool setConditionCodes;

  /// First operand register.
  ///
  /// Must be [Register.filledWith0s] for `MOV` and `MVN`.
  final RegisterAny operand1;

  /// Destination register.
  ///
  /// Must be [Register.filledWith0s] or [Register.filledWith1s] for `CMP`,
  ///  `CMN`, `TST`, `TEQ`, and their `{P}`-suffixed variants.
  final RegisterAny destination;

  /// Second operand.
  final Or3<
      ShiftedRegister<Immediate<Uint4>>,
      /**/
      ShiftedRegister<RegisterNotPC>,
      /**/
      ShiftedImmediate<Uint8>
      /**/
      > operand2;

  DataProcessingArmInstruction._({
    @required Condition condition,
    @required this.setConditionCodes,
    @required this.operand1,
    @required this.destination,
    @required this.operand2,
  }) : super._(condition: condition);
}
