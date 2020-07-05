part of '../format.dart';

/// A decoded _Data Processing_ or _PSR Transfer_ instruction _format_.
@sealed
class DataProcessingOrPsrTransferArmFormat extends ArmFormat {
  /// Whether [operand2] is an immediate value (`1`) or a register (`0`).
  final bool immediateOperand;

  /// Operation code.
  final Uint4 opCode;

  /// Whether to set condition codes (`1`) or not (`0`).
  final bool setConditionCodes;

  /// First operand (register).
  final Uint4 operand1Register;

  /// Destination register.
  final Uint4 destinationRegister;

  /// Second operand (see [immediateOperand]).
  final Uint12 operand2;

  const DataProcessingOrPsrTransferArmFormat({
    @required Uint4 condition,
    @required this.immediateOperand,
    @required this.opCode,
    @required this.setConditionCodes,
    @required this.operand1Register,
    @required this.destinationRegister,
    @required this.operand2,
  }) : super._(condition: condition);

  @override
  R accept<R, C>(ArmFormatVisitor<R, C> visitor, [C context]) {
    return visitor.visitDataProcessingOrPsrTransfer(this, context);
  }

  @override
  Map<String, int> _values() {
    // CCCC_00IP_PPPS_NNNN_DDDD_OOOO_OOOO_OOOO
    return {
      'c': condition.value,
      'i': immediateOperand ? 1 : 0,
      'p': opCode.value,
      's': setConditionCodes ? 1 : 0,
      'n': operand1Register.value,
      'd': destinationRegister.value,
      'o': operand2.value,
    };
  }
}
