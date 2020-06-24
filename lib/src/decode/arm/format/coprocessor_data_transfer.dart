part of '../format.dart';

/// Decoded object from [ArmInstructionSet.$12$coprocessorDataTransfer].
class CoprocessorDataTransfer extends ArmInstructionSet {
  static final decoder = ArmInstructionSetDecoder._(
    ArmInstructionSet.$12$coprocessorDataTransfer,
    (decoded) => CoprocessorDataTransfer(
      condition: decoded[0],
    ),
  );

  /// Creates a [CoprocessorDataTransfer] from the provided variables.
  ///
  /// > **NOTE**: Bits are **not** checked for correctness or size!
  CoprocessorDataTransfer({
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
