import 'dart:collection';

import 'package:binary/binary.dart';
import 'package:collection/collection.dart';
import 'package:meta/meta.dart';

part 'format/block_data_transfer.dart';
part 'format/branch.dart';
part 'format/branch_and_exchange.dart';
part 'format/coprocessor_data_operation.dart';
part 'format/coprocessor_data_transfer.dart';
part 'format/coprocessor_register_transfer.dart';
part 'format/data_processing_or_psr_transfer.dart';
part 'format/halfword_data_transfer_immediate_offset.dart';
part 'format/halfword_data_transfer_register_offset.dart';
part 'format/multiply.dart';
part 'format/multiply_long.dart';
part 'format/single_data_swap.dart';
part 'format/single_data_transfer.dart';
part 'format/software_interrupt.dart';
part 'format/undefined.dart';

/// An **internal** package representing all known `ARM` instruction sets.
///
/// For testing, individual [BitPattern] implementations are accessible as
/// static fields (e.g. `[$01$moveShiftedRegister]`), and a sorted
/// [BitPatternGroup] is accessible as [allFormats].
abstract class ArmInstructionSet {
  /// Data Processing/PSR Transfer.
  static final $01$dataProcessingOrPsrTransfer = BitPatternBuilder.parse(
    'CCCC_00IP_PPPS_NNNN_DDDD_OOOO_OOOO_OOOO',
  ).build('01:DATA_PROCESSING_OR_PSR_TRANSFER');

  /// Multiply.
  static final $02$multiply = BitPatternBuilder.parse(
    'CCCC_0000_00AS_DDDD_NNNN_FFFF_1001_MMMM',
  ).build('02:MULTIPLY');

  /// Multiply Long.
  static final $03$multiplyLong = BitPatternBuilder.parse(
    'CCCC_0000_1UAS_DDDD_FFFF_NNNN_1001_MMMM',
  ).build('03:MULTIPLY_LONG');

  /// Single Data Swap.
  static final $04$singleDataSwap = BitPatternBuilder.parse(
    'CCCC_0001_0B00_NNNN_DDDD_0000_1001_MMMM',
  ).build('04:SINGLE_DATA_SWAP');

  /// Branch and Exchange.
  static final $05$branchAndExchange = BitPatternBuilder.parse(
    'CCCC_0001_0010_1111_1111_1111_0001_NNNN',
  ).build('05:BRANCH_AND_EXCHANGE');

  /// Halfword Data Transfer: Register Offset.
  static final $06$halfWordDataTransferRegister = BitPatternBuilder.parse(
    'CCCC_000P_U0WL_NNNN_DDDD_OOOO_1SH1_KKKK',
  ).build('06:HALF_WORD_DATA_TRANSFER_REGISTER_OFFSET');

  /// Halfword Data Transfer: Immediate Offset.
  static final $07$halfWordDataTranseferImmediate = BitPatternBuilder.parse(
    'CCCC_000P_U1WL_NNNN_DDDD_OOOO_KKKK_KKKK',
  ).build('07:HALF_WORD_DATA_TRANSFER_IMMEDIATE_OFFSET');

  /// Single Data Transfer.
  static final $08$singleDataTransfer = BitPatternBuilder.parse(
    'CCCC_01IP_UBWL_NNNN_DDDD_OOOO_OOOO_OOOO',
  ).build('08:SINGLE_DATA_TRANSFER');

  /// Undefined.
  static final $09$undefined = BitPatternBuilder.parse(
    'CCCC_011X_XXXX_XXXX_XXXX_XXXX_XXX1_ZZZZ',
  ).build('09:UNDEFINED');

  /// Block Data Transfer.
  static final $10$blockDataTransfer = BitPatternBuilder.parse(
    'CCCC_100P_USWL_NNNN_RRRR_RRRR_RRRR_RRRR',
  ).build('10:BLOCK_DATA_TRANSFER');

  /// Branch.
  static final $11$branch = BitPatternBuilder.parse(
    'CCCC_101L_OOOO_OOOO_OOOO_OOOO_OOOO_OOOO',
  ).build('11:BRANCH');

  /// Coprocessor Data Transfer.
  static final $12$coprocessorDataTransfer = BitPatternBuilder.parse(
    'CCCC_110P_UNWL_MMMM_DDDD_KKKK_OOOO_OOOO',
  ).build('12:COPROCESSOR_DATA_TRANSFER');

  /// Coprocessor Data Operation.
  static final $13$coprocessorDataOperation = BitPatternBuilder.parse(
    'CCCC_1110_OOOO_NNNN_DDDD_PPPP_VVV0_MMMM',
  ).build('13:COPROCESSOR_DATA_OPERATION');

  /// Coprocessor Register Transfer.
  static final $14$coprocessorRegisterTransfer = BitPatternBuilder.parse(
    'CCCC_1110_OOOL_NNNN_DDDD_PPPP_VVV1_MMMM',
  ).build('14:COPROCESSOR_REGISTER_TRANSFER');

  /// Software Interrupt.
  static final $15$softwareInterrupt = BitPatternBuilder.parse(
    'CCCC_1111_XXXX_XXXX_XXXX_XXXX_XXXX_XXXX',
  ).build('15:SOFTWARE_INTERRUPT');

  /// A known list of all the different [ArmInstructionSetDecoder] instances.
  static final _decoders = [
    DataProcessingOrPSRTransfer.decoder,
    MultiplyAndMutiplyAccumulate.decoder,
    MultiplyLongAndMutiplyAccumulateLong.decoder,
    SingleDataSwap.decoder,
    BranchAndExchange.decoder,
    HalfWordAndSignedDataTransferRegisterOffset.decoder,
    HalfWordAndSignedDataTransferImmediateOffset.decoder,
    SingleDataTransfer.decoder,
    Undefined.decoder,
    BlockDataTransfer.decoder,
    Branch.decoder,
    CoprocessorDataTransfer.decoder,
    CoprocessorDataOperation.decoder,
    CoprocessorRegisterTransfer.decoder,
    SoftwareInterrupt.decoder,
  ];

  /// A collection of all the known formats in [ArmInstructionSet], sorted.
  static final allFormats = _decoders.map((d) => d._format).toList().toGroup();

  static Map<BitPattern<void>, ArmInstructionSetDecoder> _mapDecoders() {
    final m = {for (final decoder in _decoders) decoder._format: decoder};
    return HashMap.identity()..addAll(m);
  }

  /// Create a Map of [BitPattern] -> [ArmInstructionSetDecoder].
  static final mapDecoders = _mapDecoders();

  /// Format used to match and decode the instruction.
  final BitPattern<List<int>> _format;

  /// Condition code.
  final int condition;

  const ArmInstructionSet._(this.condition, this._format);

  /// Delegates to the appropriate method of [visitor], optionally [context].
  R accept<R, C>(ArmSetVisitor<R, C> visitor, [C context]);

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) {
      return true;
    } else if (o is ArmInstructionSet && identical(_format, o._format)) {
      return const MapEquality<Object, Object>().equals(toJson(), o.toJson());
    } else {
      return false;
    }
  }

  @override
  int get hashCode => const MapEquality<Object, Object>().hash(toJson());

  /// Must provide a JSON representation.
  Map<String, Object> toJson();

  @override
  String toString() => '$runtimeType $toJson()';
}

/// Implements decoding a `List<int>` or `int` into a [T] [ArmInstructionSet].
@sealed
class ArmInstructionSetDecoder<T extends ArmInstructionSet> {
  final BitPattern<List<int>> _format;
  final T Function(List<int>) _decoder;

  /// Create a new [ArmInstructionSetDecoder] for type [T].
  @literal
  const ArmInstructionSetDecoder._(this._format, this._decoder);

  /// Creates a [ArmInstructionSet] by decoding [bits].
  @nonVirtual
  T decodeBits(int bits) => decodeList(_format.capture(bits));

  /// Creates a [ArmInstructionSet] converting a previously [decoded] list.
  @nonVirtual
  T decodeList(List<int> decoded) => _decoder(decoded);
}

/// Implement to in order to visit known sub-types of [ArmInstructionSet].
abstract class ArmSetVisitor<R, C> {
  R visitDataProcessingOrPSRTransfer(
    DataProcessingOrPSRTransfer instruction, [
    C context,
  ]);

  R visitMultiplyAndMutiplyAccumulate(
    MultiplyAndMutiplyAccumulate instruction, [
    C context,
  ]);

  R visitMultiplyLongAndMutiplyAccumulateLong(
    MultiplyLongAndMutiplyAccumulateLong instruction, [
    C context,
  ]);

  R visitSingleDataSwap(
    SingleDataSwap instruction, [
    C context,
  ]);

  R visitBranchAndExchange(
    BranchAndExchange instruction, [
    C context,
  ]);

  R visitHalfWordAndSignedDataTransferRegisterOffset(
    HalfWordAndSignedDataTransferRegisterOffset instruction, [
    C context,
  ]);

  R visitHalfWordAndSignedDataTransferImmediateOffset(
    HalfWordAndSignedDataTransferImmediateOffset instruction, [
    C context,
  ]);

  R visitSingleDataTransfer(
    SingleDataTransfer instruction, [
    C context,
  ]);

  R visitUndefined(
    Undefined instruction, [
    C context,
  ]);

  R visitBlockDataTransfer(
    BlockDataTransfer instruction, [
    C context,
  ]);

  R visitBranch(
    Branch instruction, [
    C context,
  ]);

  R visitCoprocessorDataTransfer(
    CoprocessorDataTransfer instruction, [
    C context,
  ]);

  R visitCoprocessorDataOperation(
    CoprocessorDataOperation instruction, [
    C context,
  ]);

  R visitCoprocessorRegisterTransfer(
    CoprocessorRegisterTransfer instruction, [
    C context,
  ]);

  R visitSoftwareInterrupt(
    SoftwareInterrupt instruction, [
    C context,
  ]);
}
