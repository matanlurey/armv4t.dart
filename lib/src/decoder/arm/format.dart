import 'dart:convert';

import 'package:armv4t/src/common/binary.dart';
import 'package:binary/binary.dart';
import 'package:meta/meta.dart';

/// A decoded _ARM_ instruction _format_.
///
/// This is an intermediate decoding in between the raw bits and a completely
/// decoded instruction that has resolved ambiguities in the decoding and the
/// internal data structures.
@immutable
@sealed
abstract class ArmFormat {
  /// Conditional execution operation code.
  final Uint4 condition;

  const ArmFormat._({
    @required this.condition,
  });

  /// Invokes a specific method of the provided [visitor].
  R accept<R, C>(ArmFormatVisitor<R, C> visitor, [C context]);
}

/// Converts a known 32-bit integer into a partially decoded [ArmFormat].
class ArmFormatDecoder extends Converter<Uint32, ArmFormat> {
  static final _dataProcessingOrPsrTransfer = BitPatternBuilder.parse(
    'CCCC_00IP_PPPS_NNNN_DDDD_OOOO_OOOO_OOOO',
  ).build('DATA_PROCESSING_OR_PSR_TRANSFER');

  static final _multiply = BitPatternBuilder.parse(
    'CCCC_0000_00AS_DDDD_NNNN_SSSS_1001_MMMM',
  ).build('MULTIPLY');

  static final _multiplyLong = BitPatternBuilder.parse(
    'CCCC_0000_1UAS_HHHH_LLLL_NNNN_1001_MMMM',
  ).build('MULTIPLY_LONG');

  static final _singleDataSwap = BitPatternBuilder.parse(
    'CCCC_0001_0B00_NNNN_DDDD_0000_1001_MMMM',
  ).build('SINGLE_DATA_SWAP');

  static final _branchAndExchange = BitPatternBuilder.parse(
    'CCCC_0001_0010_1111_1111_1111_0001_NNNN',
  ).build('BRANCH_AND_EXCHANGE');

  static final _halfWordDataTransfer = BitPatternBuilder.parse(
    'CCCC_000P_UIWL_NNNN_DDDD_0000_1HH1_MMMM',
  ).build('HALF_WORD_DATA_TRANSFER');

  static final _singleDataTransfer = BitPatternBuilder.parse(
    'CCCC_01IP_UBWL_NNNN_DDDD_OOOO_OOOO_OOOO',
  ).build('SINGLE_DATA_TRANSFER');

  static final _blockDataTransfer = BitPatternBuilder.parse(
    'CCCC_100P_USWL_NNNN_RRRR_RRRR_RRRR_RRRR',
  ).build('BLOCK_DATA_TRANSFER');

  static final _branch = BitPatternBuilder.parse(
    'CCCC_101L_OOOO_OOOO_OOOO_OOOO_OOOO_OOOO',
  ).build('BRANCH');

  static final _softwareInterrupt = BitPatternBuilder.parse(
    'CCCC_1111_XXXX_XXXX_XXXX_XXXX_XXXX_XXXX',
  ).build('SOFTWARE_INTERRUPT');

  static final _allKnownPatterns = [
    _dataProcessingOrPsrTransfer,
    _multiply,
    _multiplyLong,
    _singleDataSwap,
    _branchAndExchange,
    _halfWordDataTransfer,
    _singleDataTransfer,
    _blockDataTransfer,
    _branch,
    _softwareInterrupt,
  ].toGroup();

  const ArmFormatDecoder();

  /// Converts a 32-bit [input] into a decoded [ArmFormat].
  ///
  /// If there is no matching instruction [FormatException] is thrown.
  @override
  ArmFormat convert(Uint32 input) {
    final pattern = _allKnownPatterns.match(input.value);
    final capture = pattern?.capture(input.value) ?? const [];
    if (identical(pattern, _dataProcessingOrPsrTransfer)) {
      return DataProcessingOrPsrTransfer(
        condition: capture[0].asUint4(),
        immediateOperand: capture[1] == 1,
        opCode: capture[2].asUint4(),
        setConditionCodes: capture[3] == 1,
        operand1Register: capture[4].asUint4(),
        destinationRegister: capture[5].asUint4(),
        operand2: Uint12(capture[6]),
      );
    } else if (identical(pattern, _multiply)) {
      return Multiply(
        condition: capture[0].asUint4(),
        accumulate: capture[1] == 1,
        setConditionCodes: capture[2] == 1,
        destinationRegister: capture[3].asUint4(),
        operandRegister1: capture[4].asUint4(),
        operandRegister2: capture[5].asUint4(),
        operandRegister3: capture[6].asUint4(),
      );
    } else if (identical(pattern, _multiplyLong)) {
      return MultiplyLong(
        condition: capture[0].asUint4(),
        signed: capture[1] == 1,
        accumulate: capture[2] == 1,
        setConditionCodes: capture[3] == 1,
        destinationRegisterHi: capture[4].asUint4(),
        destinationRegisterLo: capture[5].asUint4(),
        operandRegister1: capture[6].asUint4(),
        operandRegister2: capture[7].asUint4(),
      );
    } else if (identical(pattern, _singleDataSwap)) {
      return SingleDataSwap(
        condition: capture[0].asUint4(),
        swapByteQuantity: capture[1] == 1,
        baseRegister: capture[2].asUint4(),
        destinationRegister: capture[3].asUint4(),
        sourceRegister: capture[4].asUint4(),
      );
    } else if (identical(pattern, _branchAndExchange)) {
      return BranchAndExchange(
        condition: capture[0].asUint4(),
        operand: capture[1].asUint4(),
      );
    } else if (identical(pattern, _halfWordDataTransfer)) {
      return HalfwordDataTransfer(
        condition: capture[0].asUint4(),
        preIndexingBit: capture[1] == 1,
        addOffsetBit: capture[2] == 1,
        immediateOffset: capture[3] == 1,
        writeAddressBit: capture[4] == 1,
        loadMemoryBit: capture[5] == 1,
        baseRegister: capture[6].asUint4(),
        sourceOrDestinationRegister: capture[7].asUint4(),
        offsetHiNibble: capture[8].asUint4(),
        opCode: Uint2(capture[9]),
        offsetLoNibble: capture[10].asUint4(),
      );
    } else if (identical(pattern, _singleDataTransfer)) {
      return SingleDataTransfer(
        condition: capture[0].asUint4(),
        immediateOffset: capture[1] == 0,
        preIndexingBit: capture[2] == 1,
        addOffsetBit: capture[3] == 1,
        byteQuantityBit: capture[4] == 1,
        writeAddressBit: capture[5] == 1,
        loadMemoryBit: capture[6] == 1,
        baseRegister: capture[7].asUint4(),
        sourceOrDestinationRegister: capture[8].asUint4(),
        offset: Uint12(capture[9]),
      );
    } else if (identical(pattern, _blockDataTransfer)) {
      return BlockDataTransfer(
        condition: capture[0].asUint4(),
        preIndexingBit: capture[1] == 1,
        addOffsetBit: capture[2] == 1,
        loadPsrOrForceUserMode: capture[3] == 1,
        writeAddressBit: capture[4] == 1,
        loadMemoryBit: capture[5] == 1,
        baseRegister: capture[6].asUint4(),
        registerList: capture[7].asUint16(),
      );
    } else if (identical(pattern, _branch)) {
      return Branch(
        condition: capture[0].asUint4(),
        link: capture[1] == 1,
        offset: Uint24(capture[2]),
      );
    } else if (identical(pattern, _softwareInterrupt)) {
      return SoftwareInterrupt(
        condition: capture[0].asUint4(),
        comment: Uint24(capture[1]),
      );
    } else {
      throw FormatException('Unknown format: ${input.value.toRadixString(16)}');
    }
  }
}

/// Visits all known implementations of [ArmFormat].
abstract class ArmFormatVisitor<R, C> {
  /// Invoked by [DataProcessingOrPsrTransfer.accept].
  R visitDataProcessingOrPsrTransfer(
    DataProcessingOrPsrTransfer format, [
    C context,
  ]);

  /// Invoked by [Multiply.accept].
  R visitMultiply(
    Multiply format, [
    C context,
  ]);

  /// Invoked by [MultiplyLong.accept].
  R visitMultiplyLong(
    MultiplyLong format, [
    C context,
  ]);

  /// Invoked by [SingleDataSwap.accept].
  R visitSingleDataSwap(
    SingleDataSwap format, [
    C context,
  ]);

  /// Invoked by [BranchAndExchange.accept].
  R visitBranchAndExchange(
    BranchAndExchange format, [
    C context,
  ]);

  /// Invoked by [HalfwordDataTransfer.accept].
  R visitHalfwordDataTransfer(
    HalfwordDataTransfer format, [
    C context,
  ]);

  /// Invoked by [SingleDataTransfer.accept].
  R visitSingleDataTransfer(
    SingleDataTransfer format, [
    C context,
  ]);

  /// Invoked by [BlockDataTransfer.accept].
  R visitBlockDataTransfer(
    BlockDataTransfer format, [
    C context,
  ]);

  /// Invoked by [Branch.accept].
  R visitBranch(
    Branch format, [
    C context,
  ]);

  /// Invoked by [SoftwareInterrupt.accept].
  R visitSoftwareInterrupt(
    SoftwareInterrupt format, [
    C context,
  ]);
}

/// A decoded _Data Processing_ or _PSR Transfer_ instruction _format_.
@sealed
class DataProcessingOrPsrTransfer extends ArmFormat {
  /// Whether [operand2] is an immediate value (`1`) or a register (`0`).
  final bool immediateOperand;

  /// Operation code.
  final Uint4 opCode;

  /// Whether to set condition codes (`1`) or not (`0`).
  final bool setConditionCodes;

  /// First operand (register).
  final Uint4 operand1Register;

  /// Destination register.
  final Uint4 destinationRegister;

  /// Second operand (see [immediateOperand]).
  final Uint12 operand2;

  const DataProcessingOrPsrTransfer({
    @required Uint4 condition,
    @required this.immediateOperand,
    @required this.opCode,
    @required this.setConditionCodes,
    @required this.operand1Register,
    @required this.destinationRegister,
    @required this.operand2,
  }) : super._(condition: condition);

  @override
  R accept<R, C>(ArmFormatVisitor<R, C> visitor, [C context]) {
    return visitor.visitDataProcessingOrPsrTransfer(this, context);
  }
}

/// A decoded _Multiply/Multiply-Accumulate_ instruction _format_.
@sealed
class Multiply extends ArmFormat {
  /// Whether to multiply and accumulate (`1`) or multiply only (`0`).
  final bool accumulate;

  /// Whether to set condition codes (`1`) or not (`0`).
  final bool setConditionCodes;

  /// Destination register.
  final Uint4 destinationRegister;

  /// First operand register.
  final Uint4 operandRegister1;

  /// Second operand register.
  final Uint4 operandRegister2;

  /// Third operand register.
  final Uint4 operandRegister3;

  const Multiply({
    @required Uint4 condition,
    @required this.accumulate,
    @required this.setConditionCodes,
    @required this.destinationRegister,
    @required this.operandRegister1,
    @required this.operandRegister2,
    @required this.operandRegister3,
  }) : super._(condition: condition);

  @override
  R accept<R, C>(ArmFormatVisitor<R, C> visitor, [C context]) {
    return visitor.visitMultiply(this, context);
  }
}

/// A decoded _Multiply Long/Multiply-Accumulate Long_ instruction _format_.
@sealed
class MultiplyLong extends ArmFormat {
  /// Whether to perform a signed (`1`) or unsigned (`0`) instruction.
  final bool signed;

  /// Whether to multiply and accumulate (`1`) or multiply only (`0`).
  final bool accumulate;

  /// Whether to set condition codes (`1`) or not (`0`).
  final bool setConditionCodes;

  /// Destination register (_Hi_ bits).
  final Uint4 destinationRegisterHi;

  /// Destination register (_Lo_ bits).
  final Uint4 destinationRegisterLo;

  /// First operand register.
  final Uint4 operandRegister1;

  /// Second operand register.
  final Uint4 operandRegister2;

  const MultiplyLong({
    @required Uint4 condition,
    @required this.signed,
    @required this.accumulate,
    @required this.setConditionCodes,
    @required this.destinationRegisterHi,
    @required this.destinationRegisterLo,
    @required this.operandRegister1,
    @required this.operandRegister2,
  }) : super._(condition: condition);

  @override
  R accept<R, C>(ArmFormatVisitor<R, C> visitor, [C context]) {
    return visitor.visitMultiplyLong(this, context);
  }
}

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

/// A decoded _Halfword and Signed Data Transfer_ instruction _format_.
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

/// A decoded _Single Data Transfer_ instruction _format_.
@sealed
class SingleDataTransfer extends ArmFormat {
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

  const SingleDataTransfer({
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
}

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

/// A decoded _Software Interrupt_ instruction _format_.
@sealed
class SoftwareInterrupt extends ArmFormat {
  /// Comment field (ignored by processor).
  final Uint24 comment;

  const SoftwareInterrupt({
    @required Uint4 condition,
    @required this.comment,
  }) : super._(condition: condition);

  @override
  R accept<R, C>(ArmFormatVisitor<R, C> visitor, [C context]) {
    return visitor.visitSoftwareInterrupt(this, context);
  }
}
