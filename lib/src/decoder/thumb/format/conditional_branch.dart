part of '../format.dart';

class ConditionalBranchThumbFormat extends ThumbFormat {
  final Uint4 condition;
  final Uint8 offset;

  const ConditionalBranchThumbFormat({
    @required this.condition,
    @required this.offset,
  }) : super._();

  @override
  R accept<R, C>(ThumbInstructionVisitor<R, C> visitor, [C context]) {
    return visitor.visitConditionalBranch(this, context);
  }

  @override
  Map<String, int> _values() {
    return {
      'c': condition.value,
      'o': offset.value,
    };
  }
}
