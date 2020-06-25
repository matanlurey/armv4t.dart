part of '../format.dart';

/// Decoded object from [ArmInstructionSet.$03$multiplyLong].
class MultiplyLongAndMutiplyAccumulateLong extends ArmInstructionSet {
  static final decoder = ArmInstructionSetDecoder._(
    ArmInstructionSet.$03$multiplyLong,
    (decoded) => MultiplyLongAndMutiplyAccumulateLong(
      condition: decoded[0],
      u: decoded[1],
      a: decoded[2],
      s: decoded[3],
      registerD: decoded[4],
      registerN: decoded[5],
      registerS: decoded[6],
      registerM: decoded[7],
    ),
  );

  /// Whether unsigned.
  final int u;

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

  /// Creates a [MultiplyLongAndMutiplyAccumulateLong] from the provided variables.
  ///
  /// > **NOTE**: Bits are **not** checked for correctness or size!
  MultiplyLongAndMutiplyAccumulateLong({
    @required int condition,
    @required this.u,
    @required this.a,
    @required this.s,
    @required this.registerD,
    @required this.registerN,
    @required this.registerS,
    @required this.registerM,
  }) : super._(condition, decoder._format);

  @override
  R accept<R, C>(ArmSetVisitor<R, C> visitor, [C context]) {
    return visitor.visitMultiplyLongAndMutiplyAccumulateLong(this, context);
  }

  @override
  Map<String, Object> toJson() {
    return {
      'Cond': condition,
      'U': u,
      'A': a,
      'S': s,
      'Rd': registerD,
      'Rn': registerN,
      'Rs': registerS,
      'Rm': registerM,
    };
  }
}
