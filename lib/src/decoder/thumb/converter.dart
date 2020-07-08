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
  RegisterAny toLoRegister() => RegisterAny(Uint4(value));

  /// Converts [Uint3] into a [RegisterAny], with `0` treated as `8`.
  RegisterAny toHiRegister() => RegisterAny(Uint4(value + 8));

  /// Converts [Uint3] into a [RegisterNotPC].
  RegisterNotPC toLoRegisterNonPC() => RegisterNotPC(Uint4(value));

  /// Converts [Uint3] into a [RegisterNotPC], with `0` treated as `8`.
  RegisterNotPC toHiRegisterNonPC() => RegisterNotPC(Uint4(value + 8));
}

extension on Uint5 {
  /// TODO: Decide whether truncating as 4 bits is a legal operation.
  ///
  /// It is possible that the ARM instructions will need to be more size
  /// flexible (e.g. not restrict to Uint4 in this particular case), or that a
  /// 5-bit offset doesn't actually occur in practice.
  Immediate<Uint4> get truncated => Immediate(Uint4(value));
}

class _ThumbToArmDecoder extends Converter<Uint16, ArmInstruction>
    implements
        /**/ ThumbToArmDecoder,
        /**/ ThumbFormatVisitor<ArmInstruction, void> {
  static const _always = Condition.al;

  @alwaysThrows
  // ignore: prefer_void_to_null
  static Null _nullOpCode() {
    throw StateError('Cannot have a "null" opCode');
  }

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
    // THUMB:  ADD Rd, <PC|SP>, #Imm
    // ARM:    ADD Rd, <R13|R15>, #Imm
    return ADDArmInstruction(
      condition: _always,
      setConditionCodes: false,
      operand1: RegisterAny.pc,
      destination: RegisterAny.pc,
      operand2: Or3.right(
        ShiftedImmediate(Uint4.zero, Immediate(Uint8(format.word.value))),
      ),
    );
  }

  @override
  ArmInstruction visitAddOrSubtract(
    AddOrSubtractThumbFormat format, [
    void _,
  ]) {
    final operand1 = format.sourceRegister.toLoRegister();
    final destination = format.destinationRegister.toLoRegister();

    if (format.immediateOperandBit) {
      final operand2 = ShiftedImmediate(
        Uint4.zero,
        Immediate(Uint8(format.baseRegisterOrImmediate.value)),
      );
      if (format.opCode$SUB) {
        // THUMB: SUB Rd, Rs, #Offset3
        // ARM:   SUBS Rd, Rs, #Offset3
        return SUBArmInstruction(
          condition: _always,
          setConditionCodes: true,
          operand1: operand1,
          destination: destination,
          operand2: Or3.right(operand2),
        );
      } else {
        // THUMB: ADD Rd, Rs, #Offset3
        // ARM:   ADDS Rd, Rs, #Offset3
        return ADDArmInstruction(
          condition: _always,
          setConditionCodes: true,
          operand1: operand1,
          destination: destination,
          operand2: Or3.right(operand2),
        );
      }
    } else {
      final operand2 = format.baseRegisterOrImmediate.toLoRegister();
      if (format.opCode$SUB) {
        // THUMB:  SUB Rd, Rs, Rn
        // ARM:    SUBS Rd, Rs, Rn
        return SUBArmInstruction(
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
        return ADDArmInstruction(
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
    ShiftedRegister<Immediate<Uint4>, RegisterAny> left() {
      return ShiftedRegister(
        format.source.toLoRegister(),
        ShiftType.LSL,
        Immediate(Uint4.zero),
      );
    }

    ShiftedRegister<RegisterNotPC, RegisterAny> middle(ShiftType shiftType) {
      return ShiftedRegister(
        format.destination.toLoRegister(),
        shiftType,
        format.source.toLoRegisterNonPC(),
      );
    }

    final destination = format.destination.toLoRegister();
    switch (format.opCode.value) {
      // THUMB: AND  Rd, Rs
      // ARM:   ANDS Rd, Rd, Rs
      case 0x0:
        return ANDArmInstruction(
          condition: _always,
          setConditionCodes: true,
          destination: destination,
          operand1: destination,
          operand2: Or3.left(left()),
        );
      // THUMB: EOR  Rd, Rs
      // ARM:   EORS Rd, Rd, Rs
      case 0x1:
        return EORArmInstruction(
          condition: _always,
          setConditionCodes: true,
          destination: destination,
          operand1: destination,
          operand2: Or3.left(left()),
        );
      // THUMB: LSL  Rd, Rs
      // ARM:   MOVS Rd, Rd, LSL Rs
      case 0x2:
        return MOVArmInstruction(
          condition: _always,
          setConditionCodes: true,
          destination: Register.filledWith0s,
          operand1: destination,
          operand2: Or3.middle(middle(ShiftType.LSL)),
        );
      // THUMB: LSR  Rd, Rs
      // ARM:   MOVS Rd, Rd, LSR Rs
      case 0x3:
        return MOVArmInstruction(
          condition: _always,
          setConditionCodes: true,
          destination: Register.filledWith0s,
          operand1: destination,
          operand2: Or3.middle(middle(ShiftType.LSR)),
        );
      // THUMB: ASR  Rd, Rs
      // ARM:   MOVS Rd, Rd, ASR Rs
      case 0x4:
        return MOVArmInstruction(
          condition: _always,
          setConditionCodes: true,
          destination: Register.filledWith0s,
          operand1: destination,
          operand2: Or3.middle(middle(ShiftType.ASR)),
        );
      // THUMB: ADC  Rd, Rs
      // ARM:   ADCS Rd, Rd, Rs
      case 0x5:
        return ADCArmInstruction(
          condition: _always,
          setConditionCodes: true,
          destination: destination,
          operand1: destination,
          operand2: Or3.left(left()),
        );
      // THUMB: SBC  Rd, Rs
      // ARM:   SBCS Rd, Rd, Rs
      case 0x6:
        return SBCArmInstruction(
          condition: _always,
          setConditionCodes: true,
          destination: destination,
          operand1: destination,
          operand2: Or3.left(left()),
        );
      // THUMB: ROR  Rd, Rs
      // ARM:   MOVS Rd, Rd, ROR Rs
      case 0x7:
        return MOVArmInstruction(
          condition: _always,
          setConditionCodes: true,
          destination: Register.filledWith0s,
          operand1: destination,
          operand2: Or3.middle(middle(ShiftType.ROR)),
        );
      // THUMB: TST Rd, Rs
      // ARM:   TST Rd, Rs
      case 0x8:
        return TSTArmInstruction(
          condition: _always,
          setConditionCodes: true,
          destination: Register.filledWith0s,
          operand1: destination,
          operand2: Or3.left(left()),
        );
      // THUMB: NEG Rd, Rs
      // ARM:   RSBS Rd, Rd, #0
      case 0x9:
        return RSBArmInstruction(
          condition: _always,
          setConditionCodes: true,
          destination: destination,
          operand1: destination,
          operand2: Or3.right(
            ShiftedImmediate(
              Uint4.zero,
              Immediate(Uint8.zero),
            ),
          ),
        );
      // THUMB: CMP Rd, Rs
      // ARM:   CMP Rd, Rs
      case 0xa:
        return CMPArmInstruction(
          condition: _always,
          setConditionCodes: true,
          destination: Register.filledWith0s,
          operand1: destination,
          operand2: Or3.left(left()),
        );
      // THUMB: CMN Rd, Rs
      // ARM:   CMN Rd, Rs
      case 0xb:
        return CMNArmInstruction(
          condition: _always,
          setConditionCodes: true,
          destination: Register.filledWith0s,
          operand1: destination,
          operand2: Or3.left(left()),
        );
      // THUMB: ORR Rd, Rs
      // ARM:   ORRS Rd, Rd, Rs
      case 0xc:
        return ORRArmInstruction(
          condition: _always,
          setConditionCodes: true,
          destination: destination,
          operand1: destination,
          operand2: Or3.left(left()),
        );
      // THUMB: MUL Rd, Rs
      // ARM:   MULS Rd, Rs, Rd
      case 0xd:
        return MULArmInstruction(
          condition: _always,
          setConditionCodes: true,
          destination: format.destination.toLoRegisterNonPC(),
          operand1: format.source.toLoRegisterNonPC(),
          operand2: format.destination.toLoRegisterNonPC(),
        );
      // THUMB: BIC Rd, Rs
      // ARM:   BICS Rd, Rd, Rs
      case 0xe:
        return BICArmInstruction(
          condition: _always,
          setConditionCodes: true,
          destination: destination,
          operand1: destination,
          operand2: Or3.left(left()),
        );
      // THUMB: MVN Rd, Rs
      // ARM:   MVNS Rd, Rs
      case 0xf:
        return MVNArmInstruction(
          condition: _always,
          setConditionCodes: true,
          destination: Register.filledWith0s,
          operand1: destination,
          operand2: Or3.middle(middle(ShiftType.ASR)),
        );
      default:
        return _nullOpCode();
    }
  }

  @override
  ArmInstruction visitConditionalBranch(
    ConditionalBranchThumbFormat format, [
    void _,
  ]) {
    return BArmInstruction(
      condition: Condition.parse(format.condition.value),
      offset: Uint24(format.offset.value),
    );
  }

  @override
  ArmInstruction visitHiRegisterOperationsOrBranchExchange(
    HiRegisterOperationsOrBranchExchangeThumbFormat format, [
    void _,
  ]) {
    @alwaysThrows
    // ignore: prefer_void_to_null
    Null _unsupportedHH() {
      throw FormatException('Unsupported HH: ${format.hCodes.value}');
    }

    RegisterAny destinationLo() => format.destination.toLoRegister();
    RegisterAny destinationHi() => format.destination.toHiRegister();

    switch (format.opCode.value) {
      case 0x0:
        switch (format.hCodes.value) {
          // THUMB:  ADD Rd, Hs
          // ARM:    ADD Rd, Rd, Hs
          case 0x1: // 01
            return ADDArmInstruction(
              condition: _always,
              setConditionCodes: false,
              operand1: destinationLo(),
              destination: destinationLo(),
              operand2: Or3.left(
                ShiftedRegister(
                  format.source.toHiRegister(),
                  ShiftType.LSL,
                  Immediate(Uint4.zero),
                ),
              ),
            );
          // THUMB:  ADD Hd, Rs
          // ARM:    ADD Hd, Hd, Rs
          case 0x2: // 10
            return ADDArmInstruction(
              condition: _always,
              setConditionCodes: false,
              operand1: destinationHi(),
              destination: destinationHi(),
              operand2: Or3.left(
                ShiftedRegister(
                  format.source.toLoRegister(),
                  ShiftType.LSL,
                  Immediate(Uint4.zero),
                ),
              ),
            );
          // THUMB:  ADD Hd, Hs
          // ARM:    ADD Hd, Hd, Hs
          case 0x3: // 11
            return ADDArmInstruction(
              condition: _always,
              setConditionCodes: false,
              operand1: destinationHi(),
              destination: destinationHi(),
              operand2: Or3.left(
                ShiftedRegister(
                  format.source.toHiRegister(),
                  ShiftType.LSL,
                  Immediate(Uint4.zero),
                ),
              ),
            );
        }
        return _unsupportedHH();
      case 0x1:
        switch (format.hCodes.value) {
          // THUMB:  CMP Rd, Hs
          // ARM:    CMP Rd, Hs
          case 0x1: // 01
            return CMPArmInstruction(
              condition: _always,
              setConditionCodes: false,
              operand1: destinationLo(),
              destination: Register.filledWith0s,
              operand2: Or3.left(ShiftedRegister(
                format.source.toHiRegister(),
                ShiftType.LSL,
                Immediate(Uint4.zero),
              )),
            );
          // THUMB:  CMP Hd, Rs
          // ARM:    CMP Hd, Rs
          case 0x2: // 10
            return CMPArmInstruction(
              condition: _always,
              setConditionCodes: false,
              operand1: destinationHi(),
              destination: Register.filledWith0s,
              operand2: Or3.left(ShiftedRegister(
                format.source.toLoRegister(),
                ShiftType.LSL,
                Immediate(Uint4.zero),
              )),
            );
          // THUMB:  CMP Hd, Hs
          // ARM:    CMP Hd, Hs
          case 0x3: // 11
            return CMPArmInstruction(
              condition: _always,
              setConditionCodes: false,
              operand1: destinationHi(),
              destination: Register.filledWith0s,
              operand2: Or3.left(ShiftedRegister(
                format.source.toHiRegister(),
                ShiftType.LSL,
                Immediate(Uint4.zero),
              )),
            );
        }
        return _unsupportedHH();
      case 0x2:
        switch (format.hCodes.value) {
          // THUMB: MOV Rd, Hs
          // ARM:   MOV Rd, Hs
          case 0x1: // 00
            return MOVArmInstruction(
              condition: _always,
              setConditionCodes: false,
              operand1: Register.filledWith0s,
              destination: format.destination.toLoRegister(),
              operand2: Or3.left(
                ShiftedRegister(
                  format.source.toHiRegister(),
                  ShiftType.LSL,
                  Immediate(Uint4.zero),
                ),
              ),
            );
          // THUMB: MOV Hd, Rs
          // ARM:   MOV Hd, Rs
          case 0x2: // 01
            return MOVArmInstruction(
              condition: _always,
              setConditionCodes: false,
              operand1: Register.filledWith0s,
              destination: format.destination.toHiRegister(),
              operand2: Or3.left(
                ShiftedRegister(
                  format.source.toLoRegister(),
                  ShiftType.LSL,
                  Immediate(Uint4.zero),
                ),
              ),
            );
          // THUMB: MOV Hd, Hs
          // ARM:   MOV Hd, Hs
          case 0x3:
            return MOVArmInstruction(
              condition: _always,
              setConditionCodes: false,
              operand1: Register.filledWith0s,
              destination: format.destination.toHiRegister(),
              operand2: Or3.left(
                ShiftedRegister(
                  format.source.toHiRegister(),
                  ShiftType.LSL,
                  Immediate(Uint4.zero),
                ),
              ),
            );
        }
        return _unsupportedHH();
      case 0x3:
        switch (format.hCodes.value) {
          // THUMB: BX Rs
          // ARM:   BX Rs
          case 0x0: // 00
            return BXArmInstruction(
              condition: _always,
              operand: format.source.toLoRegisterNonPC(),
            );
          // THUMB: BX Hs
          // ARM:   BX Hs
          case 0x1: // 01
            return BXArmInstruction(
              condition: _always,
              operand: format.source.toHiRegisterNonPC(),
            );
        }
        return _unsupportedHH();
      default:
        return _nullOpCode();
    }
  }

  @override
  ArmInstruction visitLoadAddress(
    LoadAddressThumbFormat format, [
    void _,
  ]) {
    // THUMB:  ADD Rd, <PC|SP>, #Imm
    // ARM:    ADD Rd, <R13|R15>, #Imm
    final register = format.stackPointerBit ? RegisterAny.sp : RegisterAny.pc;
    return ADDArmInstruction(
      condition: _always,
      setConditionCodes: false,
      operand1: register,
      destination: format.destination.toLoRegister(),
      operand2: Or3.right(ShiftedImmediate(Uint4.zero, Immediate(format.word))),
    );
  }

  @override
  ArmInstruction visitLoadOrStoreHalfword(
    LoadOrStoreHalfwordThumbFormat format, [
    void _,
  ]) {
    if (format.loadBit) {
      // ARM:   LDRH Rd, [Rb, #Imm]
      // THUMB: LDRH Rd, [Rb, #Imm]
      return LDRHArmInstruction(
        condition: _always,
        addOffsetBeforeTransfer: false,
        addOffsetToBase: true,
        writeAddressIntoBase: false,
        base: format.destination.toLoRegister(),
        source: format.destination.toLoRegister(),
        offset: Or2.right(Immediate(format.word)),
      );
    } else {
      // ARM:   STRH Rd, [Rb, #Imm]
      // THUMB: STRH Rd, [Rb, #Imm]
      return STRHArmInstruction(
        condition: _always,
        addOffsetBeforeTransfer: false,
        addOffsetToBase: true,
        writeAddressIntoBase: false,
        base: format.destination.toLoRegister(),
        destination: format.destination.toLoRegister(),
        offset: Or2.right(Immediate(format.word)),
      );
    }
  }

  @override
  ArmInstruction visitLoadOrStoreSignExtendedByteOrHalfword(
    LoadOrStoreSignExtendedByteOrHalfword format, [
    void _,
  ]) {
    if (format.sBit) {
      if (format.hBit) {
        // ARM:   STRH Rd, [Rb, Ro]
        // THUMB: STRH Rd, [Rb, Ro]
        // 0 0
        return STRHArmInstruction(
          condition: _always,
          addOffsetBeforeTransfer: false,
          addOffsetToBase: true,
          writeAddressIntoBase: false,
          base: format.baseRegister.toLoRegister(),
          destination: format.sourceOrdestinationRegister.toLoRegister(),
          offset: Or2.left(format.offsetRegister.toLoRegisterNonPC()),
        );
      } else {
        // ARM:   LDRH Rd, [Rb, Ro]
        // THUMB: LDRH Rd, [Rb, Ro]
        // 0 1
        return LDRHArmInstruction(
          condition: _always,
          addOffsetBeforeTransfer: false,
          addOffsetToBase: true,
          writeAddressIntoBase: false,
          base: format.baseRegister.toLoRegister(),
          source: format.sourceOrdestinationRegister.toLoRegister(),
          offset: Or2.left(format.offsetRegister.toLoRegisterNonPC()),
        );
      }
    } else {
      if (format.hBit) {
        // ARM:   LDRSB Rd, [Rb, Ro]
        // THUMB: LDRSB Rd, [Rb, Ro]
        // 1 0
        return LDRSBArmInstruction(
          condition: _always,
          addOffsetBeforeTransfer: false,
          addOffsetToBase: true,
          writeAddressIntoBase: false,
          base: format.baseRegister.toLoRegister(),
          source: format.sourceOrdestinationRegister.toLoRegister(),
          offset: Or2.left(format.offsetRegister.toLoRegisterNonPC()),
        );
      } else {
        // ARM:   LDRSH Rd, [Rb, Ro]
        // THUMB: LDRSH Rd, [Rb, Ro]
        // 1 1
        return LDRSHArmInstruction(
          condition: _always,
          addOffsetBeforeTransfer: false,
          addOffsetToBase: true,
          writeAddressIntoBase: false,
          base: format.baseRegister.toLoRegister(),
          source: format.sourceOrdestinationRegister.toLoRegister(),
          offset: Or2.left(format.offsetRegister.toLoRegisterNonPC()),
        );
      }
    }
  }

  @override
  ArmInstruction visitLoadOrStoreWithImmediateOffset(
    LoadOrStoreWithImmediateOffsetThumbFormat format, [
    void _,
  ]) {
    if (format.loadBit) {
      // THUMB: STR{B} Rd, [Rb, #Imm]
      // ARM:   STR{B} Rd, [Rb, #Imm]
      return STRArmInstruction(
        condition: _always,
        addOffsetBeforeTransfer: false,
        addOffsetToBase: true,
        writeAddressIntoBaseOrForceNonPrivilegedAccess: false,
        transferByte: format.byteBit,
        base: format.base.toLoRegister(),
        destination: format.base.toLoRegister(),
        offset: Or2.left(Immediate(Uint12(format.offset.value))),
      );
    } else {
      // THUMB: LDR{B} Rd, [Rb, #Imm]
      // ARM:   LDR{B} Rd, [Rb, #Imm]
      return LDRArmInstruction(
        condition: _always,
        addOffsetBeforeTransfer: false,
        addOffsetToBase: true,
        writeAddressIntoBaseOrForceNonPrivilegedAccess: false,
        transferByte: format.byteBit,
        base: format.base.toLoRegister(),
        source: format.base.toLoRegister(),
        offset: Or2.left(Immediate(Uint12(format.offset.value))),
      );
    }
  }

  @override
  ArmInstruction visitLoadOrStoreWithRegisterOffset(
    LoadOrStoreWithRegisterOffsetThumbFormat format, [
    void _,
  ]) {
    if (format.loadBit) {
      // THUMB: LDR{B} Rd, [Rb, Ro]
      // ARM:   LDR{B} Rd, [Rb, Ro]
      return LDRArmInstruction(
        condition: _always,
        addOffsetBeforeTransfer: false,
        addOffsetToBase: true,
        writeAddressIntoBaseOrForceNonPrivilegedAccess: false,
        transferByte: format.byteBit,
        base: format.base.toLoRegister(),
        source: format.base.toLoRegister(),
        offset: Or2.right(ShiftedRegister(
          format.offset.toLoRegisterNonPC(),
          ShiftType.LSL,
          Immediate(Uint4.zero),
        )),
      );
    } else {
      // THUMB: STR{B} Rd, [Rb, Ro]
      // ARM:   STR{B} Rd, [Rb, Ro]
      return STRArmInstruction(
        condition: _always,
        addOffsetBeforeTransfer: false,
        addOffsetToBase: true,
        writeAddressIntoBaseOrForceNonPrivilegedAccess: false,
        transferByte: format.byteBit,
        base: format.base.toLoRegister(),
        destination: format.base.toLoRegister(),
        offset: Or2.right(ShiftedRegister(
          format.offset.toLoRegisterNonPC(),
          ShiftType.LSL,
          Immediate(Uint4.zero),
        )),
      );
    }
  }

  @override
  ArmInstruction visitLongBranchWithLink(
    LongBranchWithLinkThumbFormat format, [
    void _,
  ]) {
    // TODO: Correctly implement BL.
    return BLArmInstruction(
      condition: _always,
      offset: Uint24(format.offset.value),
    );
  }

  @override
  ArmInstruction visitMoveOrCompareOrAddOrSubtractImmediate(
    MoveOrCompareOrAddOrSubtractImmediateThumbFormat format, [
    void _,
  ]) {
    final destination = format.destination.toLoRegister();
    final operand2 = ShiftedImmediate(Uint4.zero, Immediate(format.offset));
    switch (format.opCode.value) {
      // THUMB: MOV Rd, #Offset8
      // ARM:   MOVS Rd, #Offset8
      case 0x0:
        return MOVArmInstruction(
          condition: _always,
          setConditionCodes: true,
          operand1: Register.filledWith0s,
          destination: destination,
          operand2: Or3.right(operand2),
        );
      // THUMB: CMP Rd, #Offset8
      // ARM:   CMPS Rd, #Offset8
      case 0x1:
        return CMPArmInstruction(
          condition: _always,
          setConditionCodes: true,
          operand1: destination,
          destination: Register.filledWith0s,
          operand2: Or3.right(operand2),
        );
      // THUMB: ADD Rd, #Offset8
      // ARM:   ADDS Rd, #Offset8
      case 0x2:
        return ADDArmInstruction(
          condition: _always,
          setConditionCodes: true,
          operand1: destination,
          destination: destination,
          operand2: Or3.right(operand2),
        );
      // THUMB: SUB Rd, #Offset8
      // ARM:   SUBS Rd, #Offset8
      case 0x3:
        return SUBArmInstruction(
          condition: _always,
          setConditionCodes: true,
          operand1: destination,
          destination: destination,
          operand2: Or3.right(operand2),
        );
      default:
        return _nullOpCode();
    }
  }

  @override
  ArmInstruction visitMoveShiftedRegister(
    MoveShiftedRegisterThumbFormat format, [
    void _,
  ]) {
    final shiftRegister = format.sourceRegister.toLoRegister();
    final shiftImmediate = format.immediate.truncated;
    final destination = format.destinationRegister.toLoRegister();
    switch (format.opCode.value) {
      // THUMB: LSL  Rd, Rs, #Offset5
      // ARM:   MOVS Rd, Rs, LSL #Offset5
      case 0x0:
        return MOVArmInstruction(
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
        return MOVArmInstruction(
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
        return MOVArmInstruction(
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
    if (format.loadBit) {
      // THUMB:  LDMIA Rb!, { Rlist }
      // ARM:    LDMIA Rb!, { Rlist }
      return LDMArmInstruction(
        condition: _always,
        addOffsetBeforeTransfer: false,
        addOffsetToBase: true,
        writeAddressIntoBase: true,
        loadPsrOrForceUserMode: false,
        base: RegisterAny.sp,
        registerList: RegisterList.parse(format.registerList.value),
      );
    } else {
      // THUMB:  STMIA Rb!, { Rlist }
      // ARM:    STMIA Rb!, { Rlist }
      return STMArmInstruction(
        condition: _always,
        addOffsetBeforeTransfer: false,
        addOffsetToBase: true,
        writeAddressIntoBase: true,
        loadPsrOrForceUserMode: false,
        base: RegisterAny.sp,
        registerList: RegisterList.parse(format.registerList.value),
      );
    }
  }

  @override
  ArmInstruction visitPCRelativeLoad(
    PCRelativeLoadThumbFormat format, [
    void _,
  ]) {
    return LDRArmInstruction(
      condition: _always,
      addOffsetBeforeTransfer: false,
      addOffsetToBase: true,
      writeAddressIntoBaseOrForceNonPrivilegedAccess: false,
      transferByte: false,
      base: format.destination.toLoRegister(),
      source: RegisterAny.pc,
      offset: Or2.left(Immediate(Uint12(format.word.value))),
    );
  }

  @override
  ArmInstruction visitPushOrPopRegisters(
    PushOrPopRegistersThumbFormat format, [
    void _,
  ]) {
    var registerList = format.registerList;
    if (format.pcOrLrBit) {
      // Store LR/Load PC
      if (format.loadBit) {
        // Load PC
        registerList = registerList.setBit(15);
      } else {
        // Store LR
        registerList = registerList.setBit(14);
      }
    }
    if (format.loadBit) {
      // THUMB: POP { Rlist }
      // ARM:   LDMIA R13!, { Rlist }
      //   -or-
      // THUMB: POP { Rlist, PC }
      // ARM:   LDMIA R13!, { Rlist, R15 }
      return LDMArmInstruction(
        condition: _always,
        addOffsetBeforeTransfer: false,
        addOffsetToBase: true,
        writeAddressIntoBase: true,
        loadPsrOrForceUserMode: false,
        base: RegisterAny.sp,
        registerList: RegisterList.parse(registerList.value),
      );
    } else {
      // THUMB: PUSH { Rlist }
      // ARM:   STMDB R13!, { Rlist }
      //   -or-
      // THUMB: PUSH { Rlist, LR }
      // ARM:   STMDB R13!, { Rlist, R14 }
      return STMArmInstruction(
        condition: _always,
        addOffsetBeforeTransfer: true,
        addOffsetToBase: false,
        writeAddressIntoBase: true,
        loadPsrOrForceUserMode: false,
        base: RegisterAny.sp,
        registerList: RegisterList.parse(registerList.value),
      );
    }
  }

  @override
  ArmInstruction visitSPRelativeLoadOrStore(
    SPRelativeLoadOrStoreThumbFormat format, [
    void _,
  ]) {
    if (format.loadBit) {
      // THUMB: LDR Rd, [SP, #Imm]
      // ARM:   LDR Rd, [R13 #Imm]
      return LDRArmInstruction(
        condition: _always,
        addOffsetBeforeTransfer: false,
        addOffsetToBase: true,
        writeAddressIntoBaseOrForceNonPrivilegedAccess: false,
        transferByte: false,
        base: RegisterAny.sp,
        source: format.destination.toLoRegister(),
        offset: Or2.left(Immediate(Uint12(format.word.value))),
      );
    } else {
      // THUMB: STR Rd, [SP, #Imm]
      // ARM:   STR Rd, [R13 #Imm]
      return STRArmInstruction(
        condition: _always,
        addOffsetBeforeTransfer: false,
        addOffsetToBase: true,
        writeAddressIntoBaseOrForceNonPrivilegedAccess: false,
        transferByte: false,
        base: RegisterAny.sp,
        destination: format.destination.toLoRegister(),
        offset: Or2.left(Immediate(Uint12(format.word.value))),
      );
    }
  }

  @override
  ArmInstruction visitSoftwareInterrupt(
    SoftwareInterruptThumbFormat format, [
    void _,
  ]) {
    return SWIArmInstruction(
      condition: _always,
      comment: Comment(Uint24(format.value.value)),
    );
  }

  @override
  ArmInstruction visitUnconditionalBranch(
    UnconditionalBranchThumbFormat format, [
    void _,
  ]) {
    return BArmInstruction(
      condition: _always,
      offset: Uint24(format.offset.value),
    );
  }
}
