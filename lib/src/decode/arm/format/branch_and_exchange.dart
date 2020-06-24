part of '../format.dart';

/// Decoded object from [ArmInstructionSet.$05$branchAndExchange].
class BranchAndExchange extends ArmInstructionSet {
  static final decoder = ArmInstructionSetDecoder._(
    ArmInstructionSet.$05$branchAndExchange,
    (decoded) => BranchAndExchange(
      condition: decoded[0],
    ),
  );

  /// Creates a [BranchAndExchange] from the provided variables.
  ///
  /// > **NOTE**: Bits are **not** checked for correctness or size!
  BranchAndExchange({
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
