part of '../format.dart';

/// A decoded _Single Data Transfer_ instruction _format_.
@sealed
class SingleDataTransferArmFormat extends ArmFormat {
  /// Whether [offset] is an immediate value (`0`) or a regsiter (`1`).
  final bool immediateOffset;

  /// Whether to add [offset] before transfer (`1`) or after (`0`).
  final bool preIndexingBit;

  /// Whether to add [offset] to base (`1`) or subtract (`0`).
  final bool addOffsetBit;

  /// Whether to transfer a byte quantity (`1`) or word (`0`).
  final bool byteQuantityBit;

  /// Whether to write address back into base (`1`) or not (`0`).
  final bool writeAddressBit;

  /// Whether to load from memory (`1`) or store to memory (`0`).
  final bool loadMemoryBit;

  /// Base regsiter.
  final Uint4 baseRegister;

  /// Source or destination register.
  final Uint4 sourceOrDestinationRegister;

  /// 12-bit [immediateOffset] or register.
  final Uint12 offset;

  const SingleDataTransferArmFormat({
    @required Uint4 condition,
    @required this.immediateOffset,
    @required this.preIndexingBit,
    @required this.addOffsetBit,
    @required this.byteQuantityBit,
    @required this.writeAddressBit,
    @required this.loadMemoryBit,
    @required this.baseRegister,
    @required this.sourceOrDestinationRegister,
    @required this.offset,
  }) : super._(condition: condition);

  @override
  R accept<R, C>(ArmFormatVisitor<R, C> visitor, [C context]) {
    return visitor.visitSingleDataTransfer(this, context);
  }

  @override
  Map<String, int> _values() {
    // CCCC_01IP_UBWL_NNNN_DDDD_OOOO_OOOO_OOOO
    return {
      'c': condition.value,
      'i': immediateOffset ? 1 : 0,
      'p': preIndexingBit ? 1 : 0,
      'u': addOffsetBit ? 1 : 0,
      'b': byteQuantityBit ? 1 : 0,
      'w': writeAddressBit ? 1 : 0,
      'l': loadMemoryBit ? 1 : 0,
      'n': baseRegister.value,
      'd': sourceOrDestinationRegister.value,
      'o': offset.value,
    };
  }
}
