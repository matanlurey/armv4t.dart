part of '../instruction.dart';

class ArmInstructionDecoder implements ArmFormatVisitor<ArmInstruction, void> {
  const ArmInstructionDecoder();

  @override
  ArmInstruction visitDataProcessingOrPsrTransfer(
    DataProcessingOrPsrTransferArmFormat format, [
    void _,
  ]) {
    final condition = Condition.parse(format.condition.value);
    final opCode = _ALUOpCode.values[format.opCode.value];
    if (!format.setConditionCodes) {
      switch (opCode) {
        //                               isMRS
        //                              V
        case _ALUOpCode.TST: // 0x8 | 1000 <-- useSPSR
          return _decodePsrTransfer(
            format,
            condition,
            isMSR: true,
          );
        case _ALUOpCode.TEQ: // 0x9 | 1001
          return _decodePsrTransfer(
            format,
            condition,
            useSPSR: true,
            isMSR: true,
          );
        case _ALUOpCode.CMP: // 0xa | 1010
          return _decodePsrTransfer(
            format,
            condition,
          );
        case _ALUOpCode.CMN: // 0xb | 1011
          return _decodePsrTransfer(
            format,
            condition,
            useSPSR: true,
          );
        default:
          break;
      }
    }
    final setConditionCodes = format.setConditionCodes;
    final operand1 = RegisterAny(format.operand1Register);
    final destination = RegisterAny(format.destinationRegister);

    Or3<
        ShiftedRegister<Immediate<Uint4>, RegisterAny>,
        /**/
        ShiftedRegister<RegisterNotPC, RegisterAny>,
        /**/
        ShiftedImmediate<Uint8>> operand2;

    if (format.immediateOperand) {
      // I = 1
      final rorShift = Uint4(format.operand2.bitRange(11, 8).value);
      final immediate = Uint8(format.operand2.bitRange(7, 0).value);
      operand2 = Or3.right(ShiftedImmediate(rorShift, Immediate(immediate)));
    } else {
      // I = 0
      final shiftByRegister = format.operand2.isSet(4);
      final shiftOperand = RegisterAny(
        Uint4(format.operand2.bitRange(3, 0).value),
      );
      final shiftType = ShiftType.values[format.operand2.bitRange(6, 5).value];
      // Shift By Immediate
      //           Operand2 Register
      //           vvvv
      // AAAA_ATT0_RRRR
      // ^^^^ ^^^
      // ^^^^ ^ ^ Shift Type
      // Shift Amount (5-bit unsigned int).
      //
      // - OR -
      //
      //           Operand2 Register
      //           vvvv
      // SSSS_0TT1_RRRR
      // ^^^^  ^^
      // ^^^^  Shift Type
      // Shift Register
      if (shiftByRegister) {
        // R = 1
        final shiftRegister = Uint4(format.operand2.bitRange(11, 8).value);
        operand2 = Or3.middle(
          ShiftedRegister(
            shiftOperand,
            shiftType,
            RegisterNotPC(shiftRegister),
          ),
        );
      } else {
        // R = 0
        final shiftAmount = Uint4(format.operand2.bitRange(11, 7).value);
        operand2 = Or3.left(
          ShiftedRegister(
            shiftOperand,
            shiftType == ShiftType.ROR && shiftAmount.value == 0
                ? ShiftType.RRX
                : shiftType,
            Immediate(shiftAmount),
          ),
        );
      }
    }

    switch (opCode) {
      case _ALUOpCode.AND:
        return AND(
          condition: condition,
          setConditionCodes: setConditionCodes,
          operand1: operand1,
          destination: destination,
          operand2: operand2,
        );
      case _ALUOpCode.EOR:
        return EOR(
          condition: condition,
          setConditionCodes: setConditionCodes,
          operand1: operand1,
          destination: destination,
          operand2: operand2,
        );
      case _ALUOpCode.SUB:
        return SUB(
          condition: condition,
          setConditionCodes: setConditionCodes,
          operand1: operand1,
          destination: destination,
          operand2: operand2,
        );
      case _ALUOpCode.RSB:
        return RSB(
          condition: condition,
          setConditionCodes: setConditionCodes,
          operand1: operand1,
          destination: destination,
          operand2: operand2,
        );
      case _ALUOpCode.ADD:
        return ADD(
          condition: condition,
          setConditionCodes: setConditionCodes,
          operand1: operand1,
          destination: destination,
          operand2: operand2,
        );
      case _ALUOpCode.ADC:
        return ADC(
          condition: condition,
          setConditionCodes: setConditionCodes,
          operand1: operand1,
          destination: destination,
          operand2: operand2,
        );
      case _ALUOpCode.SBC:
        return SBC(
          condition: condition,
          setConditionCodes: setConditionCodes,
          operand1: operand1,
          destination: destination,
          operand2: operand2,
        );
      case _ALUOpCode.RSC:
        return RSC(
          condition: condition,
          setConditionCodes: setConditionCodes,
          operand1: operand1,
          destination: destination,
          operand2: operand2,
        );
      case _ALUOpCode.TST:
        return TST(
          condition: condition,
          setConditionCodes: setConditionCodes,
          operand1: operand1,
          destination: destination,
          operand2: operand2,
        );
      case _ALUOpCode.TEQ:
        return TEQ(
          condition: condition,
          setConditionCodes: setConditionCodes,
          operand1: operand1,
          destination: destination,
          operand2: operand2,
        );
      case _ALUOpCode.CMP:
        return CMP(
          condition: condition,
          setConditionCodes: setConditionCodes,
          operand1: operand1,
          destination: destination,
          operand2: operand2,
        );
      case _ALUOpCode.CMN:
        return CMN(
          condition: condition,
          setConditionCodes: setConditionCodes,
          operand1: operand1,
          destination: destination,
          operand2: operand2,
        );
      case _ALUOpCode.ORR:
        return ORR(
          condition: condition,
          setConditionCodes: setConditionCodes,
          operand1: operand1,
          destination: destination,
          operand2: operand2,
        );
      case _ALUOpCode.MOV:
        return MOV(
          condition: condition,
          setConditionCodes: setConditionCodes,
          operand1: operand1,
          destination: destination,
          operand2: operand2,
        );
      case _ALUOpCode.BIC:
        return BIC(
          condition: condition,
          setConditionCodes: setConditionCodes,
          operand1: operand1,
          destination: destination,
          operand2: operand2,
        );
      case _ALUOpCode.MVN:
        return MVN(
          condition: condition,
          setConditionCodes: setConditionCodes,
          operand1: operand1,
          destination: destination,
          operand2: operand2,
        );
      default:
        throw StateError('Should not be a possible result');
    }
  }

  PsrTransferArmInstruction _decodePsrTransfer(
    DataProcessingOrPsrTransferArmFormat format,
    Condition condition, {
    bool isMSR = false,
    bool useSPSR = false,
  }) {
    if (isMSR) {
      final flagMask = format.operand1Register;
      Or2<RegisterAny, ShiftedImmediate<Uint8>> sourceOrImmediate;

      if (format.immediateOperand) {
        // I = 1
        sourceOrImmediate = Or2.right(
          ShiftedImmediate(
            Uint4(format.operand2.bitRange(11, 8).value),
            Immediate(Uint8(format.operand2.bitRange(7, 0).value)),
          ),
        );
      } else {
        // I = 0
        sourceOrImmediate = Or2.left(
          RegisterAny(Uint4(format.operand2.bitRange(3, 0).value)),
        );
      }

      MSRWriteField writeTo;

      if (flagMask.isSet(3)) {
        writeTo = MSRWriteField.flag;
      } else if (flagMask.isSet(2)) {
        writeTo = MSRWriteField.status;
      } else if (flagMask.isSet(1)) {
        writeTo = MSRWriteField.extension;
      } else if (flagMask.isSet(0)) {
        writeTo = MSRWriteField.control;
      }

      return MSR(
        condition: condition,
        useSPSR: useSPSR,
        writeToField: writeTo,
        sourceOrImmediate: sourceOrImmediate,
      );
    } else {
      return MRS(
        condition: condition,
        useSPSR: useSPSR,
        destination: RegisterNotPC(format.destinationRegister),
      );
    }
  }

  @override
  MultiplyAndMultiplyLongArmInstruction visitMultiply(
    MultiplyArmFormat format, [
    void _,
  ]) {
    final condition = Condition.parse(format.condition.value);
    final setConditionCodes = format.setConditionCodes;
    final operand1 = RegisterNotPC(format.operandRegister1);
    final operand2 = RegisterNotPC(format.operandRegister2);
    final destination = RegisterNotPC(format.destinationRegister);

    if (format.accumulate) {
      // A = 1
      return MLA(
        condition: condition,
        setConditionCodes: setConditionCodes,
        operand1: operand1,
        operand2: operand2,
        destination: destination,
      );
    } else {
      // A = 0
      return MUL(
        condition: condition,
        setConditionCodes: setConditionCodes,
        operand1: operand1,
        operand2: operand2,
        destination: destination,
      );
    }
  }

  @override
  MultiplyAndMultiplyLongArmInstruction visitMultiplyLong(
    MultiplyLongArmFormat format, [
    void _,
  ]) {
    final condition = Condition.parse(format.condition.value);
    final setConditionCodes = format.setConditionCodes;
    final operand1 = RegisterNotPC(format.operandRegister1);
    final operand2 = RegisterNotPC(format.operandRegister2);
    final destinationHiBits = RegisterNotPC(format.destinationRegisterHi);
    final destinationLoBits = RegisterNotPC(format.destinationRegisterLo);

    if (format.accumulate) {
      // A = 1
      // UMLAL or SMLAL
      if (format.signed) {
        // S = 1
        return SMLAL(
          condition: condition,
          setConditionCodes: setConditionCodes,
          operand1: operand1,
          operand2: operand2,
          destinationHiBits: destinationHiBits,
          destinationLoBits: destinationLoBits,
        );
      } else {
        // S = 0
        return UMLAL(
          condition: condition,
          setConditionCodes: setConditionCodes,
          operand1: operand1,
          operand2: operand2,
          destinationHiBits: destinationHiBits,
          destinationLoBits: destinationLoBits,
        );
      }
    } else {
      // A = 0
      // UMULL or SMULL
      if (format.signed) {
        // S = 1
        return SMULL(
          condition: condition,
          setConditionCodes: setConditionCodes,
          operand1: operand1,
          operand2: operand2,
          destinationHiBits: destinationHiBits,
          destinationLoBits: destinationLoBits,
        );
      } else {
        // S = 0
        return UMULL(
          condition: condition,
          setConditionCodes: setConditionCodes,
          operand1: operand1,
          operand2: operand2,
          destinationHiBits: destinationHiBits,
          destinationLoBits: destinationLoBits,
        );
      }
    }
  }

  @override
  SWP visitSingleDataSwap(
    SingleDataSwapArmFormat format, [
    void _,
  ]) {
    return SWP(
      condition: Condition.parse(format.condition.value),
      transferByte: format.swapByteQuantity,
      base: RegisterNotPC(format.baseRegister),
      destination: RegisterNotPC(format.destinationRegister),
      source: RegisterNotPC(format.sourceRegister),
    );
  }

  @override
  BX visitBranchAndExchange(
    BranchAndExchangeArmFormat format, [
    void _,
  ]) {
    return BX(
      condition: Condition.parse(format.condition.value),
      operand: RegisterNotPC(format.operand),
    );
  }

  @override
  HalfwordDataTransferArmInstruction visitHalfwordDataTransfer(
    HalfwordDataTransferArmFormat format, [
    void _,
  ]) {
    final condition = Condition.parse(format.condition.value);
    final addOffsetBeforeTransfer = format.preIndexingBit;
    final addOffsetToBase = format.addOffsetBit;
    final writeAddressIntoBase = format.writeAddressBit;
    final base = RegisterAny(format.baseRegister);
    final source = RegisterAny(format.sourceOrDestinationRegister);

    Or2<RegisterNotPC, Immediate<Uint8>> offset;
    if (format.immediateOffset) {
      final hiBits = format.offsetHiNibble.value << 4;
      final loBits = format.offsetLoNibble.value;
      offset = Or2.right(Immediate(Uint8(hiBits | loBits)));
    } else {
      offset = Or2.left(RegisterNotPC(format.offsetLoNibble));
    }

    if (format.loadMemoryBit) {
      // L = 1 (LDRH, LDRSB, LDRSH)
      switch (format.opCode.value) {
        case 0x1:
          return LDRH(
            condition: condition,
            addOffsetBeforeTransfer: addOffsetBeforeTransfer,
            addOffsetToBase: addOffsetToBase,
            writeAddressIntoBase: writeAddressIntoBase,
            base: base,
            source: source,
            offset: offset,
          );
        case 0x2:
          return LDRSB(
            condition: condition,
            addOffsetBeforeTransfer: addOffsetBeforeTransfer,
            addOffsetToBase: addOffsetToBase,
            writeAddressIntoBase: writeAddressIntoBase,
            base: base,
            source: source,
            offset: offset,
          );
        case 0x3:
          return LDRSH(
            condition: condition,
            addOffsetBeforeTransfer: addOffsetBeforeTransfer,
            addOffsetToBase: addOffsetToBase,
            writeAddressIntoBase: writeAddressIntoBase,
            base: base,
            source: source,
            offset: offset,
          );
        default:
          throw FormatException('Unexpected opCode: ${format.opCode.value}');
      }
    } else {
      // L = 0 (STRH)
      return STRH(
        condition: condition,
        addOffsetBeforeTransfer: addOffsetBeforeTransfer,
        addOffsetToBase: addOffsetToBase,
        writeAddressIntoBase: writeAddressIntoBase,
        base: base,
        destination: source,
        offset: offset,
      );
    }
  }

  @override
  SingleDataTransferArmInstruction visitSingleDataTransfer(
    SingleDataTransferArmFormat format, [
    void _,
  ]) {
    final condition = Condition.parse(format.condition.value);
    final addOffsetBeforeTransfer = format.preIndexingBit;
    final addOffsetToBase = format.addOffsetBit;
    final writeBack = format.writeAddressBit;
    final transferByte = format.byteQuantityBit;
    final base = RegisterAny(format.baseRegister);
    final sourceOrDestination = RegisterAny(format.sourceOrDestinationRegister);

    Or2<Immediate<Uint12>, ShiftedRegister<Immediate<Uint4>, RegisterNotPC>>
        offset;

    if (format.immediateOffset) {
      // I = 0
      offset = Or2.left(Immediate(format.offset));
    } else {
      // I = 1
      // format.offset.bitRange(11, 7).value.asUint4(),
      offset = Or2.right(ShiftedRegister(
        RegisterNotPC(Uint4(format.offset.bitRange(3, 0).value)),
        ShiftType.values[format.offset.bitRange(6, 5).value],
        Immediate(Uint4(format.offset.bitRange(11, 7).value)),
      ));
    }

    if (format.loadMemoryBit) {
      // L = 1
      return LDR(
        condition: condition,
        addOffsetBeforeTransfer: addOffsetBeforeTransfer,
        addOffsetToBase: addOffsetToBase,
        writeAddressIntoBaseOrForceNonPrivilegedAccess: writeBack,
        transferByte: transferByte,
        base: base,
        source: sourceOrDestination,
        offset: offset,
      );
    } else {
      // L = 0
      return STR(
        condition: condition,
        addOffsetBeforeTransfer: addOffsetBeforeTransfer,
        addOffsetToBase: addOffsetToBase,
        writeAddressIntoBaseOrForceNonPrivilegedAccess: writeBack,
        transferByte: transferByte,
        base: base,
        destination: sourceOrDestination,
        offset: offset,
      );
    }
  }

  @override
  BlockDataTransferArmInstruction visitBlockDataTransfer(
    BlockDataTransferArmFormat format, [
    void _,
  ]) {
    final condition = Condition.parse(format.condition.value);
    final addOffsetBeforeTransfer = format.preIndexingBit;
    final addOffsetToBase = format.addOffsetBit;
    final writeAddressIntoBase = format.writeAddressBit;
    final base = RegisterAny(format.baseRegister);
    final registerList = RegisterList<RegisterAny>.parse(
      format.registerList.value,
    );

    if (format.loadMemoryBit) {
      // L = 1
      return LDM(
        condition: condition,
        addOffsetBeforeTransfer: addOffsetBeforeTransfer,
        addOffsetToBase: addOffsetToBase,
        writeAddressIntoBase: writeAddressIntoBase,
        loadPsrOrForceUserMode: format.loadPsrOrForceUserMode,
        base: base,
        registerList: registerList,
      );
    } else {
      // L = 0
      return STM(
        condition: condition,
        addOffsetBeforeTransfer: addOffsetBeforeTransfer,
        addOffsetToBase: addOffsetToBase,
        writeAddressIntoBase: writeAddressIntoBase,
        loadPsrOrForceUserMode: format.loadPsrOrForceUserMode,
        base: base,
        registerList: registerList,
      );
    }
  }

  @override
  ArmInstruction visitBranch(
    BranchArmFormat format, [
    void _,
  ]) {
    final condition = Condition.parse(format.condition.value);
    final offset = format.offset;

    if (format.link) {
      // L = 1
      return BL(
        condition: condition,
        offset: offset,
      );
    } else {
      // L = 0
      return B(
        condition: condition,
        offset: offset,
      );
    }
  }

  @override
  SWI visitSoftwareInterrupt(
    SoftwareInterruptArmFormat format, [
    void _,
  ]) {
    return SWI(
      condition: Condition.parse(format.condition.value),
      comment: Comment(format.comment),
    );
  }
}

enum _ALUOpCode {
  AND,
  EOR,
  SUB,
  RSB,
  ADD,
  ADC,
  SBC,
  RSC,
  TST,
  TEQ,
  CMP,
  CMN,
  ORR,
  MOV,
  BIC,
  MVN,
}
