part of '../format.dart';

class AddOrSubtractThumbFormat extends ThumbFormat {
  final bool immediateBit;
  final bool opCode;
  final Uint3 baseOrOffset3;
  final Uint3 source;
  final Uint3 destination;

  const AddOrSubtractThumbFormat({
    @required this.immediateBit,
    @required this.opCode,
    @required this.baseOrOffset3,
    @required this.source,
    @required this.destination,
  }) : super._();

  @override
  R accept<R, C>(ThumbFormatVisitor<R, C> visitor, [C context]) {
    return visitor.visitAddOrSubtract(this, context);
  }

  @override
  Map<String, int> _values() {
    return {
      'i': immediateBit ? 1 : 0,
      'p': opCode ? 1 : 0,
      'n': baseOrOffset3.value,
      's': source.value,
      'd': destination.value,
    };
  }
}
