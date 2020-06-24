part of '../format.dart';

/// Decoded object from [ArmInstructionSet.$10$blockDataTransfer].
class BlockDataTransfer extends ArmInstructionSet {
  static final decoder = ArmInstructionSetDecoder._(
    ArmInstructionSet.$10$blockDataTransfer,
    (decoded) => BlockDataTransfer(
      condition: decoded[0],
    ),
  );

  /// Creates a [BlockDataTransfer] from the provided variables.
  ///
  /// > **NOTE**: Bits are **not** checked for correctness or size!
  BlockDataTransfer({
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
