part of '../format.dart';

/// A decoded _Move Shifted Register_ THUMB _format_.
class MoveShiftedRegisterThumbFormat extends ThumbFormat {
  /// OpCode:
  ///
  /// - 0x0: `LSL`
  /// - 0x1: `LSR`
  /// - 0x2: `ASR`
  final Uint2 opCode;

  /// Immediate value.
  final Uint5 immediate;

  /// Source register.
  final Uint3 sourceRegister;

  /// Destination register.
  final Uint3 destinationRegister;

  const MoveShiftedRegisterThumbFormat({
    @required this.opCode,
    @required this.immediate,
    @required this.sourceRegister,
    @required this.destinationRegister,
  }) : super._();

  @override
  R accept<R, C>(ThumbFormatVisitor<R, C> visitor, [C context]) {
    return visitor.visitMoveShiftedRegister(this, context);
  }

  @override
  Map<String, int> _values() {
    return {
      'p': opCode.value,
      'o': immediate.value,
      's': sourceRegister.value,
      'd': destinationRegister.value,
    };
  }
}
