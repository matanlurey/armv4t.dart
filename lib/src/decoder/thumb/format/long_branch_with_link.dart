part of '../format.dart';

class LongBranchWithLinkThumbFormat extends ThumbFormat {
  final bool hBit;
  final Uint10 offset;

  const LongBranchWithLinkThumbFormat({
    @required this.hBit,
    @required this.offset,
  }) : super._();

  @override
  R accept<R, C>(ThumbInstructionVisitor<R, C> visitor, [C context]) {
    throw UnimplementedError();
  }

  @override
  Map<String, int> _values() {
    return {
      'h': hBit ? 1 : 0,
      'o': offset.value,
    };
  }
}
