part of '../format.dart';

/// A decoded _Multiply/Multiply-Accumulate_ instruction _format_.
@sealed
class MultiplyArmFormat extends ArmFormat {
  /// Whether to multiply and accumulate (`1`) or multiply only (`0`).
  final bool accumulate;

  /// Whether to set condition codes (`1`) or not (`0`).
  final bool setConditionCodes;

  /// Destination register.
  final Uint4 destinationRegister;

  /// First operand register.
  final Uint4 operandRegister1;

  /// Second operand register.
  final Uint4 operandRegister2;

  /// Third operand register.
  final Uint4 operandRegister3;

  const MultiplyArmFormat({
    @required Uint4 condition,
    @required this.accumulate,
    @required this.setConditionCodes,
    @required this.destinationRegister,
    @required this.operandRegister1,
    @required this.operandRegister2,
    @required this.operandRegister3,
  }) : super._(condition: condition);

  @override
  R accept<R, C>(ArmFormatVisitor<R, C> visitor, [C context]) {
    return visitor.visitMultiply(this, context);
  }

  @override
  Map<String, int> _values() {
    // CCCC_0000_00AS_DDDD_NNNN_FFFF_1001_MMMM
    return {
      'c': condition.value,
      'a': accumulate ? 1 : 0,
      's': setConditionCodes ? 1 : 0,
      'd': destinationRegister.value,
      'n': operandRegister1.value,
      'f': operandRegister2.value,
      'm': operandRegister3.value,
    };
  }
}
