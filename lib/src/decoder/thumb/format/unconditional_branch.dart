part of '../format.dart';

class UnconditionalBranchThumbFormat extends ThumbFormat {
  final Uint11 offset;

  const UnconditionalBranchThumbFormat({
    @required this.offset,
  }) : super._();

  @override
  R accept<R, C>(ThumbInstructionVisitor<R, C> visitor, [C context]) {
    throw UnimplementedError();
  }

  @override
  Map<String, int> _values() {
    return {
      'o': offset.value,
    };
  }
}
