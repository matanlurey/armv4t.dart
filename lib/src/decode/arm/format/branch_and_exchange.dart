part of '../format.dart';

/// Decoded object from [ArmInstructionSet.$05$branchAndExchange].
class BranchAndExchange extends ArmInstructionSet {
  static final decoder = ArmInstructionSetDecoder._(
    ArmInstructionSet.$05$branchAndExchange,
    (decoded) => BranchAndExchange(
      condition: decoded[0],
      registerN: decoded[1],
    ),
  );

  /// Operand register.
  ///
  /// If bits `0` of [registerN] = `1`: Subsequent instructions are `THUMB`.
  /// If bits `1` of [registerN] is `0`: Subsequent instructions are `ARM`.
  final int registerN;

  /// Creates a [BranchAndExchange] from the provided variables.
  ///
  /// > **NOTE**: Bits are **not** checked for correctness or size!
  BranchAndExchange({
    @required int condition,
    @required this.registerN,
  }) : super._(condition, decoder._format);

  @override
  R accept<R, C>(ArmSetVisitor<R, C> visitor, [C context]) {
    throw UnimplementedError();
  }

  @override
  Map<String, Object> toJson() {
    return {
      'Cond': condition,
      'Rn': registerN,
    };
  }
}
