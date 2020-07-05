part of '../format.dart';

class AddOffsetToStackPointerThumbFormat extends ThumbFormat {
  final Uint2 opCode;
  final Uint5 offset;
  final Uint3 source;
  final Uint3 destination;

  const AddOffsetToStackPointerThumbFormat({
    @required this.opCode,
    @required this.offset,
    @required this.source,
    @required this.destination,
  }) : super._();

  @override
  R accept<R, C>(ThumbInstructionVisitor<R, C> visitor, [C context]) {
    throw UnimplementedError();
  }

  @override
  Map<String, int> _values() {
    return {
      'p': opCode.value,
      'o': offset.value,
      's': source.value,
      'd': destination.value,
    };
  }
}
