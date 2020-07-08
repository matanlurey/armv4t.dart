part of '../format.dart';

class PushOrPopRegistersThumbFormat extends ThumbFormat {
  final bool loadBit;
  final bool pcOrLrBit;
  final Uint8 registerList;

  const PushOrPopRegistersThumbFormat({
    @required this.loadBit,
    @required this.pcOrLrBit,
    @required this.registerList,
  }) : super._();

  @override
  R accept<R, C>(ThumbFormatVisitor<R, C> visitor, [C context]) {
    return visitor.visitPushOrPopRegisters(this, context);
  }

  @override
  Map<String, int> _values() {
    return {
      'l': loadBit ? 1 : 0,
      'r': pcOrLrBit ? 1 : 0,
      'k': registerList.value,
    };
  }
}
