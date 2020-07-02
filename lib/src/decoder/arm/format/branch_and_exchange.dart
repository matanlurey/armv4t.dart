part of '../format.dart';

/// A decoded _Branch and Exchange_ (`BX`) instruction _format_.
@sealed
class BranchAndExchange extends ArmFormat {
  /// Operand register.
  final Uint4 operand;

  const BranchAndExchange({
    @required Uint4 condition,
    @required this.operand,
  }) : super._(condition: condition);

  @override
  R accept<R, C>(ArmFormatVisitor<R, C> visitor, [C context]) {
    return visitor.visitBranchAndExchange(this, context);
  }
}
