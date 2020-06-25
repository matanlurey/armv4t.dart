part of '../format.dart';

/// Decoded object from [ArmInstructionSet.$04$singleDataSwap].
class SingleDataSwap extends ArmInstructionSet {
  static final decoder = ArmInstructionSetDecoder._(
    ArmInstructionSet.$04$singleDataSwap,
    (decoded) => SingleDataSwap(
      condition: decoded[0],
      b: decoded[1],
      registerN: decoded[2],
      registerD: decoded[3],
      registerM: decoded[4],
    ),
  );

  /// Byte/Word Bit (`0` = Swap Word Quantity, `1` = Swap Byte Quantity).
  final int b;

  /// Base register.
  final int registerN;

  /// Destination register.
  final int registerD;

  /// Source register.
  final int registerM;

  /// Creates a [SingleDataSwap] from the provided variables.
  ///
  /// > **NOTE**: Bits are **not** checked for correctness or size!
  SingleDataSwap({
    @required int condition,
    @required this.b,
    @required this.registerN,
    @required this.registerD,
    @required this.registerM,
  }) : super._(condition, decoder._format);

  @override
  R accept<R, C>(ArmSetVisitor<R, C> visitor, [C context]) {
    return visitor.visitSingleDataSwap(this, context);
  }

  @override
  Map<String, Object> toJson() {
    return {
      'Cond': condition,
    };
  }
}
