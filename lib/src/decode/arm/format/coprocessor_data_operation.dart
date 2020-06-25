part of '../format.dart';

/// Decoded object from [ArmInstructionSet.$13$coprocessorDataOperation].
class CoprocessorDataOperation extends ArmInstructionSet {
  static final decoder = ArmInstructionSetDecoder._(
    ArmInstructionSet.$13$coprocessorDataOperation,
    (decoded) => CoprocessorDataOperation(
      condition: decoded[0],
      cpOpCode: decoded[1],
      cpOperandRegister1: decoded[2],
      cpDestinationRegister: decoded[3],
      cpNumber: decoded[4],
      cpInformation: decoded[5],
      cpOperandRegister2: decoded[6],
    ),
  );

  /// Coprocessor operation code.
  final int cpOpCode;

  /// Coprocessor operand register.
  final int cpOperandRegister1;

  /// Coprocessor destination register.
  final int cpDestinationRegister;

  /// Coprocessor number.
  final int cpNumber;

  /// Coprocessor information.
  final int cpInformation;

  /// Coprocessor operand register.
  final int cpOperandRegister2;

  /// Creates a [CoprocessorDataOperation] from the provided variables.
  ///
  /// > **NOTE**: Bits are **not** checked for correctness or size!
  CoprocessorDataOperation({
    @required int condition,
    @required this.cpOpCode,
    @required this.cpOperandRegister1,
    @required this.cpDestinationRegister,
    @required this.cpNumber,
    @required this.cpInformation,
    @required this.cpOperandRegister2,
  }) : super._(condition, decoder._format);

  @override
  R accept<R, C>(ArmSetVisitor<R, C> visitor, [C context]) {
    throw UnimplementedError();
  }

  @override
  Map<String, Object> toJson() {
    return {
      'Cond': condition,
      'CP Opc': cpOpCode,
      'CRn': cpOperandRegister1,
      'CRd': cpDestinationRegister,
      'CP#': cpNumber,
      'CP': cpInformation,
      'CRm': cpOperandRegister2,
    };
  }
}
