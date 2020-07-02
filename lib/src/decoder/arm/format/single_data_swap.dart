part of '../format.dart';

/// A decoded _Single Data Swap_ instruction _format_.
@sealed
class SingleDataSwap extends ArmFormat {
  /// Whether to swap a byte quantity (`1`) or word quantity (`0`).
  final bool swapByteQuantity;

  /// Base register.
  final Uint4 baseRegister;

  /// Destination register.
  final Uint4 destinationRegister;

  /// Source register.
  final Uint4 sourceRegister;

  const SingleDataSwap({
    @required Uint4 condition,
    @required this.swapByteQuantity,
    @required this.baseRegister,
    @required this.destinationRegister,
    @required this.sourceRegister,
  }) : super._(condition: condition);

  @override
  R accept<R, C>(ArmFormatVisitor<R, C> visitor, [C context]) {
    return visitor.visitSingleDataSwap(this, context);
  }
}
