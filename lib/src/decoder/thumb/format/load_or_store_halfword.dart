part of '../format.dart';

class LoadOrStoreHalfwordThumbFormat extends ThumbFormat {
  final bool loadBit;
  final Uint5 offset;
  final Uint3 baseRegister;
  final Uint3 sourceOrDestinationRegister;

  const LoadOrStoreHalfwordThumbFormat({
    @required this.loadBit,
    @required this.offset,
    @required this.baseRegister,
    @required this.sourceOrDestinationRegister,
  }) : super._();

  @override
  R accept<R, C>(ThumbFormatVisitor<R, C> visitor, [C context]) {
    return visitor.visitLoadOrStoreHalfword(this, context);
  }

  @override
  Map<String, int> _values() {
    return {
      'l': loadBit ? 1 : 0,
      'o': offset.value,
      'b': baseRegister.value,
      'd': sourceOrDestinationRegister.value,
    };
  }
}
