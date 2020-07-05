part of '../format.dart';

class LoadOrStoreWithImmediateOffsetThumbFormat extends ThumbFormat {
  final bool byteBit;
  final bool loadBit;
  final Uint5 offset;
  final Uint3 base;
  final Uint3 destination;

  const LoadOrStoreWithImmediateOffsetThumbFormat({
    @required this.byteBit,
    @required this.loadBit,
    @required this.offset,
    @required this.base,
    @required this.destination,
  }) : super._();

  @override
  R accept<R, C>(ThumbInstructionVisitor<R, C> visitor, [C context]) {
    throw UnimplementedError();
  }

  @override
  Map<String, int> _values() {
    return {
      'b': byteBit ? 1 : 0,
      'l': loadBit ? 1 : 0,
      'o': offset.value,
      'n': base.value,
      'd': destination.value,
    };
  }
}