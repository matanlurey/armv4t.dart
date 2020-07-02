part of '../instruction.dart';

abstract class MultiplyAndMultiplyLongArmInstruction
    /**/ extends ArmInstruction
    /**/ implements
        MaySetConditionCodes {
  /// Whether to set condition codes on the PSR.
  ///
  /// Must be `true` for Halfword and `UMAAL`.
  @override
  final bool setConditionCodes;

  /// First operand register.
  final RegisterNotPC operand1;

  /// Second operand register.
  final RegisterNotPC operand2;

  /// Destination register.
  final RegisterNotPC destination;

  const MultiplyAndMultiplyLongArmInstruction._({
    @required Condition condition,
    @required this.setConditionCodes,
    @required this.operand1,
    @required this.operand2,
    @required this.destination,
  }) : super._(condition: condition);
}
