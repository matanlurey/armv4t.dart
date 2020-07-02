part of '../format.dart';

/// A decoded _Block Data Transfer_ instruction _format_.
@sealed
class BlockDataTransfer extends ArmFormat {
  /// Whether to add offset before transfer (`1`) or after (`0`).
  final bool preIndexingBit;

  /// Whether to add offset]to base (`1`) or subtract (`0`).
  final bool addOffsetBit;

  /// Whether to load PSR or force user mode (`1`) or not (`0`).
  final bool loadPsrOrForceUserMode;

  /// Whether to write address back into base (`1`) or not (`0`).
  final bool writeAddressBit;

  /// Whether to load from memory (`1`) or store to memory (`0`).
  final bool loadMemoryBit;

  /// Base register.
  final Uint4 baseRegister;

  /// Register list.
  final Uint16 registerList;

  const BlockDataTransfer({
    @required Uint4 condition,
    @required this.preIndexingBit,
    @required this.addOffsetBit,
    @required this.loadPsrOrForceUserMode,
    @required this.writeAddressBit,
    @required this.loadMemoryBit,
    @required this.baseRegister,
    @required this.registerList,
  }) : super._(condition: condition);

  @override
  R accept<R, C>(ArmFormatVisitor<R, C> visitor, [C context]) {
    return visitor.visitBlockDataTransfer(this, context);
  }
}
