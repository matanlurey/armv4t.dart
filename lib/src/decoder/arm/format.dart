/// {@category arm}
/// {@subCategory formats}
library armv4t.decoder.arm.format;

import 'dart:convert';

import 'package:armv4t/src/common/assert.dart';
import 'package:armv4t/src/common/binary.dart';
import 'package:binary/binary.dart';
import 'package:collection/collection.dart';
import 'package:meta/meta.dart';

part 'format/block_data_transfer.dart';
part 'format/branch.dart';
part 'format/branch_and_exchange.dart';
part 'format/data_processing_or_psr_transfer.dart';
part 'format/halfword_data_transfer.dart';
part 'format/multiply.dart';
part 'format/multiply_long.dart';
part 'format/single_data_swap.dart';
part 'format/single_data_transfer.dart';
part 'format/software_interrupt.dart';

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

  @visibleForOverriding
  Map<String, int> _values();

  @override
  int get hashCode => const MapEquality<Object, Object>().hash(_values());

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) {
      return true;
    }
    if (o is ArmFormat && runtimeType == o.runtimeType) {
      return const MapEquality<Object, Object>().equals(_values(), o._values());
    } else {
      return false;
    }
  }

  @override
  String toString() {
    if (assertionsEnabled) {
      final output = StringBuffer();
      output.writeln('$runtimeType:');
      _values().forEach((key, value) {
        output.writeln('  $key: $value');
      });
      return output.toString();
    } else {
      return super.toString();
    }
  }
}

/// Converts a known 32-bit integer into a partially decoded [ArmFormat].
class ArmFormatDecoder extends Converter<Uint32, ArmFormat> {
  static final _dataProcessingOrPsrTransfer = BitPatternBuilder.parse(
    'CCCC_00IP_PPPS_NNNN_DDDD_OOOO_OOOO_OOOO',
  ).build('DATA_PROCESSING_OR_PSR_TRANSFER');

  static final _multiply = BitPatternBuilder.parse(
    'CCCC_0000_00AS_DDDD_NNNN_FFFF_1001_MMMM',
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
    'CCCC_000P_UIWL_NNNN_DDDD_JJJJ_1HH1_MMMM',
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

  static final _allKnownPatterns = BitPatternGroup([
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
  ]);

  const ArmFormatDecoder();

  /// Converts a 32-bit [input] into a decoded [ArmFormat].
  ///
  /// If there is no matching instruction [FormatException] is thrown.
  @override
  ArmFormat convert(Uint32 input) {
    final pattern = _allKnownPatterns.match(input.value);
    final capture = pattern?.capture(input.value) ?? const [];
    if (identical(pattern, _dataProcessingOrPsrTransfer)) {
      return DataProcessingOrPsrTransferArmFormat(
        condition: Uint4(capture[0]),
        immediateOperand: capture[1] == 1,
        opCode: Uint4(capture[2]),
        setConditionCodes: capture[3] == 1,
        operand1Register: Uint4(capture[4]),
        destinationRegister: Uint4(capture[5]),
        operand2: Uint12(capture[6]),
      );
    } else if (identical(pattern, _multiply)) {
      return MultiplyArmFormat(
        condition: Uint4(capture[0]),
        accumulate: capture[1] == 1,
        setConditionCodes: capture[2] == 1,
        destinationRegister: Uint4(capture[3]),
        operandRegister1: Uint4(capture[4]),
        operandRegister2: Uint4(capture[5]),
        operandRegister3: Uint4(capture[6]),
      );
    } else if (identical(pattern, _multiplyLong)) {
      return MultiplyLongArmFormat(
        condition: Uint4(capture[0]),
        signed: capture[1] == 1,
        accumulate: capture[2] == 1,
        setConditionCodes: capture[3] == 1,
        destinationRegisterHi: Uint4(capture[4]),
        destinationRegisterLo: Uint4(capture[5]),
        operandRegister1: Uint4(capture[6]),
        operandRegister2: Uint4(capture[7]),
      );
    } else if (identical(pattern, _singleDataSwap)) {
      return SingleDataSwapArmFormat(
        condition: Uint4(capture[0]),
        swapByteQuantity: capture[1] == 1,
        baseRegister: Uint4(capture[2]),
        destinationRegister: Uint4(capture[3]),
        sourceRegister: Uint4(capture[4]),
      );
    } else if (identical(pattern, _branchAndExchange)) {
      return BranchAndExchangeArmFormat(
        condition: Uint4(capture[0]),
        operand: Uint4(capture[1]),
      );
    } else if (identical(pattern, _halfWordDataTransfer)) {
      return HalfwordDataTransferArmFormat(
        condition: Uint4(capture[0]),
        preIndexingBit: capture[1] == 1,
        addOffsetBit: capture[2] == 1,
        immediateOffset: capture[3] == 1,
        writeAddressBit: capture[4] == 1,
        loadMemoryBit: capture[5] == 1,
        baseRegister: Uint4(capture[6]),
        sourceOrDestinationRegister: Uint4(capture[7]),
        offsetHiNibble: Uint4(capture[8]),
        opCode: Uint2(capture[9]),
        offsetLoNibble: Uint4(capture[10]),
      );
    } else if (identical(pattern, _singleDataTransfer)) {
      return SingleDataTransferArmFormat(
        condition: Uint4(capture[0]),
        immediateOffset: capture[1] == 0,
        preIndexingBit: capture[2] == 1,
        addOffsetBit: capture[3] == 1,
        byteQuantityBit: capture[4] == 1,
        writeAddressBit: capture[5] == 1,
        loadMemoryBit: capture[6] == 1,
        baseRegister: Uint4(capture[7]),
        sourceOrDestinationRegister: Uint4(capture[8]),
        offset: Uint12(capture[9]),
      );
    } else if (identical(pattern, _blockDataTransfer)) {
      return BlockDataTransferArmFormat(
        condition: Uint4(capture[0]),
        preIndexingBit: capture[1] == 1,
        addOffsetBit: capture[2] == 1,
        loadPsrOrForceUserMode: capture[3] == 1,
        writeAddressBit: capture[4] == 1,
        loadMemoryBit: capture[5] == 1,
        baseRegister: Uint4(capture[6]),
        registerList: Uint16(capture[7]),
      );
    } else if (identical(pattern, _branch)) {
      return BranchArmFormat(
        condition: Uint4(capture[0]),
        link: capture[1] == 1,
        offset: Uint24(capture[2]),
      );
    } else if (identical(pattern, _softwareInterrupt)) {
      return SoftwareInterruptArmFormat(
        condition: Uint4(capture[0]),
        comment: Uint24(capture[1]),
      );
    } else {
      throw FormatException('Unknown format: ${input.value.toRadixString(16)}');
    }
  }
}

/// Visits all known implementations of [ArmFormat].
abstract class ArmFormatVisitor<R, C> {
  /// Invoked by [DataProcessingOrPsrTransferArmFormat.accept].
  R visitDataProcessingOrPsrTransfer(
    DataProcessingOrPsrTransferArmFormat format, [
    C context,
  ]);

  /// Invoked by [MultiplyArmFormat.accept].
  R visitMultiply(
    MultiplyArmFormat format, [
    C context,
  ]);

  /// Invoked by [MultiplyLongArmFormat.accept].
  R visitMultiplyLong(
    MultiplyLongArmFormat format, [
    C context,
  ]);

  /// Invoked by [SingleDataSwapArmFormat.accept].
  R visitSingleDataSwap(
    SingleDataSwapArmFormat format, [
    C context,
  ]);

  /// Invoked by [BranchAndExchangeArmFormat.accept].
  R visitBranchAndExchange(
    BranchAndExchangeArmFormat format, [
    C context,
  ]);

  /// Invoked by [HalfwordDataTransferArmFormat.accept].
  R visitHalfwordDataTransfer(
    HalfwordDataTransferArmFormat format, [
    C context,
  ]);

  /// Invoked by [SingleDataTransferArmFormat.accept].
  R visitSingleDataTransfer(
    SingleDataTransferArmFormat format, [
    C context,
  ]);

  /// Invoked by [BlockDataTransferArmFormat.accept].
  R visitBlockDataTransfer(
    BlockDataTransferArmFormat format, [
    C context,
  ]);

  /// Invoked by [BranchArmFormat.accept].
  R visitBranch(
    BranchArmFormat format, [
    C context,
  ]);

  /// Invoked by [SoftwareInterruptArmFormat.accept].
  R visitSoftwareInterrupt(
    SoftwareInterruptArmFormat format, [
    C context,
  ]);
}

/// Converts an [ArmFormat] back to a [Uint32].
abstract class ArmFormatEncoder implements Converter<ArmFormat, Uint32> {
  const factory ArmFormatEncoder() = _ArmFormatEncoder;
}

class _ArmFormatEncoder
    /***/ extends Converter<ArmFormat, Uint32>
    /***/ implements
        ArmFormatEncoder,
        ArmFormatVisitor<Uint32, void> {
  const _ArmFormatEncoder();

  @override
  Uint32 convert(ArmFormat format) => format.accept(this);

  @override
  Uint32 visitDataProcessingOrPsrTransfer(
    DataProcessingOrPsrTransferArmFormat format, [
    void _,
  ]) =>
      // CCCC_00IP_PPPS_NNNN_DDDD_OOOO_OOOO_OOOO
      (Uint32Builder()
            // CCCC
            ..writeInt(format.condition)
            // 00
            ..write('00')
            // I
            ..writeBool(format.immediateOperand)
            // P_PPP
            ..writeInt(format.opCode)
            // S
            ..writeBool(format.setConditionCodes)
            // NNNN
            ..writeInt(format.operand1Register)
            // DDDD
            ..writeInt(format.destinationRegister)
            // OOOO_OOOO_OOOO
            ..writeInt(format.operand2))
          .build();

  @override
  Uint32 visitMultiply(
    MultiplyArmFormat format, [
    void _,
  ]) =>
      // CCCC_0000_00AS_DDDD_NNNN_FFFF_1001_MMMM
      (Uint32Builder()
            // CCCC
            ..writeInt(format.condition)
            // 0000_00
            ..write('0000' '00')
            // A
            ..writeBool(format.accumulate)
            // S
            ..writeBool(format.setConditionCodes)
            // DDDD
            ..writeInt(format.destinationRegister)
            // NNNN
            ..writeInt(format.operandRegister1)
            // FFFF
            ..writeInt(format.operandRegister2)
            // 1001
            ..write('1001')
            // MMMM
            ..writeInt(format.operandRegister3))
          .build();

  @override
  Uint32 visitMultiplyLong(
    MultiplyLongArmFormat format, [
    void _,
  ]) =>
      // CCCC_0000_1UAS_HHHH_LLLL_NNNN_1001_MMMM
      (Uint32Builder()
            // CCCC
            ..writeInt(format.condition)
            // 0000_1
            ..write('0000' '1')
            // U
            ..writeBool(format.signed)
            // A
            ..writeBool(format.accumulate)
            // S
            ..writeBool(format.setConditionCodes)
            // H
            ..writeInt(format.destinationRegisterHi)
            // L
            ..writeInt(format.destinationRegisterLo)
            // N
            ..writeInt(format.operandRegister1)
            // 1001
            ..write('1001')
            // M
            ..writeInt(format.operandRegister2))
          .build();

  @override
  Uint32 visitSingleDataSwap(
    SingleDataSwapArmFormat format, [
    void _,
  ]) =>
      // CCCC_0001_0B00_NNNN_DDDD_0000_1001_MMMM
      (Uint32Builder()
            // CCCC
            ..writeInt(format.condition)
            // 0001_0
            ..write('0001' '0')
            // B
            ..writeBool(format.swapByteQuantity)
            // 00
            ..write('00')
            // NNNN
            ..writeInt(format.baseRegister)
            // DDDD
            ..writeInt(format.destinationRegister)
            // 0000_1001
            ..write('0000' '1001')
            // MMMM
            ..writeInt(format.sourceRegister))
          .build();

  @override
  Uint32 visitBranchAndExchange(
    BranchAndExchangeArmFormat format, [
    void _,
  ]) =>
      // CCCC_0001_0010_1111_1111_1111_0001_NNNN
      (Uint32Builder()
            // CCCC
            ..writeInt(format.condition)
            // 0001_0010_1111_1111_1111_0001
            ..write('0001' '0010' '1111' '1111' '1111' '0001')
            // NNNN
            ..writeInt(format.operand))
          .build();

  @override
  Uint32 visitHalfwordDataTransfer(
    HalfwordDataTransferArmFormat format, [
    void _,
  ]) =>
      // CCCC_000P_UIWL_NNNN_DDDD_JJJJ_1HH1_MMMM
      (Uint32Builder()
            // CCCC
            ..writeInt(format.condition)
            // 000
            ..write('000')
            // P
            ..writeBool(format.preIndexingBit)
            // U
            ..writeBool(format.addOffsetBit)
            // I
            ..writeBool(format.immediateOffset)
            // W
            ..writeBool(format.writeAddressBit)
            // L
            ..writeBool(format.loadMemoryBit)
            // NNNN
            ..writeInt(format.baseRegister)
            // DDDD
            ..writeInt(format.sourceOrDestinationRegister)
            // JJJJ
            ..writeInt(format.offsetHiNibble)
            // 1
            ..write('1')
            // HH
            ..writeInt(format.opCode)
            // 1
            ..write('1')
            // MMMM
            ..writeInt(format.offsetLoNibble))
          .build();

  @override
  Uint32 visitSingleDataTransfer(
    SingleDataTransferArmFormat format, [
    void _,
  ]) =>
      // CCCC_01IP_UBWL_NNNN_DDDD_OOOO_OOOO_OOOO
      (Uint32Builder()
            // CCCC
            ..writeInt(format.condition)
            // 01
            ..write('01')
            // I
            ..writeBool(!format.immediateOffset)
            // P
            ..writeBool(format.preIndexingBit)
            // U
            ..writeBool(format.addOffsetBit)
            // B
            ..writeBool(format.byteQuantityBit)
            // W
            ..writeBool(format.writeAddressBit)
            // L
            ..writeBool(format.loadMemoryBit)
            // NNNN
            ..writeInt(format.baseRegister)
            // DDDD
            ..writeInt(format.sourceOrDestinationRegister)
            // OOOO
            ..writeInt(format.offset))
          .build();

  @override
  Uint32 visitBlockDataTransfer(
    BlockDataTransferArmFormat format, [
    void _,
  ]) =>
      // CCCC_100P_USWL_NNNN_RRRR_RRRR_RRRR_RRRR
      (Uint32Builder()
            // CCCC
            ..writeInt(format.condition)
            // 100
            ..write('100')
            // P
            ..writeBool(format.preIndexingBit)
            // U
            ..writeBool(format.addOffsetBit)
            // S
            ..writeBool(format.loadPsrOrForceUserMode)
            // W
            ..writeBool(format.writeAddressBit)
            // L
            ..writeBool(format.loadMemoryBit)
            // NNNN
            ..writeInt(format.baseRegister)
            // RRRR_RRRR_RRRR_RRRR
            ..writeInt(format.registerList))
          .build();

  @override
  Uint32 visitBranch(
    BranchArmFormat format, [
    void _,
  ]) =>
      // CCCC_101L_OOOO_OOOO_OOOO_OOOO_OOOO_OOOO
      (Uint32Builder()
            // CCCC
            ..writeInt(format.condition)
            // 101
            ..write('101')
            // L
            ..writeBool(format.link)
            // OOOO_OOOO_OOOO_OOOO_OOOO_OOOO
            ..writeInt(format.offset))
          .build();

  @override
  Uint32 visitSoftwareInterrupt(
    SoftwareInterruptArmFormat format, [
    void _,
  ]) =>
      // CCCC_1111_XXXX_XXXX_XXXX_XXXX_XXXX_XXXX
      (Uint32Builder()
            // CCCC
            ..writeInt(format.condition)
            // 1111
            ..write('1111')
            // XXXX_XXXX_XXXX_XXXX_XXXX_XXXX
            ..writeInt(format.comment))
          .build();
}
