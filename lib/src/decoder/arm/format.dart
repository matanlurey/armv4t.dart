import 'dart:convert';

import 'package:armv4t/src/common/binary.dart';
import 'package:binary/binary.dart';
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