part of '../format.dart';

class UnconditionalBranchThumbFormat extends ThumbFormat {
  final Uint11 offset;

  const UnconditionalBranchThumbFormat({
    @required this.offset,
  }) : super._();

  @override
  R accept<R, C>(ThumbFormatVisitor<R, C> visitor, [C context]) {
    return visitor.visitUnconditionalBranch(this, context);
  }

  @override
  Map<String, int> _values() {
    return {
      'o': offset.value,
    };
  }
}
