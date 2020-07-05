part of '../format.dart';

class PushOrPopRegistersThumbFormat extends ThumbFormat {
  final bool loadBit;
  final bool rBit;
  final Uint8 registerList;

  const PushOrPopRegistersThumbFormat({
    @required this.loadBit,
    @required this.rBit,
    @required this.registerList,
  }) : super._();

  @override
  R accept<R, C>(ThumbInstructionVisitor<R, C> visitor, [C context]) {
    throw UnimplementedError();
  }

  @override
  Map<String, int> _values() {
    return {
      'l': loadBit ? 1 : 0,
      'b': rBit ? 1 : 0,
      'r': registerList.value,
    };
  }
}
