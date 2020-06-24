part of '../format.dart';

/// Decoded object from [ArmInstructionSet.$14$coprocessorRegisterTransfer].
class CoprocessorRegisterTransfer extends ArmInstructionSet {
  static final decoder = ArmInstructionSetDecoder._(
    ArmInstructionSet.$14$coprocessorRegisterTransfer,
    (decoded) => CoprocessorRegisterTransfer(
      condition: decoded[0],
    ),
  );

  /// Creates a [CoprocessorRegisterTransfer] from the provided variables.
  ///
  /// > **NOTE**: Bits are **not** checked for correctness or size!
  CoprocessorRegisterTransfer({
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
