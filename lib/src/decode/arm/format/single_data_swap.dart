part of '../format.dart';

/// Decoded object from [ArmInstructionSet.$04$singleDataSwap].
class SingleDataSwap extends ArmInstructionSet {
  static final decoder = ArmInstructionSetDecoder._(
    ArmInstructionSet.$04$singleDataSwap,
    (decoded) => SingleDataSwap(
      condition: decoded[0],
    ),
  );

  /// Creates a [SingleDataSwap] from the provided variables.
  ///
  /// > **NOTE**: Bits are **not** checked for correctness or size!
  SingleDataSwap({
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
