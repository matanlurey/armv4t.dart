part of '../format.dart';

/// Decoded object from [ArmInstructionSet.$15$softwareInterrupt].
class SoftwareInterrupt extends ArmInstructionSet {
  static final decoder = ArmInstructionSetDecoder._(
    ArmInstructionSet.$15$softwareInterrupt,
    (decoded) => SoftwareInterrupt(
      condition: decoded[0],
    ),
  );

  /// Creates a [SoftwareInterrupt] from the provided variables.
  ///
  /// > **NOTE**: Bits are **not** checked for correctness or size!
  SoftwareInterrupt({
    @required int condition,
  }) : super._(condition, decoder._format);

  @override
  R accept<R, C>(ArmSetVisitor<R, C> visitor, [C context]) {
    throw UnimplementedError();
  }

  @override
  Map<String, Object> toJson() {
    return {
      'Cond': condition,
    };
  }
}
