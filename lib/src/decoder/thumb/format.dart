import 'dart:convert';

import 'package:armv4t/decode.dart';
import 'package:armv4t/src/common/assert.dart';
import 'package:armv4t/src/common/binary.dart';
import 'package:binary/binary.dart';
import 'package:collection/collection.dart';
import 'package:meta/meta.dart';

part 'format/add_offset_to_stack_pointer.dart';
part 'format/add_or_subtract.dart';
part 'format/alu_operations.dart';
part 'format/conditional_branch.dart';
part 'format/hi_register_operations_or_branch_exchange.dart';
part 'format/load_address.dart';
part 'format/load_or_store_halfword.dart';
part 'format/load_or_store_with_immediate_offset.dart';
part 'format/load_or_store_with_register_offset.dart';
part 'format/long_branch_with_link.dart';
part 'format/move_or_compare_or_add_or_subtract_immediate.dart';
part 'format/move_shifted_register.dart';
part 'format/multiple_load_or_store.dart';
part 'format/pc_relative_load.dart';
part 'format/push_or_pop_registers.dart';
part 'format/software_interrupt.dart';
part 'format/sp_relative_load_or_store.dart';
part 'format/unconditional_branch.dart';

/// A decoded _THUMB_ instruction _format_.
///
/// This is an intermediate decoding in between the raw bits and a completely
/// decoded instruction that has resolved ambiguities in the decoding and the
/// internal data structures.
@immutable
@sealed
abstract class ThumbFormat {
  const ThumbFormat._();

  R accept<R, C>(ThumbInstructionVisitor<R, C> visitor, [C context]);

  @visibleForOverriding
  Map<String, int> _values();

  @override
  int get hashCode => const MapEquality<Object, Object>().hash(_values());

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) {
      return true;
    }
    if (o is ThumbFormat && runtimeType == o.runtimeType) {
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

/// Converts a known 16-bit integr into a partially decodd [ThumbFormat].
class ThumbFormatDecoder extends Converter<Uint16, ThumbFormat> {
  static final _addOffsetToStackPointer = BitPatternBuilder.parse(
    '1011_0000_SWWW_WWWW',
  ).build('ADD_OFFSET_TO_STACK_POINTER');

  static final _addOrSubtract = BitPatternBuilder.parse(
    '0001_1IPN_NNSS_SDDD',
  ).build('ADD_OR_SUBTRACT');

  static final _aluOperations = BitPatternBuilder.parse(
    '0100_00PP_PSSS_DDDD',
  ).build('ALU_OPERATIONS');

  static final _conditionalBranch = BitPatternBuilder.parse(
    '1101_CCCC_OOOO_OOOO',
  ).build('CONDITIONAL_BRANCH');

  static final _hiRgisterOperationsOrBranchExchange = BitPatternBuilder.parse(
    '0100_01PP_HHSS_SDDD',
  ).build('HI_REGISTER_OPERATIONS_OR_BRANCH_EXCHANGE');

  static final _loadAddress = BitPatternBuilder.parse(
    '1010_SDDD_WWWW_WWWW',
  ).build('LOAD_ADDRESS');

  static final _loadOrStoreHalfword = BitPatternBuilder.parse(
    '1000_LOOO_OOBB_BDDD',
  ).build('LOAD_OR_STORE_HALFWORD');

  static final _loadOrStoreWithImmediateOffset = BitPatternBuilder.parse(
    '011B_LOOO_OOBB_BDDD',
  ).build('LOAD_OR_STORE_IMMEDIATE_OFFSET');

  static final _loadOrStoreWithRegisterOffset = BitPatternBuilder.parse(
    '0101_LB0O_OOBB_BDDD',
  ).build('LOAD_OR_STORE_WITH_REGISTER_OFFSET');

  static final _longBranchWithLink = BitPatternBuilder.parse(
    '1111_HOOO_OOOO_OOOO',
  ).build('LONG_BRANCH_WITH_LINK');

  static final _moveOrCompareOrAddOrSubtractImmediate = BitPatternBuilder.parse(
    '001P_PDDD_OOOO_OOOO',
  ).build('MOVE_OR_COMPARE_OR_ADD_OR_SUBTRACT_IMMEDIATE');

  static final _moveShiftedRegister = BitPatternBuilder.parse(
    '000P_POOO_OOSS_SDDD',
  ).build('MOVE_SHIFTED_REGISTER');

  static final _multipleLoadOrStore = BitPatternBuilder.parse(
    '1100_LBBB_RRRR_RRRR',
  ).build('MULTIPLE_LOAD_OR_STORE');

  static final _pcRelativeLoad = BitPatternBuilder.parse(
    '0100_1DDD_WWWW_WWWW',
  ).build('PC_RELATIVE_LOAD');

  static final _pushOrPopRegisters = BitPatternBuilder.parse(
    '1011_L10R_KKKK_KKKK',
  ).build('PUSH_OR_POP_REGISTERS');

  static final _softwareInterrupt = BitPatternBuilder.parse(
    '1101_1111_VVVV_VVVV',
  ).build('SOFTWARE_INTERRUPT');

  static final _spRelativeLoadOrStore = BitPatternBuilder.parse(
    '1001_LDDD_WWWW_WWWW',
  ).build('SP_RELATIVE_LOAD_OR_STORE');

  static final _unconditionalBranch = BitPatternBuilder.parse(
    '1110_0OOO_OOOO_OOOO',
  ).build('UNCONDITIONAL_BRANCH');

  static final _allKnownPatterns = [
    _addOffsetToStackPointer,
    _addOrSubtract,
    _aluOperations,
    _conditionalBranch,
    _hiRgisterOperationsOrBranchExchange,
    _loadAddress,
    _loadOrStoreHalfword,
    _loadOrStoreWithImmediateOffset,
    _loadOrStoreWithRegisterOffset,
    _longBranchWithLink,
    _moveOrCompareOrAddOrSubtractImmediate,
    _moveShiftedRegister,
    _multipleLoadOrStore,
    _pcRelativeLoad,
    _pushOrPopRegisters,
    _softwareInterrupt,
    _spRelativeLoadOrStore,
    _unconditionalBranch,
  ].toGroup();

  const ThumbFormatDecoder();

  /// Converts a 16-bit [input] into a decoded [ThumbFormat].
  @override
  ThumbFormat convert(Uint16 input) {
    final pattern = _allKnownPatterns.match(input.value);
    final capture = pattern?.capture(input.value) ?? const [];
    if (identical(pattern, _addOffsetToStackPointer)) {
      // 1011_0000_SWWW_WWWW
      return AddOffsetToStackPointerThumbFormat(
        sBit: capture[0] == 1,
        word: Uint7(capture[1]),
      );
    } else if (identical(pattern, _addOrSubtract)) {
      // 0001_1IPN_NNSS_SDDD
      return AddOrSubtractThumbFormat(
        immediateBit: capture[0] == 1,
        opCode: capture[1] == 1,
        baseOrOffset3: Uint3(capture[2]),
        source: Uint3(capture[3]),
        destination: Uint3(capture[4]),
      );
    } else if (identical(pattern, _aluOperations)) {
      // 0100_00PP_PSSS_DDDD
      return AluOperationThumbFormat(
        opCode: Uint3(capture[0]),
        source: Uint3(capture[1]),
        destination: Uint3(capture[2]),
      );
    } else if (identical(pattern, _conditionalBranch)) {
      // 1101_CCCC_OOOO_OOOO
      return ConditionalBranchThumbFormat(
        condition: Uint4(capture[0]),
        offset: Uint8(capture[1]),
      );
    } else if (identical(pattern, _hiRgisterOperationsOrBranchExchange)) {
      // 0100_01PP_HHSS_SDDD
      return HiRegisterOperationsOrBranchExchangeThumbFormat(
        opCode: Uint2(capture[0]),
        hCodes: Uint2(capture[1]),
        source: Uint3(capture[2]),
        destination: Uint3(capture[3]),
      );
    } else if (identical(pattern, _loadAddress)) {
      // 1010_SDDD_WWWW_WWWW
      return LoadAddressThumbFormat(
        stackPointerBit: capture[0] == 1,
        destination: Uint3(capture[1]),
        word: Uint8(capture[2]),
      );
    } else if (identical(pattern, _loadOrStoreHalfword)) {
      // 1000_LOOO_OOBB_BDDD
      return LoadOrStoreHalfwordThumbFormat(
        loadBit: capture[0] == 1,
        destination: Uint3(capture[1]),
        word: Uint8(capture[2]),
      );
    } else if (identical(pattern, _loadOrStoreWithImmediateOffset)) {
      // 011B_LOOO_OOBB_BDDD
      return LoadOrStoreWithImmediateOffsetThumbFormat(
        byteBit: capture[0] == 1,
        loadBit: capture[1] == 1,
        offset: Uint5(capture[2]),
        base: Uint3(capture[3]),
        destination: Uint3(capture[4]),
      );
    } else if (identical(pattern, _loadOrStoreWithRegisterOffset)) {
      // 0101_LB0O_OOBB_BDDD
      return LoadOrStoreWithRegisterOffsetThumbFormat(
        loadBit: capture[0] == 1,
        byteBit: capture[1] == 1,
        offset: Uint3(capture[2]),
        base: Uint3(capture[3]),
        destination: Uint3(capture[4]),
      );
    } else if (identical(pattern, _longBranchWithLink)) {
      // 1111_HOOO_OOOO_OOOO
      return LongBranchWithLinkThumbFormat(
        hBit: capture[0] == 1,
        offset: Uint11(capture[1]),
      );
    } else if (identical(pattern, _moveOrCompareOrAddOrSubtractImmediate)) {
      // 001P_PDDD_OOOO_OOOO
      return MoveOrCompareOrAddOrSubtractImmediateThumbFormat(
        opCode: Uint2(capture[0]),
        destination: Uint3(capture[1]),
        offset: Uint8(capture[2]),
      );
    } else if (identical(pattern, _moveShiftedRegister)) {
      // 000P_POOO_OOSS_SDDD
      return MoveShiftedRegisterThumbFormat(
        opCode: Uint2(capture[0]),
        offset: Uint5(capture[1]),
        source: Uint3(capture[2]),
        destination: Uint3(capture[3]),
      );
    } else if (identical(pattern, _multipleLoadOrStore)) {
      // 1100_LBBB_RRRR_RRRR
      return MultipleLoadOrStoreThumbFormat(
        loadBit: capture[0] == 1,
        base: Uint3(capture[1]),
        registerList: Uint8(capture[2]),
      );
    } else if (identical(pattern, _pcRelativeLoad)) {
      // 0100_1DDD_WWWW_WWWW
      return PCRelativeLoadThumbFormat(
        destination: Uint3(capture[0]),
        word: Uint8(capture[1]),
      );
    } else if (identical(pattern, _pushOrPopRegisters)) {
      // 1011_L10R_KKKK_KKKK
      return PushOrPopRegistersThumbFormat(
        loadBit: capture[0] == 1,
        rBit: capture[1] == 1,
        registerList: Uint8(capture[2]),
      );
    } else if (identical(pattern, _softwareInterrupt)) {
      // 1101_1111_VVVV_VVVV
      return SoftwareInterruptThumbFormat(
        value: Uint8(capture[0]),
      );
    } else if (identical(pattern, _spRelativeLoadOrStore)) {
      // 1001_LDDD_WWWW_WWWW
      return SPRelativeLoadOrStoreThumbFormat(
        loadBit: capture[0] == 1,
        destination: Uint3(capture[1]),
        word: Uint8(capture[2]),
      );
    } else if (identical(pattern, _unconditionalBranch)) {
      // 1110_0OOO_OOOO_OOOO
      return UnconditionalBranchThumbFormat(
        offset: Uint11(capture[0]),
      );
    } else {
      throw FormatException('Unknown format: ${input.value.toRadixString(16)}');
    }
  }
}

abstract class ThumbInstructionVisitor<R, C> {
  R visitAddOffsetToStackPointer(
    AddOffsetToStackPointerThumbFormat format, [
    C context,
  ]);

  R vsiitAddOrSubtract(
    AddOrSubtractThumbFormat format, [
    C context,
  ]);

  R visitAluOperation(
    AluOperationThumbFormat format, [
    C context,
  ]);

  R visitConditionalBranch(
    ConditionalBranchThumbFormat format, [
    C context,
  ]);

  R visitHiRegisterOperationsOrBranchExchange(
    HiRegisterOperationsOrBranchExchangeThumbFormat format, [
    C context,
  ]);

  R visitLoadAddress(
    LoadAddressThumbFormat format, [
    C context,
  ]);

  R visitLoadOrStoreHalfword(
    LoadOrStoreHalfwordThumbFormat format, [
    C context,
  ]);

  R visitLoadOrStoreWithImmediateOffset(
    LoadOrStoreWithImmediateOffsetThumbFormat format, [
    C context,
  ]);

  R visitLoadOrStoreWithRegisterOffset(
    LoadOrStoreWithRegisterOffsetThumbFormat format, [
    C context,
  ]);

  R visitLongBranchWithLink(
    LongBranchWithLinkThumbFormat format, [
    C context,
  ]);

  R visitMoveOrCompareOrAddOrSubtractImmediate(
    MoveOrCompareOrAddOrSubtractImmediateThumbFormat format, [
    C context,
  ]);

  R visitMoveShiftedRegister(
    MoveShiftedRegisterThumbFormat format, [
    C context,
  ]);

  R visitMultipleLoadOrStore(
    MultipleLoadOrStoreThumbFormat format, [
    C context,
  ]);

  R visitPCRelativeLoad(
    PCRelativeLoadThumbFormat format, [
    C context,
  ]);

  R visitPushOrPopRegisters(
    PushOrPopRegistersThumbFormat format, [
    C context,
  ]);

  R visitSoftwareInterrupt(
    SoftwareInterruptThumbFormat format, [
    C context,
  ]);

  R visitSPRelativeLoadOrStore(
    SPRelativeLoadOrStoreThumbFormat format, [
    C context,
  ]);

  R visitUnconditionalBranch(
    UnconditionalBranchThumbFormat format, [
    C context,
  ]);
}
