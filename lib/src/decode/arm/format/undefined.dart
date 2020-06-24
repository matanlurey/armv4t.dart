part of '../format.dart';

/// Decoded object from [ArmInstructionSet.$09$undefined].
class Undefined extends ArmInstructionSet {
  static final decoder = ArmInstructionSetDecoder._(
    ArmInstructionSet.$09$undefined,
    (decoded) => Undefined(
      condition: decoded[0],
    ),
  );

  /// Creates a [Undefined] from the provided variables.
  ///
  /// > **NOTE**: Bits are **not** checked for correctness or size!
  Undefined({
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
