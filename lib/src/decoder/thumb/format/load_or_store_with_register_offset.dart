part of '../format.dart';

class LoadOrStoreWithRegisterOffsetThumbFormat extends ThumbFormat {
  final bool loadBit;
  final bool byteBit;
  final Uint3 offset;
  final Uint3 base;
  final Uint3 destination;

  const LoadOrStoreWithRegisterOffsetThumbFormat({
    @required this.loadBit,
    @required this.byteBit,
    @required this.offset,
    @required this.base,
    @required this.destination,
  }) : super._();

  @override
  R accept<R, C>(ThumbFormatVisitor<R, C> visitor, [C context]) {
    return visitor.visitLoadOrStoreWithRegisterOffset(this, context);
  }

  @override
  Map<String, int> _values() {
    return {
      'l': loadBit ? 1 : 0,
      'b': byteBit ? 1 : 0,
      'o': offset.value,
      'n': base.value,
      'd': destination.value,
    };
  }
}
