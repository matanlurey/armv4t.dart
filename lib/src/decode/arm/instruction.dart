import 'package:armv4t/src/utils.dart';
import 'package:meta/meta.dart';

import 'format.dart';
import 'printer.dart';

part 'instruction/branch/b.dart';
part 'instruction/branch/bl.dart';
part 'instruction/branch/bx.dart';
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
  @override
  ArmInstruction visitDataProcessingOrPSRTransfer(
    DataProcessingOrPSRTransfer instruction, [
    void _,
  ]) {
    switch (instruction.opcode) {
      case 0x0:
        return AND(
          condition: instruction.condition,
          i: instruction.i,
          s: instruction.s,
          sourceRegister: instruction.registerN,
          destinationRegister: instruction.registerD,
          shifterOperand: instruction.operand2,
        );
      case 0x1:
        return EOR(
          condition: instruction.condition,
          i: instruction.i,
          s: instruction.s,
          sourceRegister: instruction.registerN,
          destinationRegister: instruction.registerD,
          shifterOperand: instruction.operand2,
        );
      case 0x2:
        return SUB(
          condition: instruction.condition,
          i: instruction.i,
          s: instruction.s,
          sourceRegister: instruction.registerN,
          destinationRegister: instruction.registerD,
          shifterOperand: instruction.operand2,
        );
      case 0x3:
        return RSB(
          condition: instruction.condition,
          i: instruction.i,
          s: instruction.s,
          sourceRegister: instruction.registerN,
          destinationRegister: instruction.registerD,
          shifterOperand: instruction.operand2,
        );
      case 0x4:
        return ADD(
          condition: instruction.condition,
          i: instruction.i,
          s: instruction.s,
          sourceRegister: instruction.registerN,
          destinationRegister: instruction.registerD,
          shifterOperand: instruction.operand2,
        );
      case 0x5:
        return ADC(
          condition: instruction.condition,
          i: instruction.i,
          s: instruction.s,
          sourceRegister: instruction.registerN,
          destinationRegister: instruction.registerD,
          shifterOperand: instruction.operand2,
        );
      case 0x6:
        return SBC(
          condition: instruction.condition,
          i: instruction.i,
          s: instruction.s,
          sourceRegister: instruction.registerN,
          destinationRegister: instruction.registerD,
          shifterOperand: instruction.operand2,
        );
      case 0x7:
        return RSC(
          condition: instruction.condition,
          i: instruction.i,
          s: instruction.s,
          sourceRegister: instruction.registerN,
          destinationRegister: instruction.registerD,
          shifterOperand: instruction.operand2,
        );
      case 0x8:
        return TST(
          condition: instruction.condition,
          i: instruction.i,
          sourceRegister: instruction.registerN,
          destinationRegister: instruction.registerD,
          shifterOperand: instruction.operand2,
        );
      case 0x9:
        return TEQ(
          condition: instruction.condition,
          i: instruction.i,
          sourceRegister: instruction.registerN,
          destinationRegister: instruction.registerD,
          shifterOperand: instruction.operand2,
        );
      case 0xA:
        return CMP(
          condition: instruction.condition,
          i: instruction.i,
          sourceRegister: instruction.registerN,
          destinationRegister: instruction.registerD,
          shifterOperand: instruction.operand2,
        );
      case 0xB:
        return CMN(
          condition: instruction.condition,
          i: instruction.i,
          sourceRegister: instruction.registerN,
          destinationRegister: instruction.registerD,
          shifterOperand: instruction.operand2,
        );
      case 0xC:
        return ORR(
          condition: instruction.condition,
          i: instruction.i,
          sourceRegister: instruction.registerN,
          destinationRegister: instruction.registerD,
          shifterOperand: instruction.operand2,
        );
      case 0xD:
        return MOV(
          condition: instruction.condition,
          i: instruction.i,
          s: instruction.s,
          destinationRegister: instruction.registerD,
          shifterOperand: instruction.operand2,
        );
      case 0xE:
        return BIC(
          condition: instruction.condition,
          i: instruction.i,
          s: instruction.s,
          sourceRegister: instruction.registerN,
          destinationRegister: instruction.registerD,
          shifterOperand: instruction.operand2,
        );
      case 0xF:
        return MVN(
          condition: instruction.condition,
          i: instruction.i,
          s: instruction.s,
          destinationRegister: instruction.registerD,
          shifterOperand: instruction.operand2,
        );
      default:
        throw StateError('Unexpected opcode: ${instruction.opcode}');
    }
  }

  @override
  ArmInstruction visitMultiplyAndMutiplyAccumulate(
    MultiplyAndMutiplyAccumulate instruction, [
    void _,
  ]) {
    throw UnimplementedError();
  }

  @override
  ArmInstruction visitMultiplyLongAndMutiplyAccumulateLong(
    MultiplyLongAndMutiplyAccumulateLong instruction, [
    void _,
  ]) {
    throw UnimplementedError();
  }

  @override
  ArmInstruction visitSingleDataSwap(
    SingleDataSwap instruction, [
    void _,
  ]) {
    throw UnimplementedError();
  }

  @override
  ArmInstruction visitBranchAndExchange(
    BranchAndExchange instruction, [
    void _,
  ]) {
    throw UnimplementedError();
  }

  @override
  ArmInstruction visitHalfWordAndSignedDataTransferRegisterOffset(
    HalfWordAndSignedDataTransferRegisterOffset instruction, [
    void _,
  ]) {
    throw UnimplementedError();
  }

  @override
  ArmInstruction visitHalfWordAndSignedDataTransferImmediateOffset(
    HalfWordAndSignedDataTransferImmediateOffset instruction, [
    void _,
  ]) {
    throw UnimplementedError();
  }

  @override
  ArmInstruction visitSingleDataTransfer(
    SingleDataTransfer instruction, [
    void _,
  ]) {
    throw UnimplementedError();
  }

  @override
  ArmInstruction visitUndefined(
    Undefined instruction, [
    void _,
  ]) {
    throw UnimplementedError();
  }

  @override
  ArmInstruction visitBlockDataTransfer(
    BlockDataTransfer instruction, [
    void _,
  ]) {
    throw UnimplementedError();
  }

  @override
  ArmInstruction visitBranch(
    Branch instruction, [
    void _,
  ]) {
    throw UnimplementedError();
  }

  @override
  ArmInstruction visitCoprocessorDataTransfer(
    CoprocessorDataTransfer instruction, [
    void _,
  ]) {
    throw UnimplementedError();
  }

  @override
  ArmInstruction visitCoprocessorDataOperation(
    CoprocessorDataOperation instruction, [
    void _,
  ]) {
    throw UnimplementedError();
  }

  @override
  ArmInstruction visitCoprocessorRegisterTransfer(
    CoprocessorRegisterTransfer instruction, [
    void _,
  ]) {
    throw UnimplementedError();
  }

  @override
  ArmInstruction visitSoftwareInterrupt(
    SoftwareInterrupt instruction, [
    void _,
  ]) {
    throw UnimplementedError();
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
}
