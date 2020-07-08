part of '../format.dart';

class LongBranchWithLinkThumbFormat extends ThumbFormat {
  final bool hBit;
  final Uint11 offset;

  const LongBranchWithLinkThumbFormat({
    @required this.hBit,
    @required this.offset,
  }) : super._();

  @override
  R accept<R, C>(ThumbFormatVisitor<R, C> visitor, [C context]) {
    return visitor.visitLongBranchWithLink(this, context);
  }

  @override
  Map<String, int> _values() {
    return {
      'h': hBit ? 1 : 0,
      'o': offset.value,
    };
  }
}
