part of '../instruction.dart';

abstract class DataTransferArmInstruction extends ArmInstruction {
  /// `P`: Whether to add offset before transfer (`1`), otherwise after (`0`).
  final bool addOffsetBeforeTransfer;

  /// `U`: Whether to add offset to base (`1`), otherwise subtract from (`0`).
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

  /// Whether to force non-privileged (user mode) access.
  ///
  /// > This is `true` when [writeAddressIntoBaseOrForceNonPrivilegedAccess] is
  /// > `true` (`W` set) but [addOffsetBeforeTransfer] is also `true` (`P` set);
  /// > [writeAddressIntoBase] is _always_ `true` when [addOffsetBeforeTransfer]
  /// > is `true`.
  bool get forceNonPrivilegedAccess {
    if (writeAddressIntoBaseOrForceNonPrivilegedAccess) {
      return addOffsetBeforeTransfer;
    } else {
      return false;
    }
  }

  /// `W`: Whether to write address into base (`1`), otherwise (`0`).
  ///
  /// > If [addOffsetBeforeTransfer] is cleared, this is _always_ `true`.
  bool get writeAddressIntoBase {
    if (writeAddressIntoBaseOrForceNonPrivilegedAccess) {
      return true;
    } else if (!addOffsetBeforeTransfer) {
      return true;
    } else {
      return false;
    }
  }
}

mixin HasWriteBackOnly on DataTransferArmInstruction {
  /// `W`: Whether to write address into base (`1`), otherwise (`0`).
  ///
  /// > If [addOffsetBeforeTransfer] is set, this is _always_ `true`.
  @override
  bool get writeAddressIntoBase {
    return writeAddressIntoBaseOrForceNonPrivilegedAccess;
  }
}

abstract class HasTransferByte implements ArmInstruction {
  /// `B`: Whether to transfer a byte (8-bits, `1`) otherwise a word (32, `0`).
  bool get transferByte;
}

/// These instructions load/store a value of a single register from/to memory.
///
/// They can load or store a 32-bit word or 8-bit unsigned byte. In ARM
/// architecture v4 and above (i.e. this package) they can also load or store
/// a 16-bit unsigned halfword [HalfwordDataTransferArmInstruction], or load
/// and sign extend a 16-bit halfword or an 8-bit byte.
///
/// ## Offsets and auto-indexing
///
/// The [offset] from the [base] may either be a 12-bit unsigned binary
/// immediate value in the instruction, or a second register (possibly shifted
/// in some way). The [offset] may be added to ([addOffsetToBase] = `true`) or
/// subtracted from  ([addOffsetToBase] = `false`).
///
/// The [offset] modification may be performed either before (
/// [addOffsetBeforeTransfer] = `false`) or after ([addOffsetBeforeTransfer] =
/// `true`) the base is used as the transfer address.
///
/// The `W` bit ([writeAddressIntoBaseOrForceNonPrivilegedAccess]) gives
/// optional auto-incrment and decrement addressing modes. The modified base
/// value may be written back to the base (or kept if = `false`).
///
/// > NOTE: In the case of [addOffsetBeforeTransfer] = `false`, or post-indexing
/// > that write-back is redundant and is _always_ cleared, sinc th old base
/// > value can be retained by setting the [offset] to `0`. Therefore
/// > post-indexed data transfers _always_ write back the modified base, and the
/// > only use of [writeAddressIntoBaseOrForceNonPrivilegedAccess] is in
/// > privileged-mode code, where set forces non-priveleged mode for the
/// > transfer, allowing the operating system to gnerate a usr address in a
/// > system where memory management hardware makes suitable use of this
/// > hardware.
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

  @override
  List<Object> _values() {
    return [
      condition,
      addOffsetBeforeTransfer,
      addOffsetToBase,
      writeAddressIntoBaseOrForceNonPrivilegedAccess,
      transferByte,
      base,
      sourceOrDestination,
      offset,
    ];
  }
}

/// See also [SingleDataTransferArmInstruction], a similar instruction set.
@immutable
@sealed
abstract class HalfwordDataTransferArmInstruction
    /**/ extends DataTransferArmInstruction
    /**/ with
        HasWriteBackOnly {
  /// Source or destination register (`Rd`).
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

  @override
  List<Object> _values() {
    return [
      condition,
      addOffsetBeforeTransfer,
      addOffsetToBase,
      writeAddressIntoBaseOrForceNonPrivilegedAccess,
      base,
      sourceOrDestination,
      offset,
    ];
  }
}

/// These instructions load or store any subset of general purpose registers.
@immutable
@sealed
abstract class BlockDataTransferArmInstruction
    /**/ extends DataTransferArmInstruction
    /**/ with
        HasWriteBackOnly {
  /// Register list.
  final RegisterList<RegisterAny> registerList;

  /// `S`: Whether to load PSR or force user mode (`1`) or not.
  final bool loadPsrOrForceUserMode;

  BlockDataTransferArmInstruction._({
    @required Condition condition,
    @required bool addOffsetBeforeTransfer,
    @required bool addOffsetToBase,
    @required bool writeAddressIntoBase,
    @required this.loadPsrOrForceUserMode,
    @required RegisterAny base,
    @required this.registerList,
  }) : super._(
          condition: condition,
          addOffsetBeforeTransfer: addOffsetBeforeTransfer,
          addOffsetToBase: addOffsetToBase,
          writeAddressIntoBaseOrForceNonPrivilegedAccess: writeAddressIntoBase,
          base: base,
        );

  @override
  @protected
  bool get writeAddressIntoBaseOrForceNonPrivilegedAccess {
    return super.writeAddressIntoBaseOrForceNonPrivilegedAccess;
  }

  @override
  List<Object> _values() {
    return [
      condition,
      addOffsetBeforeTransfer,
      addOffsetToBase,
      writeAddressIntoBase,
      base,
      registerList,
    ];
  }
}
