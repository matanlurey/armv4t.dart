import 'package:armv4t/src/utils.dart';
import 'package:binary/binary.dart';
import 'package:meta/meta.dart';

import 'format.dart';
import 'printer.dart';

part 'instruction/branch/b.dart';
part 'instruction/branch/bl.dart';
part 'instruction/branch/bx.dart';
part 'instruction/coprocessor/cdp.dart';
part 'instruction/coprocessor/ldc.dart';
part 'instruction/coprocessor/mcr.dart';
part 'instruction/coprocessor/mrc.dart';
part 'instruction/coprocessor/stc.dart';
part 'instruction/data/ldm.dart';
part 'instruction/data/ldr.dart';
part 'instruction/data/ldrb.dart';
part 'instruction/data/ldrh.dart';
part 'instruction/data/ldrsb.dart';
part 'instruction/data/ldrsh.dart';
part 'instruction/data/mov.dart';
part 'instruction/data/mrs.dart';
part 'instruction/data/msr.dart';
part 'instruction/data/mvn.dart';
part 'instruction/data/stm.dart';
part 'instruction/data/str.dart';
part 'instruction/data/strb.dart';
part 'instruction/data/strh.dart';
part 'instruction/data/swp.dart';
part 'instruction/data/swpb.dart';
part 'instruction/logic/and.dart';
part 'instruction/logic/bic.dart';
part 'instruction/logic/cmn.dart';
part 'instruction/logic/cmp.dart';
part 'instruction/logic/eor.dart';
part 'instruction/logic/orr.dart';
part 'instruction/logic/teq.dart';
part 'instruction/logic/tst.dart';
part 'instruction/math/adc.dart';
part 'instruction/math/add.dart';
part 'instruction/math/mla.dart';
part 'instruction/math/mul.dart';
part 'instruction/math/rsb.dart';
part 'instruction/math/rsc.dart';
part 'instruction/math/sbc.dart';
part 'instruction/math/sub.dart';
part 'instruction/math/smlal.dart';
part 'instruction/math/smull.dart';
part 'instruction/math/umlal.dart';
part 'instruction/math/umull.dart';
part 'instruction/misc/swi.dart';

/// An **internal** representation of a decoded `ARM` instruction.
abstract class ArmInstruction {
  /// Condition field.
  final int condition;

  const ArmInstruction._(this.condition);

  /// Invokes the correct sub-method of [visitor], optionally with [context].
  R accept<R, C>(
    ArmInstructionVisitor<R, C> visitor, [
    C context,
  ]);

  @override
  String toString() {
    if (assertionsEnabled) {
      return accept(const ArmInstructionPrinter());
    } else {
      return super.toString();
    }
  }
}

/// Further decodes an [ArmInstructionSet] into an [ArmInstruction].
class ArmDecoder implements ArmSetVisitor<ArmInstruction, void> {
  const ArmDecoder();

  @override
  ArmInstruction visitDataProcessingOrPSRTransfer(
    DataProcessingOrPSRTransfer set, [
    void _,
  ]) {
    // Note that TEQ, TST, CMN, and CMP are a PSR Transfer if S = 0.
    //
    // DATA: CCCC_00IP_PPPS_NNNN_DDDD_OOOO_OOOO_OOOO
    // MRS:  CCCC_0001_0S00_1111_DDDD_0000_0000_0000
    //               ^ ^^^
    //               1 000 (TST)
    //               1 010 (CMP)
    // MSR:  CCCC_0001_0D10_1001_1111_0000_0000_MMMM [-> PSR]
    //               ^ ^^^
    //               1 001 (TEQ)
    //               1 011 (CMN)
    // MSR:  CCCC_00I1_0D10_1000_1111_OOOO_OOOO_OOOO [-> PSR Flag Bits Only]
    //               ^ ^^^
    //               1 001 (TEQ)
    //               1 011 (CMN)
    switch (set.opcode) {
      case 0x0:
        return AND(
          condition: set.condition,
          i: set.i,
          s: set.s,
          sourceRegister: set.registerN,
          destinationRegister: set.registerD,
          shifterOperand: set.operand2,
        );
      case 0x1:
        return EOR(
          condition: set.condition,
          i: set.i,
          s: set.s,
          sourceRegister: set.registerN,
          destinationRegister: set.registerD,
          shifterOperand: set.operand2,
        );
      case 0x2:
        return SUB(
          condition: set.condition,
          i: set.i,
          s: set.s,
          sourceRegister: set.registerN,
          destinationRegister: set.registerD,
          shifterOperand: set.operand2,
        );
      case 0x3:
        return RSB(
          condition: set.condition,
          i: set.i,
          s: set.s,
          sourceRegister: set.registerN,
          destinationRegister: set.registerD,
          shifterOperand: set.operand2,
        );
      case 0x4:
        return ADD(
          condition: set.condition,
          i: set.i,
          s: set.s,
          sourceRegister: set.registerN,
          destinationRegister: set.registerD,
          shifterOperand: set.operand2,
        );
      case 0x5:
        return ADC(
          condition: set.condition,
          i: set.i,
          s: set.s,
          sourceRegister: set.registerN,
          destinationRegister: set.registerD,
          shifterOperand: set.operand2,
        );
      case 0x6:
        return SBC(
          condition: set.condition,
          i: set.i,
          s: set.s,
          sourceRegister: set.registerN,
          destinationRegister: set.registerD,
          shifterOperand: set.operand2,
        );
      case 0x7:
        return RSC(
          condition: set.condition,
          i: set.i,
          s: set.s,
          sourceRegister: set.registerN,
          destinationRegister: set.registerD,
          shifterOperand: set.operand2,
        );
      case 0x8:
        if (set.s == 0) {
          // Interpret as MRS.
          //
          // DATA: CCCC_00IP_PPPS_NNNN_DDDD_OOOO_OOOO_OOOO
          // MRS:  CCCC_0001_0S00_1111_DDDD_0000_0000_0000
          assert(set.opcode.getBit(1) == 0);
          return MRS(
            condition: set.condition,
            sourcePSR: 0,
            destinationRegister: set.registerD,
          );
        } else if (set.s == 1) {
          return TST(
            condition: set.condition,
            i: set.i,
            sourceRegister: set.registerN,
            destinationRegister: set.registerD,
            shifterOperand: set.operand2,
          );
        }
        throw StateError('Unexpected S: ${set.s}');
      case 0x9:
        if (set.s == 0) {
          // Interpret as MSR.
          //
          // DATA: CCCC_00IP_PPPS_NNNN_DDDD_OOOO_OOOO_OOOO
          // MSR:  CCCC_0001_0D10_MMMM_1111_0000_0000_MMMM
          //       CCCC_00I1_0D10_MMMM_1111_OOOO_OOOO_OOOO
          assert(set.opcode.getBit(1) == 0);
          return MSR(
            condition: set.condition,
            immediateOperand: set.i,
            destinationPSR: 0,
            fieldMask: set.registerN,
            sourceOperand: set.operand2,
          );
        } else if (set.s == 1) {
          return TEQ(
            condition: set.condition,
            i: set.i,
            sourceRegister: set.registerN,
            destinationRegister: set.registerD,
            shifterOperand: set.operand2,
          );
        }
        throw StateError('Unexpected S: ${set.s}');
      case 0xA:
        if (set.s == 0) {
          // Interpret as MRS.
          //
          // DATA: CCCC_00IP_PPPS_NNNN_DDDD_OOOO_OOOO_OOOO
          // MRS:  CCCC_0001_0S00_1111_DDDD_0000_0000_0000
          assert(set.opcode.getBit(1) == 1);
          return MRS(
            condition: set.condition,
            sourcePSR: 1,
            destinationRegister: set.registerD,
          );
        } else if (set.s == 1) {
          return CMP(
            condition: set.condition,
            i: set.i,
            sourceRegister: set.registerN,
            destinationRegister: set.registerD,
            shifterOperand: set.operand2,
          );
        }
        throw StateError('Unexpected S: ${set.s}');
      case 0xB:
        if (set.s == 0) {
          // Interpret as MSR.
          //
          // DATA: CCCC_00IP_PPPS_NNNN_DDDD_OOOO_OOOO_OOOO
          // MSR:  CCCC_0001_0D10_MMMM_1111_0000_0000_MMMM
          //       CCCC_00I1_0D10_MMMM_1111_OOOO_OOOO_OOOO
          assert(set.opcode.getBit(1) == 1);
          return MSR(
            condition: set.condition,
            immediateOperand: set.i,
            destinationPSR: 1,
            fieldMask: set.registerN,
            sourceOperand: set.operand2,
          );
        } else if (set.s == 1) {
          return CMN(
            condition: set.condition,
            i: set.i,
            sourceRegister: set.registerN,
            destinationRegister: set.registerD,
            shifterOperand: set.operand2,
          );
        }
        throw StateError('Unexpected S: ${set.s}');
      case 0xC:
        return ORR(
          condition: set.condition,
          i: set.i,
          s: set.s,
          sourceRegister: set.registerN,
          destinationRegister: set.registerD,
          shifterOperand: set.operand2,
        );
      case 0xD:
        return MOV(
          condition: set.condition,
          i: set.i,
          s: set.s,
          destinationRegister: set.registerD,
          shifterOperand: set.operand2,
        );
      case 0xE:
        return BIC(
          condition: set.condition,
          i: set.i,
          s: set.s,
          sourceRegister: set.registerN,
          destinationRegister: set.registerD,
          shifterOperand: set.operand2,
        );
      case 0xF:
        return MVN(
          condition: set.condition,
          i: set.i,
          s: set.s,
          destinationRegister: set.registerD,
          shifterOperand: set.operand2,
        );
      default:
        throw StateError('Unexpected opcode: ${set.opcode}');
    }
  }

  @override
  ArmInstruction visitMultiplyAndMutiplyAccumulate(
    MultiplyAndMutiplyAccumulate set, [
    void _,
  ]) {
    if (set.a == 0) {
      return MUL(
        condition: set.condition,
        s: set.s,
        destinationRegister: set.registerD,
        sourceRegister: set.registerS,
        operandRegister: set.registerN,
      );
    } else if (set.a == 1) {
      return MLA(
        condition: set.condition,
        s: set.s,
        destinationRegister: set.registerD,
        sourceRegister: set.registerS,
        operandRegister1: set.registerN,
        operandRegister2: set.registerM,
      );
    } else {
      throw StateError('Unexpected A: ${set.a}');
    }
  }

  @override
  ArmInstruction visitMultiplyLongAndMutiplyAccumulateLong(
    MultiplyLongAndMutiplyAccumulateLong set, [
    void _,
  ]) {
    if (set.u == 0) {
      if (set.a == 0) {
        return SMULL(
          condition: set.condition,
          s: set.s,
          destinationRegisterMSW: set.registerD,
          destinationRegisterLSW: set.registerN,
          sourceRegister: set.registerS,
          operandRegister: set.registerM,
        );
      } else if (set.a == 1) {
        return SMLAL(
          condition: set.condition,
          s: set.s,
          destinationRegisterMSW: set.registerD,
          destinationRegisterLSW: set.registerN,
          sourceRegister: set.registerS,
          operandRegister: set.registerM,
        );
      }
    } else if (set.u == 1) {
      if (set.a == 0) {
        return UMULL(
          condition: set.condition,
          s: set.s,
          destinationRegisterMSW: set.registerD,
          destinationRegisterLSW: set.registerN,
          sourceRegister: set.registerS,
          operandRegister: set.registerM,
        );
      } else if (set.a == 1) {
        return UMLAL(
          condition: set.condition,
          s: set.s,
          destinationRegisterMSW: set.registerD,
          destinationRegisterLSW: set.registerN,
          sourceRegister: set.registerS,
          operandRegister: set.registerM,
        );
      }
    }
    throw StateError('Unexpected S or A: ${set.s}, ${set.a}');
  }

  @override
  ArmInstruction visitSingleDataSwap(
    SingleDataSwap set, [
    void _,
  ]) {
    if (set.b == 0) {
      return SWP(
        condition: set.condition,
        sourceRegister1: set.registerN,
        sourceRegister2: set.registerM,
        destinationRegister: set.registerD,
      );
    } else if (set.b == 1) {
      return SWPB(
        condition: set.condition,
        sourceRegister1: set.registerN,
        sourceRegister2: set.registerM,
        destinationRegister: set.registerD,
      );
    } else {
      throw StateError('Unexpected B: ${set.b}');
    }
  }

  @override
  ArmInstruction visitBranchAndExchange(
    BranchAndExchange set, [
    void _,
  ]) {
    return BX(
      condition: set.condition,
      targetAddress: set.registerN,
    );
  }

  @override
  ArmInstruction visitHalfWordAndSignedDataTransferRegisterOffset(
    HalfWordAndSignedDataTransferRegisterOffset set, [
    void _,
  ]) {
    // LDRH, STRH, LDSRB, LDSRSH.
    throw UnimplementedError();
  }

  @override
  ArmInstruction visitHalfWordAndSignedDataTransferImmediateOffset(
    HalfWordAndSignedDataTransferImmediateOffset set, [
    void _,
  ]) {
    // LDRH, STRH, LDSRB, LDSRSH.
    throw UnimplementedError();
  }

  @override
  ArmInstruction visitSingleDataTransfer(
    SingleDataTransfer set, [
    void _,
  ]) {
    // TODO: Determine how P, U, W are assembled.
    if (set.l == 0) {
      if (set.b == 0) {
        return STR(
          condition: set.condition,
          i: set.i,
          p: set.p,
          u: set.u,
          w: set.w,
          destinationRegister: set.registerD,
          sourceRegister: set.registerN,
          addressingMode: set.offset,
        );
      } else if (set.b == 1) {
        return STRB(
          condition: set.condition,
          i: set.i,
          p: set.p,
          u: set.u,
          w: set.w,
          destinationRegister: set.registerD,
          sourceRegister: set.registerN,
          addressingMode: set.offset,
        );
      }
    } else if (set.l == 1) {
      if (set.b == 0) {
        return LDR(
          condition: set.condition,
          i: set.i,
          p: set.p,
          u: set.u,
          w: set.w,
          destinationRegister: set.registerD,
          sourceRegister: set.registerN,
          addressingMode: set.offset,
        );
      } else if (set.b == 1) {
        return LDRB(
          condition: set.condition,
          i: set.i,
          p: set.p,
          u: set.u,
          w: set.w,
          destinationRegister: set.registerD,
          sourceRegister: set.registerN,
          addressingMode: set.offset,
        );
      }
    }
    throw StateError('Unexpected L or B: ${set.l}, ${set.b}');
  }

  @override
  ArmInstruction visitUndefined(
    Undefined set, [
    void _,
  ]) {
    throw UnimplementedError('TODO: Implement UND instruction.');
  }

  @override
  ArmInstruction visitBlockDataTransfer(
    BlockDataTransfer set, [
    void _,
  ]) {
    if (set.l == 0) {
      return LDM(
        condition: set.condition,
        p: set.p,
        u: set.u,
        w: set.w,
        sourceRegister: set.registerN,
        registerList: set.regsiterList,
      );
    } else if (set.l == 1) {
      return STM(
        condition: set.condition,
        p: set.p,
        u: set.u,
        w: set.w,
        sourceRegister: set.registerN,
        registerList: set.regsiterList,
      );
    } else {
      throw StateError('Unexpected L: ${set.l}');
    }
  }

  @override
  ArmInstruction visitBranch(
    Branch set, [
    void _,
  ]) {
    if (set.l == 0) {
      return B(
        condition: set.condition,
        targetAddress: set.offset,
      );
    } else if (set.l == 1) {
      return BL(
        condition: set.condition,
        targetAddress: set.offset,
      );
    } else {
      throw StateError('Unexpected L: ${set.l}');
    }
  }

  @override
  ArmInstruction visitCoprocessorDataTransfer(
    CoprocessorDataTransfer set, [
    void _,
  ]) {
    if (set.l == 0) {
      return STC(
        condition: set.condition,
        p: set.p,
        u: set.u,
        n: set.n,
        w: set.w,
        baseRegister: set.registerN,
        coprocessorSourceOrDestinationRegister: set.cpRegisterD,
        coprocessorNumber: set.cpNumber,
        unsigned8BitImmediateOffset: set.offset,
      );
    } else if (set.l == 1) {
      return LDC(
        condition: set.condition,
        p: set.p,
        u: set.u,
        n: set.n,
        w: set.w,
        baseRegister: set.registerN,
        coprocessorSourceOrDestinationRegister: set.cpRegisterD,
        coprocessorNumber: set.cpNumber,
        unsigned8BitImmediateOffset: set.offset,
      );
    } else {
      throw StateError('Unexpected L: ${set.l}');
    }
  }

  @override
  ArmInstruction visitCoprocessorDataOperation(
    CoprocessorDataOperation set, [
    void _,
  ]) {
    return CDP(
      condition: set.condition,
      coprocessorOpCode: set.cpOpCode,
      coprocessorOperandRegister1: set.cpOperandRegister1,
      coprocessorDestinationRegister: set.cpDestinationRegister,
      coprocessorNumber: set.cpNumber,
      coprocessorInformation: set.cpInformation,
      coprocessorOperandRegister2: set.cpOperandRegister2,
    );
  }

  @override
  ArmInstruction visitCoprocessorRegisterTransfer(
    CoprocessorRegisterTransfer set, [
    void _,
  ]) {
    if (set.l == 0) {
      return MCR(
        condition: set.condition,
        coprocessorOperationCode: set.cpOpCode,
        coprocessorDestinationRegister: set.cpRegisterN,
        sourceRegister: set.registerD,
        coprocessorNumber: set.cpNumber,
        coprocessorInformation: set.cpInformation,
        coprocessorOperandRegister: set.cpRegisterM,
      );
    } else if (set.l == 1) {
      return MRC(
        condition: set.condition,
        coprocessorOperationCode: set.cpOpCode,
        coprocessorSourceRegister: set.cpRegisterN,
        destinationRegister: set.registerD,
        coprocessorNumber: set.cpNumber,
        coprocessorInformation: set.cpInformation,
        coprocessorOperandRegister: set.cpRegisterM,
      );
    } else {
      throw StateError('Unexpected L: ${set.l}');
    }
  }

  @override
  ArmInstruction visitSoftwareInterrupt(
    SoftwareInterrupt set, [
    void _,
  ]) {
    return SWI(
      condition: set.condition,
      immediate24: set.comment,
    );
  }
}

abstract class ArmInstructionVisitor<R, C> {
  R visitB(
    B instruction, [
    C context,
  ]);

  R visitBL(
    BL instruction, [
    C context,
  ]);

  R visitBX(
    BX instruction, [
    C context,
  ]);

  R visitLDM(
    LDM instruction, [
    C context,
  ]);

  R visitLDR(
    LDR instruction, [
    C context,
  ]);

  R visitLDRB(
    LDRB instruction, [
    C context,
  ]);

  R visitLDRH(
    LDRH instruction, [
    C context,
  ]);

  R visitLDRSB(
    LDRSB instruction, [
    C context,
  ]);

  R visitLDRSH(
    LDRSH instruction, [
    C context,
  ]);

  R visitMOV(
    MOV instruction, [
    C context,
  ]);

  R visitMRS(
    MRS instruction, [
    C context,
  ]);

  R visitMSR(
    MSR instruction, [
    C context,
  ]);

  R visitMVN(
    MVN instruction, [
    C context,
  ]);

  R visitSTM(
    STM instruction, [
    C context,
  ]);

  R visitSTR(
    STR instruction, [
    C context,
  ]);

  R visitSTRB(
    STRB instruction, [
    C context,
  ]);

  R visitSTRH(
    STRH instruction, [
    C context,
  ]);

  R visitSWP(
    SWP instruction, [
    C context,
  ]);

  R visitSWPB(
    SWPB instruction, [
    C context,
  ]);

  R visitAND(
    AND instruction, [
    C context,
  ]);

  R visitBIC(
    BIC instruction, [
    C context,
  ]);

  R visitCMN(
    CMN instruction, [
    C context,
  ]);

  R visitCMP(
    CMP instruction, [
    C context,
  ]);

  R visitEOR(
    EOR instruction, [
    C context,
  ]);

  R visitORR(
    ORR instruction, [
    C context,
  ]);

  R visitTEQ(
    TEQ instruction, [
    C context,
  ]);

  R visitTST(
    TST instruction, [
    C context,
  ]);

  R visitADC(
    ADC instruction, [
    C context,
  ]);

  R visitADD(
    ADD instruction, [
    C context,
  ]);

  R visitMLA(
    MLA instruction, [
    C context,
  ]);

  R visitMUL(
    MUL instruction, [
    C context,
  ]);

  R visitRSB(
    RSB instruction, [
    C context,
  ]);

  R visitRSC(
    RSC instruction, [
    C context,
  ]);

  R visitSBC(
    SBC instruction, [
    C context,
  ]);

  R visitSUB(
    SUB instruction, [
    C context,
  ]);

  R visitSMLAL(
    SMLAL instruction, [
    C context,
  ]);

  R visitSMULL(
    SMULL instruction, [
    C context,
  ]);

  R visitUMLAL(
    UMLAL instruction, [
    C context,
  ]);

  R visitUMULL(
    UMULL instruction, [
    C context,
  ]);

  R visitSWI(
    SWI instruction, [
    C context,
  ]);

  R visitCDP(
    CDP instruction, [
    C context,
  ]);

  R visitLDC(
    LDC instruction, [
    C context,
  ]);

  R visitMCR(
    MCR instruction, [
    C context,
  ]);

  R visitMRC(
    MRC instruction, [
    C context,
  ]);

  R visitSTC(
    STC instruction, [
    C context,
  ]);
}
