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
part 'format/load_or_store_sign_extended_byte_or_halfword.dart';
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

  R accept<R, C>(ThumbFormatVisitor<R, C> visitor, [C context]);

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
    '0100_00PP_PPSS_SDDD',
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

  static final _loadOrStoreSignExtendedByteOrHalfword = BitPatternBuilder.parse(
    '0101_HS1O_OOBB_BDDD',
  ).build('LOAD_OR_STORE_SIGN_EXTENDED_BYTE_OR_HALFWORD');

  static final _loadOrStoreWithImmediateOffset = BitPatternBuilder.parse(
    '011B_LOOO_OONN_NDDD',
  ).build('LOAD_OR_STORE_IMMEDIATE_OFFSET');

  static final _loadOrStoreWithRegisterOffset = BitPatternBuilder.parse(
    '0101_LB0O_OONN_NDDD',
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

  static final _allKnownPatterns = BitPatternGroup([
    _addOffsetToStackPointer,
    _addOrSubtract,
    _aluOperations,
    _conditionalBranch,
    _hiRgisterOperationsOrBranchExchange,
    _loadAddress,
    _loadOrStoreHalfword,
    _loadOrStoreSignExtendedByteOrHalfword,
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
  ]);

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
        immediateOperandBit: capture[0] == 1,
        opCode$SUB: capture[1] == 1,
        baseRegisterOrImmediate: Uint3(capture[2]),
        sourceRegister: Uint3(capture[3]),
        destinationRegister: Uint3(capture[4]),
      );
    } else if (identical(pattern, _aluOperations)) {
      // 0100_00PP_PPSS_SDDD
      return AluOperationThumbFormat(
        opCode: Uint4(capture[0]),
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
        offset: Uint5(capture[1]),
        baseRegister: Uint3(capture[2]),
        sourceOrDestinationRegister: Uint3(capture[3]),
      );
    } else if (identical(pattern, _loadOrStoreSignExtendedByteOrHalfword)) {
      // 0101_HS1O_OOBB_BDDD
      return LoadOrStoreSignExtendedByteOrHalfword(
        hBit: capture[0] == 1,
        sBit: capture[1] == 1,
        offsetRegister: Uint3(capture[2]),
        baseRegister: Uint3(capture[3]),
        sourceOrdestinationRegister: Uint3(capture[4]),
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
        immediate: Uint5(capture[1]),
        sourceRegister: Uint3(capture[2]),
        destinationRegister: Uint3(capture[3]),
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
        pcOrLrBit: capture[1] == 1,
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

abstract class ThumbFormatVisitor<R, C> {
  R visitAddOffsetToStackPointer(
    AddOffsetToStackPointerThumbFormat format, [
    C context,
  ]);

  R visitAddOrSubtract(
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

  R visitLoadOrStoreSignExtendedByteOrHalfword(
    LoadOrStoreSignExtendedByteOrHalfword format, [
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

/// Converts a [ThumbFormat] back to a [Uint16].
abstract class ThumbFormatEncoder implements Converter<ThumbFormat, Uint16> {
  const factory ThumbFormatEncoder() = _ThumbFormatEncoder;
}

class _ThumbFormatEncoder
    /***/ extends Converter<ThumbFormat, Uint16>
    /***/ implements
        ThumbFormatEncoder,
        ThumbFormatVisitor<Uint16, void> {
  const _ThumbFormatEncoder();

  @override
  Uint16 convert(ThumbFormat format) => format.accept(this);

  @override
  Uint16 visitAddOffsetToStackPointer(
    AddOffsetToStackPointerThumbFormat format, [
    void _,
  ]) {
    return (Uint16Builder()
          ..write('1001' '0000')
          ..writeBool(format.sBit)
          ..writeInt(format.word))
        .build();
  }

  @override
  Uint16 visitAddOrSubtract(
    AddOrSubtractThumbFormat format, [
    void _,
  ]) {
    return (Uint16Builder()
          ..write('0001' '1')
          ..writeBool(format.immediateOperandBit)
          ..writeBool(format.opCode$SUB)
          ..writeInt(format.baseRegisterOrImmediate)
          ..writeInt(format.sourceRegister)
          ..writeInt(format.destinationRegister))
        .build();
  }

  @override
  Uint16 visitAluOperation(
    AluOperationThumbFormat format, [
    void _,
  ]) {
    return (Uint16Builder()
          ..write('0100' '00')
          ..writeInt(format.opCode)
          ..writeInt(format.source)
          ..writeInt(format.destination))
        .build();
  }

  @override
  Uint16 visitConditionalBranch(
    ConditionalBranchThumbFormat format, [
    void _,
  ]) {
    return (Uint16Builder()
          ..write('1101')
          ..writeInt(format.condition)
          ..writeInt(format.offset))
        .build();
  }

  @override
  Uint16 visitHiRegisterOperationsOrBranchExchange(
    HiRegisterOperationsOrBranchExchangeThumbFormat format, [
    void _,
  ]) {
    return (Uint16Builder()
          ..write('0100' '01')
          ..writeInt(format.opCode)
          ..writeInt(format.hCodes)
          ..writeInt(format.source)
          ..writeInt(format.destination))
        .build();
  }

  @override
  Uint16 visitLoadAddress(
    LoadAddressThumbFormat format, [
    void _,
  ]) {
    return (Uint16Builder()
          ..write('1010')
          ..writeBool(format.stackPointerBit)
          ..writeInt(format.destination)
          ..writeInt(format.word))
        .build();
  }

  @override
  Uint16 visitLoadOrStoreHalfword(
    LoadOrStoreHalfwordThumbFormat format, [
    void _,
  ]) {
    return (Uint16Builder()
          ..write('1000')
          ..writeBool(format.loadBit)
          ..writeInt(format.offset)
          ..writeInt(format.baseRegister)
          ..writeInt(format.sourceOrDestinationRegister))
        .build();
  }

  @override
  Uint16 visitLoadOrStoreSignExtendedByteOrHalfword(
    LoadOrStoreSignExtendedByteOrHalfword format, [
    void _,
  ]) {
    return (Uint16Builder()
          ..write('0101')
          ..writeBool(format.hBit)
          ..writeBool(format.sBit)
          ..write('1')
          ..writeInt(format.offsetRegister)
          ..writeInt(format.baseRegister)
          ..writeInt(format.sourceOrdestinationRegister))
        .build();
  }

  @override
  Uint16 visitLoadOrStoreWithImmediateOffset(
    LoadOrStoreWithImmediateOffsetThumbFormat format, [
    void _,
  ]) {
    return (Uint16Builder()
          ..write('011')
          ..writeBool(format.byteBit)
          ..writeBool(format.loadBit)
          ..writeInt(format.offset)
          ..writeInt(format.base)
          ..writeInt(format.destination))
        .build();
  }

  @override
  Uint16 visitLoadOrStoreWithRegisterOffset(
    LoadOrStoreWithRegisterOffsetThumbFormat format, [
    void _,
  ]) {
    return (Uint16Builder()
          ..write('0101')
          ..writeBool(format.loadBit)
          ..writeBool(format.byteBit)
          ..writeInt(format.offset)
          ..writeInt(format.base)
          ..writeInt(format.destination))
        .build();
  }

  @override
  Uint16 visitLongBranchWithLink(
    LongBranchWithLinkThumbFormat format, [
    void _,
  ]) {
    return (Uint16Builder()
          ..write('1111')
          ..writeBool(format.hBit)
          ..writeInt(format.offset))
        .build();
  }

  @override
  Uint16 visitMoveOrCompareOrAddOrSubtractImmediate(
    MoveOrCompareOrAddOrSubtractImmediateThumbFormat format, [
    void _,
  ]) {
    return (Uint16Builder()
          ..write('001')
          ..writeInt(format.opCode)
          ..writeInt(format.destination)
          ..writeInt(format.offset))
        .build();
  }

  @override
  Uint16 visitMoveShiftedRegister(
    MoveShiftedRegisterThumbFormat format, [
    void _,
  ]) {
    return (Uint16Builder()
          ..write('000')
          ..writeInt(format.opCode)
          ..writeInt(format.immediate)
          ..writeInt(format.sourceRegister)
          ..writeInt(format.destinationRegister))
        .build();
  }

  @override
  Uint16 visitMultipleLoadOrStore(
    MultipleLoadOrStoreThumbFormat format, [
    void _,
  ]) {
    return (Uint16Builder()
          ..write('1100')
          ..writeBool(format.loadBit)
          ..writeInt(format.base)
          ..writeInt(format.registerList))
        .build();
  }

  @override
  Uint16 visitPCRelativeLoad(
    PCRelativeLoadThumbFormat format, [
    void _,
  ]) {
    return (Uint16Builder()
          ..write('0100' '1')
          ..writeInt(format.destination)
          ..writeInt(format.word))
        .build();
  }

  @override
  Uint16 visitPushOrPopRegisters(
    PushOrPopRegistersThumbFormat format, [
    void _,
  ]) {
    return (Uint16Builder()
          ..write('1011')
          ..writeBool(format.loadBit)
          ..writeBool(format.pcOrLrBit)
          ..writeInt(format.registerList))
        .build();
  }

  @override
  Uint16 visitSoftwareInterrupt(
    SoftwareInterruptThumbFormat format, [
    void _,
  ]) {
    return (Uint16Builder()
          ..write('1101' '1111')
          ..writeInt(format.value))
        .build();
  }

  @override
  Uint16 visitSPRelativeLoadOrStore(
    SPRelativeLoadOrStoreThumbFormat format, [
    void _,
  ]) {
    return (Uint16Builder()
          ..write('1001')
          ..writeInt(format.destination)
          ..writeInt(format.word))
        .build();
  }

  @override
  Uint16 visitUnconditionalBranch(
    UnconditionalBranchThumbFormat format, [
    void _,
  ]) {
    return (Uint16Builder()
          ..write('1110' '0')
          ..writeInt(format.offset))
        .build();
  }
}
