import 'dart:collection';

import 'package:binary/binary.dart';
import 'package:collection/collection.dart';
import 'package:meta/meta.dart';

part 'format/add_and_subtract.dart';
part 'format/add_offset_to_stack_pointer.dart';
part 'format/alu_operation.dart';
part 'format/conditional_branch.dart';
part 'format/high_register_operations_and_branch_exchange.dart';
part 'format/load_address.dart';
part 'format/load_and_store_half_word.dart';
part 'format/load_and_store_sign_extended_byte_and_half_word.dart';
part 'format/load_and_store_with_immediate_offset.dart';
part 'format/load_and_store_with_relative_offset.dart';
part 'format/long_branch_with_link.dart';
part 'format/move_compare_add_and_subtract_immediate.dart';
part 'format/move_shifted_register.dart';
part 'format/multiple_load_and_store.dart';
part 'format/pc_relative_load.dart';
part 'format/push_and_pop_registers.dart';
part 'format/software_interrupt.dart';
part 'format/sp_relative_load_and_store.dart';
part 'format/unconditional_branch.dart';

/// An **internal** package representing all known `THUMB` instruction sets.
///
/// For testing, individual [BitPattern] implementations are accessible as
/// static fields (e.g. `[$01$moveShiftedRegister]`), and a sorted
/// [BitPatternGrpup] is accessible as [allFormats].
abstract class ThumbInstructionSet {
  /// Move shifted register.
  static final $01$moveShiftedRegister = BitPatternBuilder.parse(
    '000P_POOO_OOSS_SDDD',
  ).build('01:MOVE_SHIFTED_REGISTER');

  /// Add and subtract.
  static final $02$addAndSubtract = BitPatternBuilder.parse(
    '0001_11PN_NNSS_SDDD',
  ).build('02:ADD_AND_SUBTRACT');

  /// Move, compare, add, and subtract immediate.
  static final $03$moveCompareAddAndSubtractImmediate = BitPatternBuilder.parse(
    '001P_PDDD_OOOO_OOOO',
  ).build('03:MOVE_COMPARE_ADD_AND_SUBTRACT_IMMEDIATE');

  /// ALU operation.
  static final $04$aluOperation = BitPatternBuilder.parse(
    '0100_00PP_PPSS_SDDD',
  ).build('04:ALU_OPERATION');

  /// High register operations and branch exchange.
  static final $05$highRegisterOperationsAndBranch = BitPatternBuilder.parse(
    '0100_01PP_HJSS_SDDD',
  ).build('05:HIGH_REGISTER_OPERATIONS_AND_BRANCH_EXCHANGE');

  /// PC-relkative load.
  static final $06$pcRelativeLoad = BitPatternBuilder.parse(
    '0100_1DDD_WWWW_WWWW',
  ).build('06:PC_RELATIVE_LOAD');

  /// Load and store with relative offset.
  static final $07$loadAndStoreWithRelativeOffset = BitPatternBuilder.parse(
    '0101_LB0O_OONN_NDDD',
  ).build('07:LOAD_AND_STORE_WITH_RELATIVE_OFFSET');

  /// Load and store sign-extended byte and half-word.
  static final $08$loadAndStoreSignExtended = BitPatternBuilder.parse(
    '0101_HS1O_OOBB_BDDD',
  ).build('08:LOAD_AND_STORE_SIGN_EXTENDED_BYTE_AND_HALFWORD');

  /// Load and store with immediate offset.
  static final $09$loadAndStoreWithImmediateOffset = BitPatternBuilder.parse(
    '011B_LOOO_OONN_NDDD',
  ).build('09:LOAD_AND_STORE_WITH_IMMEDIATE_OFFSET');

  /// Load and store halfword.
  static final $10$loadAndStoreHalfword = BitPatternBuilder.parse(
    '1000_LOOO_OOBB_BDDD',
  ).build('10:LOAD_AND_STORE_HALFWORD');

  /// SP-relative load and store.
  static final $11$spRelativeLoadAndStore = BitPatternBuilder.parse(
    '1001_LDDD_WWWW_WWWW',
  ).build('11:SP_RELATIVE_LOAD_AND_STORE');

  /// Load address.
  static final $12$loadAddress = BitPatternBuilder.parse(
    '1010_SDDD_WWWW_WWWW',
  ).build('12:LOAD_ADDRESS');

  /// Add offset to stack pointer.
  static final $13$addOffsetToStackPointer = BitPatternBuilder.parse(
    '1011_0000_SWWW_WWWW',
  ).build('13:ADD_OFFSET_TO_STACK_POINTER');

  /// Push and pop registers.
  static final $14$pushAndPopRegisters = BitPatternBuilder.parse(
    '1011_L10R_TTTT_TTTT',
  ).build('14:PUSH_AND_POP_REGISTERS');

  /// Multiple load and store.
  static final $15$multipleLoadAndStore = BitPatternBuilder.parse(
    '1100_LBBB_TTTT_TTTT',
  ).build('15:MULTIPLE_LOAD_AND_STORE');

  /// Conditional branch.
  static final $16$conditionalBranch = BitPatternBuilder.parse(
    '1101_CCCC_SSSS_SSSS',
  ).build('16:CONDITIONAL_BRANCH');

  /// Software interrupt.
  static final $17$softwareInterrupt = BitPatternBuilder.parse(
    '1101_1111_VVVV_VVVV',
  ).build('17:SOFTWARE_INTERRUPT');

  /// Unconditional branch.
  static final $18$unconditionalBranch = BitPatternBuilder.parse(
    '1110_0OOO_OOOO_OOOO',
  ).build('18:UNCONDITIONAL_BRANCH');

  /// Long branch with link.
  static final $19$longBranchWithLink = BitPatternBuilder.parse(
    '1111_HOOO_OOOO_OOOO',
  ).build('19:LONG_BRANCH_WITH_LINK');

  /// A known list of all the different [ThumbInstructionSetDecoder] instances.
  static final _decoders = [
    MoveShiftedRegister.decoder,
    AddAndSubtract.decoder,
    MoveCompareAddAndSubtractImmediate.decoder,
    ALUOperation.decoder,
    HighRegisterOperationsAndBranchExchange.decoder,
    PCRelativeLoad.decoder,
    LoadAndStoreWithRelativeOffset.decoder,
    LoadAndStoreSignExtendedByteAndHalfWord.decoder,
    LoadAndStoreWithImmediateOffset.decoder,
    LoadAndStoreHalfWord.decoder,
    SPRelativeLoadAndStore.decoder,
    LoadAddress.decoder,
    AddOffsetToStackPointer.decoder,
    PushAndPopRegisters.decoder,
    MultipleLoadAndStore.decoder,
    ConditionalBranch.decoder,
    SoftwareInterrupt.decoder,
    UnconditionalBranch.decoder,
    LongBranchWithLink.decoder,
  ];

  /// A collection of all the known formats in [ThumbInstructionSet], sorted.
  static final allFormats = _decoders.map((d) => d._format).toList().toGroup();

  static Map<BitPattern<void>, ThumbInstructionSetDecoder> _mapDecoders() {
    final m = {for (final decoder in _decoders) decoder._format: decoder};
    return HashMap.identity()..addAll(m);
  }

  /// Create a Map of [BitPattern] -> [ThumbInstructionSetDecoder].
  static final mapDecoders = _mapDecoders();

  /// Format used to match and decode this instruction.
  final BitPattern<List<int>> _format;

  const ThumbInstructionSet._(this._format) : assert(_format != null);

  /// Delegates to the appropriate method of [visitor], optionally [context].
  R accept<R, C>(ThumbInstructionSetVisitor<R, C> visitor, [C context]);

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) {
      return true;
    } else if (o is ThumbInstructionSet && identical(_format, o._format)) {
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

/// Implements decoding a `List<int>` or `int` into a [T] [ThumbInstructionSet].
@sealed
class ThumbInstructionSetDecoder<T extends ThumbInstructionSet> {
  final BitPattern<List<int>> _format;
  final T Function(List<int>) _decoder;

  /// Create a new [ThumbInstructionSetDecoder] for type [T].
  @literal
  const ThumbInstructionSetDecoder._(this._format, this._decoder);

  /// Creates a [ThumbInstructionSet] by decoding [bits].
  @nonVirtual
  T decodeBits(int bits) => decodeList(_format.capture(bits));

  /// Creates a [ThumbInstructionSet] converting a previously [decoded] list.
  @nonVirtual
  T decodeList(List<int> decoded) => _decoder(decoded);
}

/// Implement to in order to visit known sub-types of [ThumbInstructionSet].
abstract class ThumbInstructionSetVisitor<R, C> {
  R visitMoveShiftedRegister(
    MoveShiftedRegister set, [
    C context,
  ]);

  R visitAddAndSubtract(
    AddAndSubtract set, [
    C context,
  ]);

  R visitMoveCompareAddAndSubtractImmediate(
    MoveCompareAddAndSubtractImmediate set, [
    C context,
  ]);

  R visitALUOperation(
    ALUOperation set, [
    C context,
  ]);

  R visitHighRegisterOperationsAndBranchExchange(
    HighRegisterOperationsAndBranchExchange set, [
    C context,
  ]);

  R visitPCRelativeLoad(
    PCRelativeLoad set, [
    C context,
  ]);

  R visitLoadAndStoreWithRelativeOffset(
    LoadAndStoreWithRelativeOffset set, [
    C context,
  ]);

  R visitLoadAndStoreSignExtendedByteAndHalfWord(
    LoadAndStoreSignExtendedByteAndHalfWord set, [
    C context,
  ]);

  R visitLoadAndStoreWithImmediateOffset(
    LoadAndStoreWithImmediateOffset set, [
    C context,
  ]);

  R visitLoadAndStoreHalfWord(
    LoadAndStoreHalfWord set, [
    C context,
  ]);

  R visitSPRelativeLoadAndStore(
    SPRelativeLoadAndStore set, [
    C context,
  ]);

  R visitLoadAddress(
    LoadAddress set, [
    C context,
  ]);

  R visitAddOffsetToStackPointer(
    AddOffsetToStackPointer set, [
    C context,
  ]);

  R visitPushAndPopRegisters(
    PushAndPopRegisters set, [
    C context,
  ]);

  R visitMultipleLoadAndStore(
    MultipleLoadAndStore set, [
    C context,
  ]);

  R visitConditionalBranch(
    ConditionalBranch set, [
    C context,
  ]);

  R visitSoftwareInterrupt(
    SoftwareInterrupt set, [
    C context,
  ]);

  R visitUnconditionalBranch(
    UnconditionalBranch set, [
    C context,
  ]);

  R visitLongBranchWithLink(
    LongBranchWithLink set, [
    C context,
  ]);
}
