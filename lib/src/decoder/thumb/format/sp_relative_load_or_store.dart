part of '../format.dart';

class SPRelativeLoadOrStoreThumbFormat extends ThumbFormat {
  final bool loadBit;
  final Uint3 destination;
  final Uint8 word;

  const SPRelativeLoadOrStoreThumbFormat({
    @required this.loadBit,
    @required this.destination,
    @required this.word,
  }) : super._();

  @override
  R accept<R, C>(ThumbFormatVisitor<R, C> visitor, [C context]) {
    return visitor.visitSPRelativeLoadOrStore(this, context);
  }

  @override
  Map<String, int> _values() {
    return {
      'l': loadBit ? 1 : 0,
      'd': destination.value,
      'w': word.value,
    };
  }
}
