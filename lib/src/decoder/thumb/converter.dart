import 'dart:convert';

import 'package:armv4t/src/common/binary.dart';
import 'package:armv4t/src/common/union.dart';
import 'package:armv4t/src/decoder/arm/condition.dart';
import 'package:armv4t/src/decoder/arm/instruction.dart';
import 'package:armv4t/src/decoder/common.dart';
import 'package:binary/binary.dart';
import 'package:meta/meta.dart';

import 'format.dart';

/// Implements `THUMB`-instruction parsing by converting into equivalent `ARM`.
///
/// This approach sacrifies making mapping/debugging easier by instead just
/// converting 16-bit `THUMB` instructions it to the equivalent 32-bit `ARM`.
@immutable
@sealed
abstract class ThumbToArmDecoder implements Converter<Uint16, ArmInstruction> {
  const factory ThumbToArmDecoder({
    ThumbFormatDecoder formatDecoder,
  }) = _ThumbToArmDecoder;
}

extension on Uint3 {
  /// Converts [Uint3] into a [RegisterAny].
  RegisterAny toAnyRegister() => RegisterAny(Uint4(value));

  /// Converts [Uint3] into a [RegisterNotPC].
  RegisterNotPC toNonPCRegister() => RegisterNotPC(Uint4(value));
}

class _ThumbToArmDecoder extends Converter<Uint16, ArmInstruction>
    implements
        /**/ ThumbToArmDecoder,
        /**/ ThumbFormatVisitor<ArmInstruction, void> {
  static const _always = Condition.al;

  final ThumbFormatDecoder _formatDecoder;

  const _ThumbToArmDecoder({
    ThumbFormatDecoder formatDecoder,
  }) : _formatDecoder = formatDecoder ?? const ThumbFormatDecoder();

  @override
  ArmInstruction convert(Uint16 input) {
    return _formatDecoder.convert(input).accept(this);
  }

  @override
  ArmInstruction visitAddOffsetToStackPointer(
    AddOffsetToStackPointerThumbFormat format, [
    void _,
  ]) {
    throw UnimplementedError();
  }

  @override
  ArmInstruction visitAddOrSubtract(
    AddOrSubtractThumbFormat format, [
    void _,
  ]) {
    final operand1 = format.sourceRegister.toAnyRegister();
    final destination = format.destinationRegister.toAnyRegister();

    if (format.immediateOperandBit) {
      final operand2 = ShiftedImmediate(
        Uint4.zero,
        Immediate(Uint8(format.baseRegisterOrImmediate.value)),
      );
      if (format.opCode$SUB) {
        // THUMB: SUB Rd, Rs, #Offset3
        // ARM:   SUBS Rd, Rs, #Offset3
        return SUB$Arm(
          condition: _always,
          setConditionCodes: true,
          operand1: operand1,
          destination: destination,
          operand2: Or3.right(operand2),
        );
      } else {
        // THUMB: ADD Rd, Rs, #Offset3
        // ARM:   ADDS Rd, Rs, #Offset3
        return ADD$Arm(
          condition: _always,
          setConditionCodes: true,
          operand1: operand1,
          destination: destination,
          operand2: Or3.right(operand2),
        );
      }
    } else {
      final operand2 = format.baseRegisterOrImmediate.toAnyRegister();
      if (format.opCode$SUB) {
        // THUMB:  SUB Rd, Rs, Rn
        // ARM:    SUBS Rd, Rs, Rn
        return SUB$Arm(
          condition: _always,
          setConditionCodes: true,
          operand1: operand1,
          destination: destination,
          operand2: Or3.left(
            ShiftedRegister(
              operand2,
              ShiftType.LSL,
              Immediate(Uint4.zero),
            ),
          ),
        );
      } else {
        // THUMB:  ADD Rd, Rs, Rn
        // ARM:    ADDS Rd, Rs, Rn
        return ADD$Arm(
          condition: _always,
          setConditionCodes: true,
          operand1: operand1,
          destination: destination,
          operand2: Or3.left(
            ShiftedRegister(
              operand2,
              ShiftType.LSL,
              Immediate(Uint4.zero),
            ),
          ),
        );
      }
    }
  }

  @override
  ArmInstruction visitAluOperation(
    AluOperationThumbFormat format, [
    void _,
  ]) {
    switch (format.opCode.value) {
      // THUMB: AND  Rd, Rs
      // ARM:   ANDS Rd, Rd, Rs
      case 0x0:
        return null;
      // THUMB: EOR  Rd, Rs
      // ARM:   EORS Rd, Rd, Rs
      case 0x1:
        return null;
      // THUMB: LSL  Rd, Rs
      // ARM:   MOVS Rd, Rd, LSL Rs
      case 0x2:
        return null;
      // THUMB: LSR  Rd, Rs
      // ARM:   MOVS Rd, Rd, LSR Rs
      case 0x3:
        return null;
      // THUMB: ASR  Rd, Rs
      // ARM:   MOVS Rd, Rd, ASR Rs
      case 0x4:
        return null;
      // THUMB: ADC  Rd, Rs
      // ARM:   ADCS Rd, Rd, Rs
      case 0x5:
        return null;
      // THUMB: SBC  Rd, Rs
      // ARM:   SBCS Rd, Rd, Rs
      case 0x6:
        return null;
      // THUMB: ROR  Rd, Rs
      // ARM:   MOVS Rd, Rd, ROR Rs
      case 0x7:
        return null;
      // THUMB: TST Rd, Rs
      // ARM:   TST Rd, Rs
      case 0x8:
        return null;
      // THUMB: NEG Rd, Rs
      // ARM:   RSBS Rd, Rd, #0
      case 0x9:
        return null;
      // THUMB: CMP Rd, Rs
      // ARM:   CMP Rd, Rs
      case 0xa:
        return null;
      // THUMB: CMN Rd, Rs
      // ARM:   CMN Rd, Rs
      case 0xb:
        return null;
      // THUMB: ORR Rd, Rs
      // ARM:   ORRS Rd, Rd, Rs
      case 0xc:
        return null;
      // THUMB: MUL Rd, Rs
      // ARM:   MULS Rd, Rs, Rd
      case 0xd:
        return null;
      // THUMB: BIC Rd, Rs
      // ARM:   BICS Rd, Rd, Rs
      case 0xe:
        return null;
      // THUMB: MVN Rd, Rs
      // ARM:   MVNS Rd, Rs
      case 0xf:
        return null;
      default:
        throw StateError('Cannot have a "null" opCode');
    }
  }

  @override
  ArmInstruction visitConditionalBranch(
    ConditionalBranchThumbFormat format, [
    void _,
  ]) {
    throw UnimplementedError();
  }

  @override
  ArmInstruction visitHiRegisterOperationsOrBranchExchange(
    HiRegisterOperationsOrBranchExchangeThumbFormat format, [
    void _,
  ]) {
    throw UnimplementedError();
  }

  @override
  ArmInstruction visitLoadAddress(
    LoadAddressThumbFormat format, [
    void _,
  ]) {
    throw UnimplementedError();
  }

  @override
  ArmInstruction visitLoadOrStoreHalfword(
    LoadOrStoreHalfwordThumbFormat format, [
    void _,
  ]) {
    throw UnimplementedError();
  }

  @override
  ArmInstruction visitLoadOrStoreWithImmediateOffset(
    LoadOrStoreWithImmediateOffsetThumbFormat format, [
    void _,
  ]) {
    throw UnimplementedError();
  }

  @override
  ArmInstruction visitLoadOrStoreWithRegisterOffset(
    LoadOrStoreWithRegisterOffsetThumbFormat format, [
    void _,
  ]) {
    throw UnimplementedError();
  }

  @override
  ArmInstruction visitLongBranchWithLink(
    LongBranchWithLinkThumbFormat format, [
    void _,
  ]) {
    throw UnimplementedError();
  }

  @override
  ArmInstruction visitMoveOrCompareOrAddOrSubtractImmediate(
    MoveOrCompareOrAddOrSubtractImmediateThumbFormat format, [
    void _,
  ]) {
    final destination = format.destination.toAnyRegister();
    final operand2 = ShiftedImmediate(Uint4.zero, Immediate(format.offset));
    switch (format.opCode.value) {
      // THUMB: MOV Rd, #Offset8
      // ARM:   MOVS Rd, #Offset8
      case 0x0:
        return MOV$Arm(
          condition: _always,
          setConditionCodes: true,
          operand1: Register.filledWith0s,
          destination: destination,
          operand2: Or3.right(operand2),
        );
      // THUMB: CMP Rd, #Offset8
      // ARM:   CMPS Rd, #Offset8
      case 0x1:
        return CMP$Arm(
          condition: _always,
          setConditionCodes: true,
          operand1: destination,
          destination: Register.filledWith0s,
          operand2: Or3.right(operand2),
        );
      // THUMB: ADD Rd, #Offset8
      // ARM:   ADDS Rd, #Offset8
      case 0x2:
        return ADD$Arm(
          condition: _always,
          setConditionCodes: true,
          operand1: destination,
          destination: destination,
          operand2: Or3.right(operand2),
        );
      // THUMB: SUB Rd, #Offset8
      // ARM:   SUBS Rd, #Offset8
      case 0x3:
        return SUB$Arm(
          condition: _always,
          setConditionCodes: true,
          operand1: destination,
          destination: destination,
          operand2: Or3.right(operand2),
        );
      default:
        throw StateError('Cannot have a "null" opCode');
    }
  }

  @override
  ArmInstruction visitMoveShiftedRegister(
    MoveShiftedRegisterThumbFormat format, [
    void _,
  ]) {
    final shiftRegister = format.sourceRegister.toAnyRegister();
    // TODO: Decide whether truncating as 4 bits is a legal operation.
    //
    // It is possible that the ARM instructions will need to be more size
    // flexible (e.g. not restrict to Uint4 in this particular case), or that a
    // 5-bit offset doesn't actually occur in practice.
    final shiftImmediate = Immediate(Uint4(format.immediate.value));
    final destination = format.destinationRegister.toAnyRegister();
    switch (format.opCode.value) {
      // THUMB: LSL  Rd, Rs, #Offset5
      // ARM:   MOVS Rd, Rs, LSL #Offset5
      case 0x0:
        return MOV$Arm(
          condition: _always,
          setConditionCodes: true,
          operand1: Register.filledWith0s,
          destination: destination,
          operand2: Or3.left(
            ShiftedRegister(
              shiftRegister,
              ShiftType.LSL,
              shiftImmediate,
            ),
          ),
        );
      // THUMB: LSR  Rd, Rs, #Offset5
      // ARM:   MOVS Rd, Rs, LSr #Offset5
      case 0x1:
        return MOV$Arm(
          condition: _always,
          setConditionCodes: true,
          operand1: Register.filledWith0s,
          destination: destination,
          operand2: Or3.left(
            ShiftedRegister(
              shiftRegister,
              ShiftType.LSR,
              shiftImmediate,
            ),
          ),
        );
      // THUMB: ASR  Rd, Rs, #Offset5
      // ARM:   MOVS Rd, Rs, ASR #Offset5
      case 0x2:
        return MOV$Arm(
          condition: _always,
          setConditionCodes: true,
          operand1: Register.filledWith0s,
          destination: destination,
          operand2: Or3.left(
            ShiftedRegister(
              shiftRegister,
              ShiftType.ASR,
              shiftImmediate,
            ),
          ),
        );
      default:
        throw FormatException('Unexpected opCode: ${format.opCode.value}');
    }
  }

  @override
  ArmInstruction visitMultipleLoadOrStore(
    MultipleLoadOrStoreThumbFormat format, [
    void _,
  ]) {
    throw UnimplementedError();
  }

  @override
  ArmInstruction visitPCRelativeLoad(
    PCRelativeLoadThumbFormat format, [
    void _,
  ]) {
    throw UnimplementedError();
  }

  @override
  ArmInstruction visitPushOrPopRegisters(
    PushOrPopRegistersThumbFormat format, [
    void _,
  ]) {
    throw UnimplementedError();
  }

  @override
  ArmInstruction visitSPRelativeLoadOrStore(
    SPRelativeLoadOrStoreThumbFormat format, [
    void _,
  ]) {
    throw UnimplementedError();
  }

  @override
  ArmInstruction visitSoftwareInterrupt(
    SoftwareInterruptThumbFormat format, [
    void _,
  ]) {
    throw UnimplementedError();
  }

  @override
  ArmInstruction visitUnconditionalBranch(
    UnconditionalBranchThumbFormat format, [
    void _,
  ]) {
    throw UnimplementedError();
  }
}
