part of '../format.dart';

/// A decoded _Add or Subtract_ THUMB _format_.
class AddOrSubtractThumbFormat extends ThumbFormat {
  /// Whether [baseRegisterOrImmediate] is an immediate (`1`) or register (`0`).
  final bool immediateOperandBit;

  /// OpCode referers to `SUB` (`1`) otherwise `ADD` (`0`).
  final bool opCode$SUB;

  /// Register or immediate value.
  final Uint3 baseRegisterOrImmediate;

  /// Source register.
  final Uint3 sourceRegister;

  /// Destination register.
  final Uint3 destinationRegister;

  const AddOrSubtractThumbFormat({
    @required this.immediateOperandBit,
    @required this.opCode$SUB,
    @required this.baseRegisterOrImmediate,
    @required this.sourceRegister,
    @required this.destinationRegister,
  }) : super._();

  @override
  R accept<R, C>(ThumbFormatVisitor<R, C> visitor, [C context]) {
    return visitor.visitAddOrSubtract(this, context);
  }

  @override
  Map<String, int> _values() {
    return {
      'i': immediateOperandBit ? 1 : 0,
      'p': opCode$SUB ? 1 : 0,
      'n': baseRegisterOrImmediate.value,
      's': sourceRegister.value,
      'd': destinationRegister.value,
    };
  }
}
