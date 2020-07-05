part of '../format.dart';

class PCRelativeLoadThumbFormat extends ThumbFormat {
  final Uint3 destination;
  final Uint8 word;

  const PCRelativeLoadThumbFormat({
    @required this.destination,
    @required this.word,
  }) : super._();

  @override
  R accept<R, C>(ThumbInstructionVisitor<R, C> visitor, [C context]) {
    return visitor.visitPCRelativeLoad(this, context);
  }

  @override
  Map<String, int> _values() {
    return {
      'd': destination.value,
      'w': word.value,
    };
  }
}
