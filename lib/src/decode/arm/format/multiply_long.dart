part of '../format.dart';

/// Decoded object from [ArmInstructionSet.$03$multiplyLong].
class MultiplyLongAndMutiplyAccumulateLong extends ArmInstructionSet {
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

  /// Whether to accumulate.
  final int a;

  /// Whether to set condition codes.
  final int s;

  /// Destination regsiter.
  final int registerD;

  /// Operand register 1.
  final int registerN;

  /// Operand register 2.
  final int registerS;

  /// Operand register 3.
  final int registerM;

  /// Creates a [MultiplyAndMutiplyAccumulate] from the provided variables.
  ///
  /// > **NOTE**: Bits are **not** checked for correctness or size!
  MultiplyAndMutiplyAccumulate({
    @required int condition,
    @required this.a,
    @required this.s,
    @required this.registerD,
    @required this.registerN,
    @required this.registerS,
    @required this.registerM,
  }) : super._(condition, decoder._format);

  @override
  R accept<R, C>(ArmSetVisitor<R, C> visitor, [C context]) {
    throw UnimplementedError();
  }

  @override
  Map<String, Object> toJson() {
    return {
      'Cond': condition,
      'A': a,
      'S': s,
      'Rd': registerD,
      'Rn': registerN,
      'Rs': registerS,
      'Rm': registerM,
    };
  }
}
