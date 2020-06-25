part of '../format.dart';

/// Decoded object from [ArmInstructionSet.$15$softwareInterrupt].
class SoftwareInterrupt extends ArmInstructionSet {
  static final decoder = ArmInstructionSetDecoder._(
    ArmInstructionSet.$15$softwareInterrupt,
    (decoded) => SoftwareInterrupt(
      condition: decoded[0],
      comment: decoded[1],
    ),
  );

  /// Comment field (ignored by processor), 24-bits.
  final int comment;

  /// Creates a [SoftwareInterrupt] from the provided variables.
  ///
  /// > **NOTE**: Bits are **not** checked for correctness or size!
  SoftwareInterrupt({
    @required int condition,
    @required this.comment,
  }) : super._(condition, decoder._format);

  @override
  R accept<R, C>(ArmSetVisitor<R, C> visitor, [C context]) {
    throw UnimplementedError();
  }

  @override
  Map<String, Object> toJson() {
    return {
      'Cond': condition,
      'Comment': comment,
    };
  }
}
