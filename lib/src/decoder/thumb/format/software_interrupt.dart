part of '../format.dart';

class SoftwareInterruptThumbFormat extends ThumbFormat {
  final Uint8 value;

  const SoftwareInterruptThumbFormat({
    @required this.value,
  }) : super._();

  @override
  R accept<R, C>(ThumbFormatVisitor<R, C> visitor, [C context]) {
    return visitor.visitSoftwareInterrupt(this, context);
  }

  @override
  Map<String, int> _values() {
    return {
      'v': value.value,
    };
  }
}
