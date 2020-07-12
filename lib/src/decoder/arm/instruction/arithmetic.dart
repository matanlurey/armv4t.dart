part of '../instruction.dart';

/// These instructions operate on the general-purpose registers.
///
/// They can perform operations such as addition, subtraction, or bit-wise logic
/// on the contents of two regsiters, and place ther esult in a third register.
/// They can also operate on the value in a single regsiter, or on a value in
/// a register and a constant supplied within the instruction (an _immediate
/// value_, represented by [Immediate] in this library).
///
/// See also [MultiplyAndMultiplyLongArmInstruction].
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
      ShiftedRegister<Immediate<Uint4>, RegisterAny>,
      /**/
      ShiftedRegister<RegisterNotPC, RegisterAny>,
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

  @override
  List<Object> _values() {
    return [
      condition,
      setConditionCodes,
      operand1,
      destination,
      operand2,
    ];
  }
}
