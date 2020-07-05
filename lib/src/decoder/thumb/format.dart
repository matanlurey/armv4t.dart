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
    '',
  ).build();

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
    '1011_L10R_LLLL_LLLL',
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
      throw UnimplementedError();
    } else if (identical(pattern, _addOrSubtract)) {
      throw UnimplementedError();
    } else if (identical(pattern, _aluOperations)) {
      throw UnimplementedError();
    } else if (identical(pattern, _conditionalBranch)) {
      throw UnimplementedError();
    } else if (identical(pattern, _hiRgisterOperationsOrBranchExchange)) {
      throw UnimplementedError();
    } else if (identical(pattern, _loadAddress)) {
      throw UnimplementedError();
    } else if (identical(pattern, _loadOrStoreHalfword)) {
      throw UnimplementedError();
    } else if (identical(pattern, _loadOrStoreWithImmediateOffset)) {
      throw UnimplementedError();
    } else if (identical(pattern, _loadOrStoreWithRegisterOffset)) {
      throw UnimplementedError();
    } else if (identical(pattern, _longBranchWithLink)) {
      throw UnimplementedError();
    } else if (identical(pattern, _moveOrCompareOrAddOrSubtractImmediate)) {
      throw UnimplementedError();
    } else if (identical(pattern, _moveShiftedRegister)) {
      throw UnimplementedError();
    } else if (identical(pattern, _multipleLoadOrStore)) {
      throw UnimplementedError();
    } else if (identical(pattern, _pcRelativeLoad)) {
      throw UnimplementedError();
    } else if (identical(pattern, _pushOrPopRegisters)) {
      throw UnimplementedError();
    } else if (identical(pattern, _softwareInterrupt)) {
      throw UnimplementedError();
    } else if (identical(pattern, _spRelativeLoadOrStore)) {
      throw UnimplementedError();
    } else if (identical(pattern, _unconditionalBranch)) {
      throw UnimplementedError();
    } else {
      throw FormatException('Unknown format: ${input.value.toRadixString(16)}');
    }
  }
}

abstract class ThumbInstructionVisitor<R, C> {}
