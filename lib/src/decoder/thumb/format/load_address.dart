part of '../format.dart';

class LoadAddressThumbFormat extends ThumbFormat {
  final bool stackPointerBit;
  final Uint3 destination;
  final Uint8 word;

  const LoadAddressThumbFormat({
    @required this.stackPointerBit,
    @required this.destination,
    @required this.word,
  }) : super._();

  @override
  R accept<R, C>(ThumbInstructionVisitor<R, C> visitor, [C context]) {
    return visitor.visitLoadAddress(this, context);
  }

  @override
  Map<String, int> _values() {
    return {
      's': stackPointerBit ? 1 : 0,
      'd': destination.value,
      'w': word.value,
    };
  }
}
