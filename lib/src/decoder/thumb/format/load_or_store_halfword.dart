part of '../format.dart';

class LoadOrStoreHalfwordThumbFormat extends ThumbFormat {
  final bool loadBit;
  final Uint3 destination;
  final Uint8 word;

  const LoadOrStoreHalfwordThumbFormat({
    @required this.loadBit,
    @required this.destination,
    @required this.word,
  }) : super._();

  @override
  R accept<R, C>(ThumbInstructionVisitor<R, C> visitor, [C context]) {
    throw UnimplementedError();
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
