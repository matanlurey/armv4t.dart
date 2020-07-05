part of '../format.dart';

class MultipleLoadOrStoreThumbFormat extends ThumbFormat {
  final bool loadBit;
  final Uint3 base;
  final Uint8 registerList;

  const MultipleLoadOrStoreThumbFormat({
    @required this.loadBit,
    @required this.base,
    @required this.registerList,
  }) : super._();

  @override
  R accept<R, C>(ThumbFormatVisitor<R, C> visitor, [C context]) {
    return visitor.visitMultipleLoadOrStore(this, context);
  }

  @override
  Map<String, int> _values() {
    return {
      'l': loadBit ? 1 : 0,
      'b': base.value,
      'r': registerList.value,
    };
  }
}
