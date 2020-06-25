part of '../format.dart';

/// Decoded object from [ArmInstructionSet.$14$coprocessorRegisterTransfer].
class CoprocessorRegisterTransfer extends ArmInstructionSet {
  static final decoder = ArmInstructionSetDecoder._(
    ArmInstructionSet.$14$coprocessorRegisterTransfer,
    (decoded) => CoprocessorRegisterTransfer(
      condition: decoded[0],
      cpOpCode: decoded[1],
      l: decoded[2],
      cpRegisterN: decoded[3],
      registerD: decoded[4],
      cpNumber: decoded[5],
      cpInformation: decoded[6],
      cpRegisterM: decoded[7],
    ),
  );

  /// Coprocessor operation mode.
  final int cpOpCode;

  /// Load/Store bit.
  final int l;

  /// Coprocessor source/destination register.
  final int cpRegisterN;

  /// ARM source/destination register.
  final int registerD;

  /// Coprocessor number.
  final int cpNumber;

  /// Coprocessor information.
  final int cpInformation;

  /// Coprocessor operand register.
  final int cpRegisterM;

  /// Creates a [CoprocessorRegisterTransfer] from the provided variables.
  ///
  /// > **NOTE**: Bits are **not** checked for correctness or size!
  CoprocessorRegisterTransfer({
    @required int condition,
    @required this.cpOpCode,
    @required this.l,
    @required this.cpRegisterN,
    @required this.registerD,
    @required this.cpNumber,
    @required this.cpInformation,
    @required this.cpRegisterM,
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
      'L': l,
      'CRn': cpRegisterN,
      'Rd': registerD,
      'CP#': cpNumber,
      'CP': cpInformation,
      'CRm': cpRegisterM,
    };
  }
}
