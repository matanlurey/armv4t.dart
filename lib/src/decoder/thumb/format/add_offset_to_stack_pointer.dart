part of '../format.dart';

class AddOffsetToStackPointerThumbFormat extends ThumbFormat {
  final bool sBit;
  final Uint7 word;

  const AddOffsetToStackPointerThumbFormat({
    @required this.sBit,
    @required this.word,
  }) : super._();

  @override
  R accept<R, C>(ThumbFormatVisitor<R, C> visitor, [C context]) {
    return visitor.visitAddOffsetToStackPointer(this, context);
  }

  @override
  Map<String, int> _values() {
    return {
      's': sBit ? 1 : 0,
      'w': word.value,
    };
  }
}
