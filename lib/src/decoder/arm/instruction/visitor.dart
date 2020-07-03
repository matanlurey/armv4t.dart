part of '../instruction.dart';

/// An object that can be used to visit an [ArmInstruction] structure.
///
/// It is intended to be a super-type for classes that use a visitor pattern
/// primarily as a dispatch mechanism (and hence don't need to recursively visit
/// a whole structure).
abstract class ArmInstructionVisitor<R, C> {
  R visitADC(ADC i, [C context]);
  R visitADD(ADD i, [C context]);
  R visitCMN(CMN i, [C context]);
  R visitCMP(CMP i, [C context]);
  R visitRSB(RSB i, [C context]);
  R visitRSC(RSC i, [C context]);
  R visitSBC(SBC i, [C context]);
  R visitSUB(SUB i, [C context]);
  R visitAND(AND i, [C context]);
  R visitBIC(BIC i, [C context]);
  R visitEOR(EOR i, [C context]);
  R visitMOV(MOV i, [C context]);
  R visitMVN(MVN i, [C context]);
  R visitORR(ORR i, [C context]);
  R visitTEQ(TEQ i, [C context]);
  R visitTST(TST i, [C context]);
  R visitLDM(LDM i, [C context]);
  R visitLDR(LDR i, [C context]);
  R visitLDRH(LDRH i, [C context]);
  R visitLDRSB(LDRSB i, [C context]);
  R visitLDRSH(LDRSH i, [C context]);
  R visitSTM(STM i, [C context]);
  R visitSTR(STR i, [C context]);
  R visitSTRH(STRH i, [C context]);
  R visitSWP(SWP i, [C context]);
  R visitMLA(MLA i, [C context]);
  R visitMUL(MUL i, [C context]);
  R visitSMLAL(SMLAL i, [C context]);
  R visitSMULL(SMULL i, [C context]);
  R visitUMLAL(UMLAL i, [C context]);
  R visitUMULL(UMULL i, [C context]);
  R visitB(B i, [C context]);
  R visitBL(BL i, [C context]);
  R visitBX(BX i, [C context]);
  R visitMRS(MRS i, [C context]);
  R visitMSR(MSR i, [C context]);
  R visitSWI(SWI i, [C context]);
}

/// An object that visits methods based on the common super types.
///
/// For example, [visitADC] will call [visitDataProcessing].
///
/// Subclasses that override a visit method must either invoke the overriden
/// visit method or explicitly invoke the more general visit method.
///
/// > WARNING: This class should **extended** not implemented.
class SuperArmInstructionVisitor<R, C> implements ArmInstructionVisitor<R, C> {
  const SuperArmInstructionVisitor();

  R visitInstruction(ArmInstruction i, [C context]) {
    return null;
  }

  R visitDataProcessing(DataProcessingArmInstruction i, [C context]) {
    return visitInstruction(i, context);
  }

  @override
  R visitADC(ADC i, [C context]) => visitDataProcessing(i, context);

  @override
  R visitADD(ADD i, [C context]) => visitDataProcessing(i, context);

  @override
  R visitCMN(CMN i, [C context]) => visitDataProcessing(i, context);

  @override
  R visitCMP(CMP i, [C context]) => visitDataProcessing(i, context);

  @override
  R visitRSB(RSB i, [C context]) => visitDataProcessing(i, context);

  @override
  R visitRSC(RSC i, [C context]) => visitDataProcessing(i, context);

  @override
  R visitSBC(SBC i, [C context]) => visitDataProcessing(i, context);

  @override
  R visitSUB(SUB i, [C context]) => visitDataProcessing(i, context);

  @override
  R visitAND(AND i, [C context]) => visitDataProcessing(i, context);

  @override
  R visitBIC(BIC i, [C context]) => visitDataProcessing(i, context);

  @override
  R visitEOR(EOR i, [C context]) => visitDataProcessing(i, context);

  @override
  R visitMOV(MOV i, [C context]) => visitDataProcessing(i, context);

  @override
  R visitMVN(MVN i, [C context]) => visitDataProcessing(i, context);

  @override
  R visitORR(ORR i, [C context]) => visitDataProcessing(i, context);

  @override
  R visitTEQ(TEQ i, [C context]) => visitDataProcessing(i, context);

  @override
  R visitTST(TST i, [C context]) => visitDataProcessing(i, context);

  R visitBlockDataTransfer(BlockDataTransferArmInstruction i, [C context]) {
    return visitInstruction(i, context);
  }

  @override
  R visitSTM(STM i, [C context]) => visitBlockDataTransfer(i, context);

  @override
  R visitLDM(LDM i, [C context]) => visitBlockDataTransfer(i, context);

  R visitSingleDataTransfer(SingleDataTransferArmInstruction i, [C context]) {
    return visitInstruction(i, context);
  }

  @override
  R visitLDR(LDR i, [C context]) => visitSingleDataTransfer(i, context);

  @override
  R visitSTR(STR i, [C context]) => visitSingleDataTransfer(i, context);

  R visitHalfwordDataTransfer(
    HalfwordDataTransferArmInstruction i, [
    C context,
  ]) {
    return visitInstruction(i, context);
  }

  @override
  R visitLDRH(LDRH i, [C context]) => visitHalfwordDataTransfer(i, context);

  @override
  R visitLDRSB(LDRSB i, [C context]) => visitHalfwordDataTransfer(i, context);

  @override
  R visitLDRSH(LDRSH i, [C context]) => visitHalfwordDataTransfer(i, context);

  @override
  R visitSTRH(STRH i, [C context]) => visitHalfwordDataTransfer(i, context);

  @override
  R visitSWP(SWP i, [C context]) => visitInstruction(i, context);

  R visitMultiplyAndMultiplyLong(
    MultiplyAndMultiplyLongArmInstruction i, [
    C context,
  ]) {
    return visitInstruction(i, context);
  }

  @override
  R visitMLA(MLA i, [C context]) => visitMultiplyAndMultiplyLong(i);

  @override
  R visitMUL(MUL i, [C context]) => visitMultiplyAndMultiplyLong(i);

  @override
  R visitSMLAL(SMLAL i, [C context]) => visitMultiplyAndMultiplyLong(i);

  @override
  R visitSMULL(SMULL i, [C context]) => visitMultiplyAndMultiplyLong(i);

  @override
  R visitUMLAL(UMLAL i, [C context]) => visitMultiplyAndMultiplyLong(i);

  @override
  R visitUMULL(UMULL i, [C context]) => visitMultiplyAndMultiplyLong(i);

  @override
  R visitB(B i, [C context]) => visitInstruction(i, context);

  @override
  R visitBL(BL i, [C context]) => visitInstruction(i, context);

  @override
  R visitBX(BX i, [C context]) => visitInstruction(i, context);

  R visitPsrTransfer(PsrTransferArmInstruction i, [C context]) {
    return visitInstruction(i, context);
  }

  @override
  R visitMRS(MRS i, [C context]) => visitPsrTransfer(i, context);

  @override
  R visitMSR(MSR i, [C context]) => visitPsrTransfer(i, context);

  @override
  R visitSWI(SWI i, [C context]) => visitInstruction(i, context);
}
