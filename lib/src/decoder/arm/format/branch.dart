part of '../format.dart';

/// A decoded _Branch instruction _format_.
@sealed
class Branch extends ArmFormat {
  /// Link bit.
  ///
  /// - 0 = Branch
  /// - 1 = Branch with Link
  final bool link;

  /// Offset value.
  final Uint24 offset;

  const Branch({
    @required Uint4 condition,
    @required this.link,
    @required this.offset,
  }) : super._(condition: condition);

  @override
  R accept<R, C>(ArmFormatVisitor<R, C> visitor, [C context]) {
    return visitor.visitBranch(this, context);
  }
}
