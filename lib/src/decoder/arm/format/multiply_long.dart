part of '../format.dart';

/// A decoded _Multiply Long/Multiply-Accumulate Long_ instruction _format_.
@sealed
class MultiplyLongArmFormat extends ArmFormat {
  /// Whether to perform a signed (`1`) or unsigned (`0`) instruction.
  final bool signed;

  /// Whether to multiply and accumulate (`1`) or multiply only (`0`).
  final bool accumulate;

  /// Whether to set condition codes (`1`) or not (`0`).
  final bool setConditionCodes;

  /// Destination register (_Hi_ bits).
  final Uint4 destinationRegisterHi;

  /// Destination register (_Lo_ bits).
  final Uint4 destinationRegisterLo;

  /// First operand register.
  final Uint4 operandRegister1;

  /// Second operand register.
  final Uint4 operandRegister2;

  const MultiplyLongArmFormat({
    @required Uint4 condition,
    @required this.signed,
    @required this.accumulate,
    @required this.setConditionCodes,
    @required this.destinationRegisterHi,
    @required this.destinationRegisterLo,
    @required this.operandRegister1,
    @required this.operandRegister2,
  }) : super._(condition: condition);

  @override
  R accept<R, C>(ArmFormatVisitor<R, C> visitor, [C context]) {
    return visitor.visitMultiplyLong(this, context);
  }

  @override
  Map<String, int> _values() {
    // CCCC_0000_00AS_DDDD_NNNN_FFFF_1001_MMMM
    return {
      'c': condition.value,
      'a': accumulate ? 1 : 0,
      's': setConditionCodes ? 1 : 0,
      'd': destinationRegisterHi.value,
      'n': destinationRegisterLo.value,
      'f': operandRegister1.value,
      'm': operandRegister2.value,
    };
  }
}
