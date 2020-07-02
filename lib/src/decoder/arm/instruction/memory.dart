part of '../instruction.dart';

abstract class DataTransfer extends ArmInstruction {
  /// `P`: Whether to add offset before transfer (`1`), otherwise after (`0`).
  final bool addOffsetBeforeTransfer;

  /// `U`: Whether to add offset to base (`1`), otherwise subtract from (`1`).
  final bool addOffsetToBase;

  /// Depending on the instruction, this is either the `W` or `T` bit.
  ///
  /// `W`: Whether to write address into base (`1`), otherwise (`0`).
  ///
  /// > If [addOffsetBeforeTransfer] is set, this is _always_ `true`.
  ///
  /// `T`: Whether to force non-privileged access (`1`), otherwise (`0`).
  @protected
  final bool writeAddressIntoBaseOrForceNonPrivilegedAccess;

  /// `L`: Whether to load from memory, otherwise store to memory (`0`).
  final bool loadFromMemory;

  /// Base register.
  final RegisterAny base;

  DataTransfer._({
    @required Condition condition,
    @required this.addOffsetBeforeTransfer,
    @required this.addOffsetToBase,
    @required this.writeAddressIntoBaseOrForceNonPrivilegedAccess,
    @required this.loadFromMemory,
    @required this.base,
  }) : super._(condition: condition);
}

mixin HasWriteBackOnly on DataTransfer {
  /// `W`: Whether to write address into base (`1`), otherwise (`0`).
  ///
  /// > If [addOffsetBeforeTransfer] is set, this is _always_ `true`.
  bool get writeAddressIntoBase {
    return writeAddressIntoBaseOrForceNonPrivilegedAccess;
  }
}

abstract class HasTransferByte implements ArmInstruction {
  /// `B`: Whether to transfer a byte (8-bits, `1`) otherwise a word (32, `0`).
  bool get transferByte;
}

@immutable
@sealed
abstract class SingleDataTransfer
    /**/ extends DataTransfer
    /**/ implements
        HasTransferByte {
  /// `B`: Whether to transfer a byte (8-bits, `1`) otherwise a word (32, `0`).
  @override
  final bool transferByte;

  /// Source or destination register (`Rd`).
  @protected
  final RegisterAny sourceOrDestination;

  /// Either an unsigned 12-bit immediate or register shifted by immediate.
  final Or2<Immediate<Uint12>, ShiftedRegister<Immediate<Uint4>>> offset;

  SingleDataTransfer._({
    @required Condition condition,
    @required bool addOffsetBeforeTransfer,
    @required bool addOffsetToBase,
    @required bool writeAddressIntoBaseOrForceNonPrivilegedAccess,
    @required this.transferByte,
    @required bool loadFromMemory,
    @required RegisterAny base,
    @required this.sourceOrDestination,
    @required this.offset,
  }) : super._(
          condition: condition,
          addOffsetBeforeTransfer: addOffsetBeforeTransfer,
          addOffsetToBase: addOffsetToBase,
          writeAddressIntoBaseOrForceNonPrivilegedAccess:
              writeAddressIntoBaseOrForceNonPrivilegedAccess,
          loadFromMemory: loadFromMemory,
          base: base,
        );
}

@immutable
@sealed
abstract class HalfwordDataTransfer
    /**/ extends DataTransfer
    /**/ with
        HasWriteBackOnly {
  /// Source or destination register (`Rd`).
  @protected
  final RegisterAny sourceOrDestination;

  /// Either an offset register or 8-bit immediate offset.
  final Or2<RegisterNotPC, Immediate<Uint8>> offset;

  HalfwordDataTransfer._({
    @required Condition condition,
    @required bool addOffsetBeforeTransfer,
    @required bool addOffsetToBase,
    @required bool writeAddressIntoBase,
    @required bool loadFromMemory,
    @required RegisterAny base,
    @required this.sourceOrDestination,
    @required this.offset,
  }) : super._(
          condition: condition,
          addOffsetBeforeTransfer: addOffsetBeforeTransfer,
          addOffsetToBase: addOffsetToBase,
          writeAddressIntoBaseOrForceNonPrivilegedAccess: writeAddressIntoBase,
          loadFromMemory: loadFromMemory,
          base: base,
        );
}

@immutable
@sealed
abstract class BlockDataTransfer extends DataTransfer with HasWriteBackOnly {
  /// Addressing mode.
  final BlockDataAddressingMode addressingMode;

  /// Register list.
  final RegisterList registerList;

  BlockDataTransfer._({
    @required Condition condition,
    @required bool addOffsetBeforeTransfer,
    @required bool addOffsetToBase,
    @required bool writeAddressIntoBase,
    @required bool loadFromMemory,
    @required RegisterAny base,
    @required this.addressingMode,
    @required this.registerList,
  }) : super._(
          condition: condition,
          addOffsetBeforeTransfer: addOffsetBeforeTransfer,
          addOffsetToBase: addOffsetToBase,
          writeAddressIntoBaseOrForceNonPrivilegedAccess: writeAddressIntoBase,
          loadFromMemory: loadFromMemory,
          base: base,
        );
}

class BlockDataAddressingMode {
  const BlockDataAddressingMode._();
}

@immutable
@sealed
abstract class SingleDataSwap
    /**/ extends ArmInstruction
    /**/ implements
        HasTransferByte {
  /// `B`: Whether to transfer a byte (8-bits, `1`) otherwise a word (32, `0`).
  @override
  final bool transferByte;

  /// Base register.
  final RegisterNotPC base;

  /// Destination register.
  final RegisterNotPC destination;

  /// Source register.
  final RegisterNotPC source;

  SingleDataSwap._({
    @required Condition condition,
    @required this.transferByte,
    @required this.base,
    @required this.destination,
    @required this.source,
  }) : super._(condition: condition);
}
