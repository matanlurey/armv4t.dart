part of '../format.dart';

class MoveOrCompareOrAddOrSubtractImmediateThumbFormat extends ThumbFormat {
  final Uint2 opCode;
  final Uint3 destination;
  final Uint8 offset;

  const MoveOrCompareOrAddOrSubtractImmediateThumbFormat({
    @required this.opCode,
    @required this.destination,
    @required this.offset,
  }) : super._();

  @override
  R accept<R, C>(ThumbFormatVisitor<R, C> visitor, [C context]) {
    return visitor.visitMoveOrCompareOrAddOrSubtractImmediate(this, context);
  }

  @override
  Map<String, int> _values() {
    return {
      'p': opCode.value,
      'd': destination.value,
      'o': offset.value,
    };
  }
}
