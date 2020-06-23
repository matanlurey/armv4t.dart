import 'package:meta/meta.dart';

import 'format.dart';

part 'instruction/branch/b.dart';
part 'instruction/branch/bcc.dart';
part 'instruction/branch/bcs.dart';
part 'instruction/branch/beq.dart';
part 'instruction/branch/bge.dart';
part 'instruction/branch/bgt.dart';
part 'instruction/branch/bhi.dart';
part 'instruction/branch/bl.dart';
part 'instruction/branch/ble.dart';
part 'instruction/branch/bls.dart';
part 'instruction/branch/blt.dart';
part 'instruction/branch/bmi.dart';
part 'instruction/branch/bne.dart';
part 'instruction/branch/bpl.dart';
part 'instruction/branch/bvc.dart';
part 'instruction/branch/bvs.dart';
part 'instruction/branch/bx.dart';
part 'instruction/data/ldmia.dart';
part 'instruction/data/ldr.dart';
part 'instruction/data/ldrb.dart';
part 'instruction/data/ldrh.dart';
part 'instruction/data/ldsh.dart';
part 'instruction/data/ldsb.dart';
part 'instruction/data/mov.dart';
part 'instruction/data/mvn.dart';
part 'instruction/data/stmia.dart';
part 'instruction/data/str.dart';
part 'instruction/data/strb.dart';
part 'instruction/data/strh.dart';
part 'instruction/logic/and.dart';
part 'instruction/logic/bic.dart';
part 'instruction/logic/cmn.dart';
part 'instruction/logic/cmp.dart';
part 'instruction/logic/eor.dart';
part 'instruction/logic/neg.dart';
part 'instruction/logic/orr.dart';
part 'instruction/logic/tst.dart';
part 'instruction/math/adc.dart';
part 'instruction/math/add.dart';
part 'instruction/math/mul.dart';
part 'instruction/math/sbc.dart';
part 'instruction/math/sub.dart';
part 'instruction/misc/pop.dart';
part 'instruction/misc/push.dart';
part 'instruction/misc/swi.dart';
part 'instruction/shift/asr.dart';
part 'instruction/shift/lsl.dart';
part 'instruction/shift/lsr.dart';
part 'instruction/shift/ror.dart';

/// An **internal** representation of a decoded `THUMB` instruction.
abstract class ThumbInstruction {
  const ThumbInstruction._();
}

/// Further decodes a [ThumbInstructionSet] into a [ThumbInstruction].
class Decoder implements ThumbInstructionSetVisitor<ThumbInstruction, void> {
  @alwaysThrows
  // ignore: prefer_void_to_null
  static Null _unrecognizedOpcode(int opcode) {
    throw StateError('Unrecognized opcode: $opcode');
  }

  @override
  ThumbInstruction visitMoveShiftedRegister(
    MoveShiftedRegister set, [
    void _,
  ]) {
    switch (set.opcode) {
      case 0x0:
        return LSL$MoveShiftedRegister(
          immediateValue: set.offset,
          sourceRegister: set.registerS,
          destinationRegister: set.registerD,
        );
      case 0x1:
        return LSR$MoveShiftedRegister(
          immediateValue: set.offset,
          sourceRegister: set.registerS,
          destinationRegister: set.registerD,
        );
      case 0x2:
        return ASR$MoveShiftedRegister(
          immediateValue: set.offset,
          sourceRegister: set.registerS,
          destinationRegister: set.registerD,
        );
      default:
        return _unrecognizedOpcode(set.opcode);
    }
  }

  @override
  ThumbInstruction visitAddAndSubtract(
    AddAndSubtract set, [
    void _,
  ]) {
    switch (set.opcode) {
      case 0x0:
        return ADD$AddSubtract$Register(
          otherRegister: set.registerNOrOffset3,
          sourceRegister: set.registerS,
          destinationRegister: set.registerD,
        );
      case 0x1:
        return ADD$AddSubtract$Offset3(
          immediateValue: set.registerNOrOffset3,
          sourceRegister: set.registerS,
          destinationRegister: set.registerD,
        );
      case 0x2:
        return SUB$AddSubtract$Register(
          otherRegister: set.registerNOrOffset3,
          sourceRegister: set.registerS,
          destinationRegister: set.registerD,
        );
      case 0x3:
        return SUB$AddSubtract$Offset3(
          immediateValue: set.registerNOrOffset3,
          sourceRegister: set.registerS,
          destinationRegister: set.registerD,
        );
      default:
        return _unrecognizedOpcode(set.opcode);
    }
  }

  @override
  ThumbInstruction visitMoveCompareAddAndSubtractImmediate(
    MoveCompareAddAndSubtractImmediate set, [
    void _,
  ]) {
    switch (set.opcode) {
      case 0x0:
        return MOV$MoveCompareAddSubtractImmediate(
          destinationRegister: set.registerD,
          immediateValue: set.offset,
        );
      case 0x1:
        return CMP$MoveCompareAddSubtractImmediate(
          destinationRegister: set.registerD,
          immediateValue: set.offset,
        );
      case 0x2:
        return ADD$MoveCompareAddSubtractImmediate(
          destinationRegister: set.registerD,
          immediateValue: set.offset,
        );
      case 0x3:
        return SUB$MoveCompareAddSubtractImmediate(
          destinationRegister: set.registerD,
          immediateValue: set.offset,
        );
      default:
        return _unrecognizedOpcode(set.opcode);
    }
  }

  @override
  ThumbInstruction visitALUOperation(
    ALUOperation set, [
    void _,
  ]) {
    switch (set.opcode) {
      case 0x0:
        return AND(
          destinationRegister: set.registerD,
          sourceRegister: set.registerS,
        );
      case 0x1:
        return EOR(
          destinationRegister: set.registerD,
          sourceRegister: set.registerS,
        );
      case 0x2:
        return LSL$ALU(
          destinationRegister: set.registerD,
          sourceRegister: set.registerS,
        );
      case 0x3:
        return LSR$ALU(
          destinationRegister: set.registerD,
          sourceRegister: set.registerS,
        );
      case 0x4:
        return ASR$ALU(
          destinationRegister: set.registerD,
          sourceRegister: set.registerS,
        );
      case 0x5:
        return ADC(
          destinationRegister: set.registerD,
          sourceRegister: set.registerS,
        );
      case 0x6:
        return SBC(
          destinationRegister: set.registerD,
          sourceRegister: set.registerS,
        );
      case 0x7:
        return ROR(
          destinationRegister: set.registerD,
          sourceRegister: set.registerS,
        );
      case 0x8:
        return TST(
          destinationRegister: set.registerD,
          sourceRegister: set.registerS,
        );
      case 0x9:
        return NEG(
          destinationRegister: set.registerD,
          sourceRegister: set.registerS,
        );
      case 0xA:
        return CMP$ALU(
          destinationRegister: set.registerD,
          sourceRegister: set.registerS,
        );
      case 0xB:
        return CMN(
          destinationRegister: set.registerD,
          sourceRegister: set.registerS,
        );
      case 0xC:
        return ORR(
          destinationRegister: set.registerD,
          sourceRegister: set.registerS,
        );
      case 0xD:
        return MUL(
          destinationRegister: set.registerD,
          sourceRegister: set.registerS,
        );
      case 0xE:
        return BIC(
          destinationRegister: set.registerD,
          sourceRegister: set.registerS,
        );
      case 0xF:
        return MVN(
          destinationRegister: set.registerD,
          sourceRegister: set.registerS,
        );
      default:
        return _unrecognizedOpcode(set.opcode);
    }
  }

  @override
  ThumbInstruction visitHighRegisterOperationsAndBranchExchange(
    HighRegisterOperationsAndBranchExchange set, [
    void _,
  ]) {
    switch (set.opcode) {
      case 0x0:
        return ADD$HiToLo(
          destinationRegister: set.registerDOrHD,
          sourceRegister: set.registerSOrHS,
        );
      case 0x1:
        return ADD$LoToHi(
          destinationRegister: set.registerDOrHD,
          sourceRegister: set.registerSOrHS,
        );
      case 0x2:
        return ADD$HiToHi(
          destinationRegister: set.registerDOrHD,
          sourceRegister: set.registerSOrHS,
        );
      case 0x3:
        return CMP$HiToLo(
          destinationRegister: set.registerDOrHD,
          sourceRegister: set.registerSOrHS,
        );
      case 0x4:
        return CMP$LoToHi(
          destinationRegister: set.registerDOrHD,
          sourceRegister: set.registerSOrHS,
        );
      case 0x5:
        return CMP$HiToHi(
          destinationRegister: set.registerDOrHD,
          sourceRegister: set.registerSOrHS,
        );
      case 0x6:
        return MOV$HiToLo(
          destinationRegister: set.registerDOrHD,
          sourceRegister: set.registerSOrHS,
        );
      case 0x7:
        return MOV$LoToHi(
          destinationRegister: set.registerDOrHD,
          sourceRegister: set.registerSOrHS,
        );
      case 0x8:
        return MOV$HiToHi(
          destinationRegister: set.registerDOrHD,
          sourceRegister: set.registerSOrHS,
        );
      case 0x9:
        return BX$Lo(
          sourceRegister: set.registerSOrHS,
        );
      case 0xA:
        return BX$Hi(
          sourceRegister: set.registerSOrHS,
        );
      default:
        return _unrecognizedOpcode(set.opcode);
    }
  }

  @override
  ThumbInstruction visitPCRelativeLoad(
    PCRelativeLoad set, [
    void _,
  ]) {
    return LDR$PCRelative(
      destinationRegister: set.registerD,
      immediateValue: set.word8,
    );
  }

  @override
  ThumbInstruction visitLoadAndStoreWithRelativeOffset(
    LoadAndStoreWithRelativeOffset set, [
    void _,
  ]) {
    if (set.l == 0) {
      if (set.b == 0) {
        return STR$RelativeOffset(
          offsetRegister: set.registerO,
          baseRegister: set.registerB,
          destinationRegister: set.registerD,
        );
      } else if (set.b == 1) {
        return STRB$RelativeOffset(
          offsetRegister: set.registerO,
          baseRegister: set.registerB,
          destinationRegister: set.registerD,
        );
      }
    } else if (set.l == 1) {
      if (set.b == 0) {
        return LDR$RelativeOffset(
          offsetRegister: set.registerO,
          baseRegister: set.registerB,
          destinationRegister: set.registerD,
        );
      } else if (set.b == 1) {
        return LDRB$RelativeOffset(
          offsetRegister: set.registerO,
          baseRegister: set.registerB,
          destinationRegister: set.registerD,
        );
      }
    }
    throw StateError('Invalid L or B: ${set.l}, ${set.b}');
  }

  @override
  ThumbInstruction visitLoadAndStoreSignExtendedByteAndHalfWord(
    LoadAndStoreSignExtendedByteAndHalfWord set, [
    void _,
  ]) {
    if (set.s == 0) {
      if (set.h == 0) {
        return STRH$SignExtendedByteOrHalfWord(
          offsetRegister: set.registerO,
          baseRegister: set.registerB,
          destinationRegister: set.registerD,
        );
      } else if (set.h == 1) {
        return LDRH$SignExtendedByteOrHalfWord(
          offsetRegister: set.registerO,
          baseRegister: set.registerB,
          destinationRegister: set.registerD,
        );
      }
    } else if (set.s == 1) {
      if (set.h == 0) {
        return LDSB(
          offsetRegister: set.registerO,
          baseRegister: set.registerB,
          destinationRegister: set.registerD,
        );
      } else if (set.h == 1) {
        return LDSH(
          offsetRegister: set.registerO,
          baseRegister: set.registerB,
          destinationRegister: set.registerD,
        );
      }
    }
    throw StateError('Invalid S or H: ${set.s}, ${set.h}');
  }

  @override
  ThumbInstruction visitLoadAndStoreWithImmediateOffset(
    LoadAndStoreWithImmediateOffset set, [
    void _,
  ]) {
    if (set.l == 0) {
      if (set.b == 0) {
        return STR$ImmediateOffset(
          immediateValue: set.offset5,
          baseRegister: set.registerB,
          destinationRegister: set.registerD,
        );
      } else if (set.b == 1) {
        return LDR$ImmediateOffset(
          immediateValue: set.offset5,
          baseRegister: set.registerB,
          destinationRegister: set.registerD,
        );
      }
    } else if (set.l == 1) {
      if (set.b == 0) {
        return STRB$ImmediateOffset(
          immediateValue: set.offset5,
          baseRegister: set.registerB,
          destinationRegister: set.registerD,
        );
      } else if (set.b == 1) {
        return LDRB$ImmediateOffset(
          immediateValue: set.offset5,
          baseRegister: set.registerB,
          destinationRegister: set.registerD,
        );
      }
    }
    throw StateError('Invalid L or B: ${set.l}, ${set.b}');
  }

  @override
  ThumbInstruction visitLoadAndStoreHalfWord(
    LoadAndStoreHalfWord set, [
    void _,
  ]) {
    switch (set.l) {
      case 0x0:
        return STRH$HalfWord(
          destinationRegister: set.registerD,
          baseRegister: set.registerB,
          immediateValue: set.offset5,
        );
      case 0x1:
        return LDRH$HalfWord(
          destinationRegister: set.registerD,
          baseRegister: set.registerB,
          immediateValue: set.offset5,
        );
      default:
        throw StateError('Invalid L: ${set.l}');
    }
  }

  @override
  ThumbInstruction visitSPRelativeLoadAndStore(
    SPRelativeLoadAndStore set, [
    void _,
  ]) {
    switch (set.l) {
      case 0x0:
        return STR$SPRelative(
          destinationRegister: set.registerD,
          immediateValue: set.word8,
        );
      case 0x1:
        return LDR$SPRelative(
          destinationRegister: set.registerD,
          immediateValue: set.word8,
        );
      default:
        throw StateError('Invalid L: ${set.l}');
    }
  }

  @override
  ThumbInstruction visitLoadAddress(
    LoadAddress set, [
    void _,
  ]) {
    switch (set.sp) {
      case 0x0:
        return ADD$LoadAddress$PC(
          destinationRegister: set.registerD,
          immediateValue: set.word8,
        );
      case 0x1:
        return ADD$LoadAddress$SP(
          destinationRegister: set.registerD,
          immediateValue: set.word8,
        );
      default:
        throw StateError('Invalid SP: ${set.sp}');
    }
  }

  @override
  ThumbInstruction visitAddOffsetToStackPointer(
    AddOffsetToStackPointer set, [
    void _,
  ]) {
    switch (set.s) {
      case 0x0:
        return ADD$OffsetToStackPointer$Positive(
          immediateValue: set.sWord7,
        );
      case 0x1:
        return ADD$OffsetToStackPointer$Negative(
          immediateValue: set.sWord7,
        );
      default:
        throw StateError('Invalid S: ${set.s}');
    }
  }

  @override
  ThumbInstruction visitPushAndPopRegisters(
    PushAndPopRegisters set, [
    void _,
  ]) {
    if (set.l == 0) {
      if (set.r == 0) {
        return PUSH$Registers(
          registerList: set.registerList,
        );
      } else if (set.r == 1) {
        return PUSH$RegistersAndLinkRegister(
          registerList: set.registerList,
        );
      }
    } else if (set.l == 1) {
      if (set.r == 0) {
        return POP$Registers(
          registerList: set.registerList,
        );
      } else if (set.r == 1) {
        return POP$RegistersAndLinkRegister(
          registerList: set.registerList,
        );
      }
    }
    throw StateError('Invalid L or R: ${set.l}, ${set.r}');
  }

  @override
  ThumbInstruction visitMultipleLoadAndStore(
    MultipleLoadAndStore set, [
    void _,
  ]) {
    switch (set.l) {
      case 0x0:
        return STMIA(
          baseRegister: set.registerB,
          registerList: set.registerList,
        );
      case 0x1:
        return LDMIA(
          baseRegister: set.registerB,
          registerList: set.registerList,
        );
      default:
        throw StateError('Invalid L: ${set.l}');
    }
  }

  @override
  ThumbInstruction visitConditionalBranch(
    ConditionalBranch set, [
    void _,
  ]) {
    switch (set.condition) {
      case 0x0:
        return BEQ();
      case 0x1:
        return BNE();
      case 0x2:
        return BCS();
      case 0x3:
        return BCC();
      case 0x4:
        return BMI();
      case 0x5:
        return BPL();
      case 0x6:
        return BVS();
      case 0x7:
        return BVC();
      case 0x8:
        return BHI();
      case 0x9:
        return BLS();
      case 0xA:
        return BGE();
      case 0xB:
        return BLT();
      case 0xC:
        return BGT();
      case 0xD:
        return BLE();
      default:
        throw StateError('Invalid Cond: ${set.condition}');
    }
  }

  @override
  ThumbInstruction visitSoftwareInterrupt(
    SoftwareInterrupt set, [
    void _,
  ]) {
    return SWI(value: set.value8);
  }

  @override
  ThumbInstruction visitUnconditionalBranch(
    UnconditionalBranch set, [
    void _,
  ]) {
    return B(immdediateValue: set.offset11);
  }

  @override
  ThumbInstruction visitLongBranchWithLink(
    LongBranchWithLink set, [
    void _,
  ]) {
    switch (set.h) {
      case 0:
        return BL$1(offset: set.offset);
      case 1:
        return BL$2(offset: set.offset);
      default:
        throw StateError('Invalid H: ${set.h}');
    }
  }
}
