part of '../format.dart';

/// A decoded _Software Interrupt_ instruction _format_.
@sealed
class SoftwareInterruptArmFormat extends ArmFormat {
  /// Comment field (ignored by processor).
  final Uint24 comment;

  const SoftwareInterruptArmFormat({
    @required Uint4 condition,
    @required this.comment,
  }) : super._(condition: condition);

  @override
  R accept<R, C>(ArmFormatVisitor<R, C> visitor, [C context]) {
    return visitor.visitSoftwareInterrupt(this, context);
  }

  @override
  Map<String, int> _values() {
    // CCCC_1111_XXXX_XXXX_XXXX_XXXX_XXXX_XXXX
    return {
      'c': condition.value,
      'x': comment.value,
    };
  }
}
