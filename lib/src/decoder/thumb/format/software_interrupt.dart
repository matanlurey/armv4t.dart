part of '../format.dart';

class SoftwareInterruptThumbFormat extends ThumbFormat {
  final Uint8 value;

  const SoftwareInterruptThumbFormat({
    @required this.value,
  }) : super._();

  @override
  R accept<R, C>(ThumbInstructionVisitor<R, C> visitor, [C context]) {
    throw UnimplementedError();
  }

  @override
  Map<String, int> _values() {
    return {
      'v': value.value,
    };
  }
}
