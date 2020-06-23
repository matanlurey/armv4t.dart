import 'package:armv4t/src/decode/thumb/printer.dart';
import 'package:armv4t/src/utils.dart';
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

  /// Invokes the correct sub-method of [visitor], optionally with [context].
  R accept<R, C>(
    ThumbInstructionVisitor<R, C> visitor, [
    C context,
  ]);

  @override
  String toString() {
    if (assertionsEnabled) {
      return accept(const ThumbInstructionPrinter());
    } else {
      return super.toString();
    }
  }
}

/// Further decodes a [ThumbInstructionSet] into a [ThumbInstruction].
class ThumbDecoder implements ThumbSetVisitor<ThumbInstruction, void> {
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
    if (set.opcode == 0) {
      if (set.i == 0) {
        return ADD$AddSubtract$Register(
          otherRegister: set.registerNOrOffset3,
          sourceRegister: set.registerS,
          destinationRegister: set.registerD,
        );
      } else if (set.i == 1) {
        return ADD$AddSubtract$Offset3(
          immediateValue: set.registerNOrOffset3,
          sourceRegister: set.registerS,
          destinationRegister: set.registerD,
        );
      }
    } else if (set.opcode == 1) {
      if (set.i == 0) {
        return SUB$AddSubtract$Register(
          otherRegister: set.registerNOrOffset3,
          sourceRegister: set.registerS,
          destinationRegister: set.registerD,
        );
      } else if (set.i == 1) {
        return SUB$AddSubtract$Offset3(
          immediateValue: set.registerNOrOffset3,
          sourceRegister: set.registerS,
          destinationRegister: set.registerD,
        );
      }
    } else {
      return _unrecognizedOpcode(set.opcode);
    }
    throw StateError('Unrecognized "I": ${set.i}');
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
    if (set.opcode == 0) {
      if (set.h1 == 0 && set.h2 == 1) {
        return ADD$HiToLo(
          destinationRegister: set.registerDOrHD,
          sourceRegister: set.registerSOrHS,
        );
      } else if (set.h1 == 1) {
        if (set.h2 == 0) {
          return ADD$LoToHi(
            destinationRegister: set.registerDOrHD,
            sourceRegister: set.registerSOrHS,
          );
        } else if (set.h2 == 1) {
          return ADD$HiToHi(
            destinationRegister: set.registerDOrHD,
            sourceRegister: set.registerSOrHS,
          );
        }
      }
    } else if (set.opcode == 1) {
      if (set.h1 == 0 && set.h2 == 1) {
        return CMP$HiToLo(
          destinationRegister: set.registerDOrHD,
          sourceRegister: set.registerSOrHS,
        );
      } else if (set.h1 == 1) {
        if (set.h2 == 0) {
          return CMP$LoToHi(
            destinationRegister: set.registerDOrHD,
            sourceRegister: set.registerSOrHS,
          );
        } else if (set.h2 == 1) {
          return CMP$HiToHi(
            destinationRegister: set.registerDOrHD,
            sourceRegister: set.registerSOrHS,
          );
        }
      }
    } else if (set.opcode == 2) {
      if (set.h1 == 0 && set.h2 == 1) {
        return MOV$HiToLo(
          destinationRegister: set.registerDOrHD,
          sourceRegister: set.registerSOrHS,
        );
      } else if (set.h1 == 1) {
        if (set.h2 == 0) {
          return MOV$LoToHi(
            destinationRegister: set.registerDOrHD,
            sourceRegister: set.registerSOrHS,
          );
        } else if (set.h2 == 1) {
          return MOV$HiToHi(
            destinationRegister: set.registerDOrHD,
            sourceRegister: set.registerSOrHS,
          );
        }
      }
    } else if (set.opcode == 3) {
      if (set.h1 == 0) {
        if (set.h2 == 0) {
          return BX$Lo(
            sourceRegister: set.registerSOrHS,
          );
        } else if (set.h2 == 1) {
          return BX$Hi(
            sourceRegister: set.registerSOrHS,
          );
        }
      }
    } else {
      return _unrecognizedOpcode(set.opcode);
    }
    throw StateError(
      'Unrecognized Op/H1/H2: ${set.opcode}/${set.h1}/${set.h2}',
    );
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
        return BEQ(label: set.softSet8);
      case 0x1:
        return BNE(label: set.softSet8);
      case 0x2:
        return BCS(label: set.softSet8);
      case 0x3:
        return BCC(label: set.softSet8);
      case 0x4:
        return BMI(label: set.softSet8);
      case 0x5:
        return BPL(label: set.softSet8);
      case 0x6:
        return BVS(label: set.softSet8);
      case 0x7:
        return BVC(label: set.softSet8);
      case 0x8:
        return BHI(label: set.softSet8);
      case 0x9:
        return BLS(label: set.softSet8);
      case 0xA:
        return BGE(label: set.softSet8);
      case 0xB:
        return BLT(label: set.softSet8);
      case 0xC:
        return BGT(label: set.softSet8);
      case 0xD:
        return BLE(label: set.softSet8);
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
      case 1:
        return BL(offset: set.offset, h: set.h);
      default:
        throw StateError('Invalid H: ${set.h}');
    }
  }
}

abstract class ThumbInstructionVisitor<R, C> {
  R visitLSL$MoveShiftedRegister(
    LSL$MoveShiftedRegister instruction, [
    C context,
  ]);

  R visitLSR$MoveShiftedRegister(
    LSR$MoveShiftedRegister instruction, [
    C context,
  ]);

  R visitASR$MoveShiftedRegister(
    ASR$MoveShiftedRegister instruction, [
    C context,
  ]);

  R visitADD$AddSubtract$Register(
    ADD$AddSubtract$Register instruction, [
    C context,
  ]);

  R visitADD$AddSubtract$Offset3(
    ADD$AddSubtract$Offset3 instruction, [
    C context,
  ]);

  R visitSUB$AddSubtract$Register(
    SUB$AddSubtract$Register instruction, [
    C context,
  ]);

  R visitSUB$AddSubtract$Offset3(
    SUB$AddSubtract$Offset3 instruction, [
    C context,
  ]);

  R visitMOV$MoveCompareAddSubtractImmediate(
    MOV$MoveCompareAddSubtractImmediate instruction, [
    C context,
  ]);

  R visitCMP$MoveCompareAddSubtractImmediate(
    CMP$MoveCompareAddSubtractImmediate instruction, [
    C context,
  ]);

  R visitADD$MoveCompareAddSubtractImmediate(
    ADD$MoveCompareAddSubtractImmediate instruction, [
    C context,
  ]);

  R visitSUB$MoveCompareAddSubtractImmediate(
    SUB$MoveCompareAddSubtractImmediate instruction, [
    C context,
  ]);

  R visitAND(
    AND instruction, [
    C context,
  ]);

  R visitEOR(
    EOR instruction, [
    C context,
  ]);

  R visitLSL$ALU(
    LSL$ALU instruction, [
    C context,
  ]);

  R visitLSR$ALU(
    LSR$ALU instruction, [
    C context,
  ]);

  R visitASR$ALU(
    ASR$ALU instruction, [
    C context,
  ]);

  R visitADC(
    ADC instruction, [
    C context,
  ]);

  R visitSBC(
    SBC instruction, [
    C context,
  ]);

  R visitROR(
    ROR instruction, [
    C context,
  ]);

  R visitTST(
    TST instruction, [
    C context,
  ]);

  R visitNEG(
    NEG instruction, [
    C context,
  ]);

  R visitCMP$ALU(
    CMP$ALU instruction, [
    C context,
  ]);

  R visitCMN(
    CMN instruction, [
    C context,
  ]);

  R visitORR(
    ORR instruction, [
    C context,
  ]);

  R visitMUL(
    MUL instruction, [
    C context,
  ]);

  R visitBIC(
    BIC instruction, [
    C context,
  ]);

  R visitMVN(
    MVN instruction, [
    C context,
  ]);

  R visitADD$HiToLo(
    ADD$HiToLo instruction, [
    C context,
  ]);

  R visitADD$LoToHi(
    ADD$LoToHi instruction, [
    C context,
  ]);

  R visitADD$HiToHi(
    ADD$HiToHi instruction, [
    C context,
  ]);

  R visitCMP$HiToLo(
    CMP$HiToLo instruction, [
    C context,
  ]);

  R visitCMP$LoToHi(
    CMP$LoToHi instruction, [
    C context,
  ]);

  R visitCMP$HiToHi(
    CMP$HiToHi instruction, [
    C context,
  ]);

  R visitMOV$HiToLo(
    MOV$HiToLo instruction, [
    C context,
  ]);

  R visitMOV$LoToHi(
    MOV$LoToHi instruction, [
    C context,
  ]);

  R visitMOV$HiToHi(
    MOV$HiToHi instruction, [
    C context,
  ]);

  R visitBX$Lo(
    BX$Lo instruction, [
    C context,
  ]);

  R visitBX$Hi(
    BX$Hi instruction, [
    C context,
  ]);

  R visitLDR$PCRelative(
    LDR$PCRelative instruction, [
    C context,
  ]);

  R visitSTR$RelativeOffset(
    STR$RelativeOffset instruction, [
    C context,
  ]);

  R visitSTRB$RelativeOffset(
    STRB$RelativeOffset instruction, [
    C context,
  ]);

  R visitLDR$RelativeOffset(
    LDR$RelativeOffset instruction, [
    C context,
  ]);

  R visitLDRB$RelativeOffset(
    LDRB$RelativeOffset instruction, [
    C context,
  ]);

  R visitSTRH$SignExtendedByteOrHalfWord(
    STRH$SignExtendedByteOrHalfWord instruction, [
    C context,
  ]);

  R visitLDRH$SignExtendedByteOrHalfWord(
    LDRH$SignExtendedByteOrHalfWord instruction, [
    C context,
  ]);

  R visitLDSB(
    LDSB instruction, [
    C context,
  ]);

  R visitLDSH(
    LDSH instruction, [
    C context,
  ]);

  R visitSTR$ImmediateOffset(
    STR$ImmediateOffset instruction, [
    C context,
  ]);

  R visitLDR$ImmediateOffset(
    LDR$ImmediateOffset instruction, [
    C context,
  ]);

  R visitSTRB$ImmediateOffset(
    STRB$ImmediateOffset instruction, [
    C context,
  ]);

  R visitLDRB$ImmediateOffset(
    LDRB$ImmediateOffset instruction, [
    C context,
  ]);

  R visitSTRH$HalfWord(
    STRH$HalfWord instruction, [
    C context,
  ]);

  R visitLDRH$HalfWord(
    LDRH$HalfWord instruction, [
    C context,
  ]);

  R visitSTR$SPRelative(
    STR$SPRelative instruction, [
    C context,
  ]);

  R visitLDR$SPRelative(
    LDR$SPRelative instruction, [
    C context,
  ]);

  R visitADD$LoadAddress$PC(
    ADD$LoadAddress$PC instruction, [
    C context,
  ]);

  R visitADD$LoadAddress$SP(
    ADD$LoadAddress$SP instruction, [
    C context,
  ]);

  R visitADD$OffsetToStackPointer$Positive(
    ADD$OffsetToStackPointer$Positive instruction, [
    C context,
  ]);

  R visitADD$OffsetToStackPointer$Negative(
    ADD$OffsetToStackPointer$Negative instruction, [
    C context,
  ]);

  R visitPUSH$Registers(
    PUSH$Registers instruction, [
    C context,
  ]);

  R visitPUSH$RegistersAndLinkRegister(
    PUSH$RegistersAndLinkRegister instruction, [
    C context,
  ]);

  R visitPOP$Registers(
    POP$Registers instruction, [
    C context,
  ]);

  R visitPOP$RegistersAndProgramCounter(
    POP$RegistersAndLinkRegister instruction, [
    C context,
  ]);

  R visitSTMIA(
    STMIA instruction, [
    C context,
  ]);

  R visitLDMIA(
    LDMIA instruction, [
    C context,
  ]);

  R visitBEQ(
    BEQ instruction, [
    C context,
  ]);

  R visitBNE(
    BNE instruction, [
    C context,
  ]);

  R visitBCS(
    BCS instruction, [
    C context,
  ]);

  R visitBCC(
    BCC instruction, [
    C context,
  ]);

  R visitBMI(
    BMI instruction, [
    C context,
  ]);

  R visitBPL(
    BPL instruction, [
    C context,
  ]);

  R visitBVS(
    BVS instruction, [
    C context,
  ]);

  R visitBVC(
    BVC instruction, [
    C context,
  ]);

  R visitBHI(
    BHI instruction, [
    C context,
  ]);

  R visitBLS(
    BLS instruction, [
    C context,
  ]);

  R visitBGE(
    BGE instruction, [
    C context,
  ]);

  R visitBLT(
    BLT instruction, [
    C context,
  ]);

  R visitBGT(
    BGT instruction, [
    C context,
  ]);

  R visitBLE(
    BLE instruction, [
    C context,
  ]);

  R visitSWI(
    SWI instruction, [
    C context,
  ]);

  R visitB(
    B instruction, [
    C context,
  ]);

  R visitBL(
    BL instruction, [
    C context,
  ]);
}
