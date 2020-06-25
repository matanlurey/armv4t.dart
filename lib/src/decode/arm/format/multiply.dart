part of '../format.dart';

/// Decoded object from [ArmInstructionSet.$02$multiply].
class MultiplyAndMutiplyAccumulate extends ArmInstructionSet {
  static final decoder = ArmInstructionSetDecoder._(
    ArmInstructionSet.$02$multiply,
    (decoded) => MultiplyAndMutiplyAccumulate(
      condition: decoded[0],
      a: decoded[1],
      s: decoded[2],
      registerD: decoded[3],
      registerN: decoded[4],
      registerS: decoded[5],
      registerM: decoded[6],
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
    return visitor.visitMultiplyAndMutiplyAccumulate(this, context);
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