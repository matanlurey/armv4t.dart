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

  const MultiplyAndMultiplyLongArmInstruction._({
    @required Condition condition,
    @required this.setConditionCodes,
    @required this.operand1,
    @required this.operand2,
  }) : super._(condition: condition);
}

abstract class MultiplyArmInstruction
    extends MultiplyAndMultiplyLongArmInstruction {
  /// Destination register.
  final RegisterNotPC destination;

  const MultiplyArmInstruction._({
    @required Condition condition,
    @required bool setConditionCodes,
    @required RegisterNotPC operand1,
    @required RegisterNotPC operand2,
    @required this.destination,
  }) : super._(
          condition: condition,
          setConditionCodes: setConditionCodes,
          operand1: operand1,
          operand2: operand2,
        );

  @override
  List<Object> _values() {
    return [
      condition,
      setConditionCodes,
      operand1,
      operand2,
      destination,
    ];
  }
}

abstract class MultiplyLongArmInstruction
    extends MultiplyAndMultiplyLongArmInstruction {
  /// Destination register (Hi bits).
  final RegisterNotPC destinationHiBits;

  /// Destination register (Lo bits).
  final RegisterNotPC destinationLoBits;

  const MultiplyLongArmInstruction._({
    @required Condition condition,
    @required bool setConditionCodes,
    @required RegisterNotPC operand1,
    @required RegisterNotPC operand2,
    @required this.destinationHiBits,
    @required this.destinationLoBits,
  }) : super._(
          condition: condition,
          setConditionCodes: setConditionCodes,
          operand1: operand1,
          operand2: operand2,
        );

  @override
  List<Object> _values() {
    return [
      condition,
      setConditionCodes,
      operand1,
      operand2,
      destinationHiBits,
      destinationLoBits,
    ];
  }
}
