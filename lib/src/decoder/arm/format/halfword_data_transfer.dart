part of '../format.dart';

/// A decoded _Halfword and Signed Data Transfer_ instruction _format_.
@immutable
@sealed
class HalfwordDataTransfer extends ArmFormat {
  /// Whether to add offset before transfer (`1`) or after (`0`).
  final bool preIndexingBit;

  /// Whether to add offset to base (`1`) or subtract (`0`).
  final bool addOffsetBit;

  /// Whether offset is an immediate offset (`1`) or a register (`0`).
  ///
  /// If `true`, both [offsetHiNibble] and [offsetLoNibble] are used.
  final bool immediateOffset;

  /// Whether to write address back into base (`1`) or not (`0`).
  final bool writeAddressBit;

  /// Whether to load from memory (`1`) or store to memory (`0`).
  final bool loadMemoryBit;

  /// Base register.
  final Uint4 baseRegister;

  /// Source or destination register.
  final Uint4 sourceOrDestinationRegister;

  /// Immediate offset (high nibble).
  ///
  /// For register transfers this will always be `0`.
  final Uint4 offsetHiNibble;

  /// Operation code.
  final Uint2 opCode;

  /// Offset (either immedaite low nibble, or register).
  final Uint4 offsetLoNibble;

  const HalfwordDataTransfer({
    @required Uint4 condition,
    @required this.preIndexingBit,
    @required this.addOffsetBit,
    @required this.immediateOffset,
    @required this.writeAddressBit,
    @required this.loadMemoryBit,
    @required this.baseRegister,
    @required this.sourceOrDestinationRegister,
    @required this.offsetHiNibble,
    @required this.opCode,
    @required this.offsetLoNibble,
  }) : super._(condition: condition);

  @override
  R accept<R, C>(ArmFormatVisitor<R, C> visitor, [C context]) {
    return visitor.visitHalfwordDataTransfer(this, context);
  }
}
