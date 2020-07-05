part of '../format.dart';

/// A decoded _Single Data Swap_ instruction _format_.
@sealed
class SingleDataSwapArmFormat extends ArmFormat {
  /// Whether to swap a byte quantity (`1`) or word quantity (`0`).
  final bool swapByteQuantity;

  /// Base register.
  final Uint4 baseRegister;

  /// Destination register.
  final Uint4 destinationRegister;

  /// Source register.
  final Uint4 sourceRegister;

  const SingleDataSwapArmFormat({
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

  @override
  Map<String, int> _values() {
    // CCCC_0001_0B00_NNNN_DDDD_0000_1001_MMMM
    return {
      'c': condition.value,
      'b': swapByteQuantity ? 1 : 0,
      'n': baseRegister.value,
      'd': destinationRegister.value,
      'm': sourceRegister.value,
    };
  }
}
