part of '../format.dart';

/// Decoded object from [ArmInstructionSet.$13$coprocessorDataOperation].
class CoprocessorDataOperation extends ArmInstructionSet {
  static final decoder = ArmInstructionSetDecoder._(
    ArmInstructionSet.$13$coprocessorDataOperation,
    (decoded) => CoprocessorDataOperation(
      condition: decoded[0],
    ),
  );

  /// Creates a [CoprocessorDataOperation] from the provided variables.
  ///
  /// > **NOTE**: Bits are **not** checked for correctness or size!
  CoprocessorDataOperation({
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
