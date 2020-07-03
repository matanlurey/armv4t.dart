part of '../instruction.dart';

abstract class DataTransferArmInstruction extends ArmInstruction {
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
  final bool writeAddressIntoBaseOrForceNonPrivilegedAccess;

  /// Base register.
  final RegisterAny base;

  DataTransferArmInstruction._({
    @required Condition condition,
    @required this.addOffsetBeforeTransfer,
    @required this.addOffsetToBase,
    @required this.writeAddressIntoBaseOrForceNonPrivilegedAccess,
    @required this.base,
  }) : super._(condition: condition);
}

mixin HasWriteBackOnly on DataTransferArmInstruction {
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
abstract class SingleDataTransferArmInstruction
    /**/ extends DataTransferArmInstruction
    /**/ implements
        HasTransferByte {
  /// `B`: Whether to transfer a byte (8-bits, `1`) otherwise a word (32, `0`).
  @override
  final bool transferByte;

  /// Source or destination register (`Rd`).
  @protected
  final RegisterAny sourceOrDestination;

  /// Either an unsigned 12-bit immediate or register shifted by immediate.
  final Or2<Immediate<Uint12>, ShiftedRegister<Immediate<Uint4>, RegisterNotPC>>
      offset;

  SingleDataTransferArmInstruction._({
    @required Condition condition,
    @required bool addOffsetBeforeTransfer,
    @required bool addOffsetToBase,
    @required bool writeAddressIntoBaseOrForceNonPrivilegedAccess,
    @required this.transferByte,
    @required RegisterAny base,
    @required this.sourceOrDestination,
    @required this.offset,
  }) : super._(
          condition: condition,
          addOffsetBeforeTransfer: addOffsetBeforeTransfer,
          addOffsetToBase: addOffsetToBase,
          writeAddressIntoBaseOrForceNonPrivilegedAccess:
              writeAddressIntoBaseOrForceNonPrivilegedAccess,
          base: base,
        );
}

@immutable
@sealed
abstract class HalfwordDataTransferArmInstruction
    /**/ extends DataTransferArmInstruction
    /**/ with
        HasWriteBackOnly {
  /// Source or destination register (`Rd`).
  @protected
  final RegisterAny sourceOrDestination;

  /// Either an offset register or 8-bit immediate offset.
  final Or2<RegisterNotPC, Immediate<Uint8>> offset;

  HalfwordDataTransferArmInstruction._({
    @required Condition condition,
    @required bool addOffsetBeforeTransfer,
    @required bool addOffsetToBase,
    @required bool writeAddressIntoBase,
    @required RegisterAny base,
    @required this.sourceOrDestination,
    @required this.offset,
  }) : super._(
          condition: condition,
          addOffsetBeforeTransfer: addOffsetBeforeTransfer,
          addOffsetToBase: addOffsetToBase,
          writeAddressIntoBaseOrForceNonPrivilegedAccess: writeAddressIntoBase,
          base: base,
        );
}

@immutable
@sealed
abstract class BlockDataTransferArmInstruction
    /**/ extends DataTransferArmInstruction
    /**/ with
        HasWriteBackOnly {
  /// Register list.
  final RegisterList<RegisterAny> registerList;

  BlockDataTransferArmInstruction._({
    @required Condition condition,
    @required bool addOffsetBeforeTransfer,
    @required bool addOffsetToBase,
    @required bool writeAddressIntoBase,
    @required RegisterAny base,
    @required this.registerList,
  }) : super._(
          condition: condition,
          addOffsetBeforeTransfer: addOffsetBeforeTransfer,
          addOffsetToBase: addOffsetToBase,
          writeAddressIntoBaseOrForceNonPrivilegedAccess: writeAddressIntoBase,
          base: base,
        );
}
