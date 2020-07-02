part of '../format.dart';

/// A decoded _Software Interrupt_ instruction _format_.
@sealed
class SoftwareInterrupt extends ArmFormat {
  /// Comment field (ignored by processor).
  final Uint24 comment;

  const SoftwareInterrupt({
    @required Uint4 condition,
    @required this.comment,
  }) : super._(condition: condition);

  @override
  R accept<R, C>(ArmFormatVisitor<R, C> visitor, [C context]) {
    return visitor.visitSoftwareInterrupt(this, context);
  }
}
