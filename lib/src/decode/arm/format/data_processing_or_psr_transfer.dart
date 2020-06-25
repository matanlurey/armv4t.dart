part of '../format.dart';

/// Decoded object from [ArmInstructionSet.$01$dataProcessingOrPsrTransfer].
class DataProcessingOrPSRTransfer extends ArmInstructionSet {
  static final decoder = ArmInstructionSetDecoder._(
    ArmInstructionSet.$01$dataProcessingOrPsrTransfer,
    (decoded) => DataProcessingOrPSRTransfer(
      condition: decoded[0],
      i: decoded[1],
      opcode: decoded[2],
      s: decoded[3],
      registerN: decoded[4],
      registerD: decoded[5],
      operand2: decoded[6],
    ),
  );

  /// Whether [operand2] is an immediate value.
  final int i;

  /// Operation code.
  final int opcode;

  /// Whether to set condition codes.
  final int s;

  /// 1st operand register.
  final int registerN;

  /// Destination regsiter.
  final int registerD;

  /// See [i].
  final int operand2;

  /// Creates a [DataProcessingOrPSRTransfer] from the provided variables.
  ///
  /// > **NOTE**: Bits are **not** checked for correctness or size!
  DataProcessingOrPSRTransfer({
    @required int condition,
    @required this.i,
    @required this.opcode,
    @required this.s,
    @required this.registerN,
    @required this.registerD,
    @required this.operand2,
  }) : super._(condition, decoder._format);

  @override
  R accept<R, C>(ArmSetVisitor<R, C> visitor, [C context]) {
    return visitor.visitDataProcessingOrPSRTransfer(this, context);
  }

  @override
  Map<String, Object> toJson() {
    return {
      'Cond': condition,
      'I': i,
      'OpCode': opcode,
      'S': s,
      'Rn': registerN,
      'Rd': registerD,
      'Operand2': operand2,
    };
  }
}
