part of '../instruction.dart';

/// An object that can be used to visit an [ArmInstruction] structure.
///
/// It is intended to be a super-type for classes that use a visitor pattern
/// primarily as a dispatch mechanism (and hence don't need to recursively visit
/// a whole structure).
abstract class ArmInstructionVisitor<R, C> {
  R visitADC(ADC$Arm i, [C context]);
  R visitADD(ADD$Arm i, [C context]);
  R visitCMN(CMN$Arm i, [C context]);
  R visitCMP(CMP$Arm i, [C context]);
  R visitRSB(RSB$Arm i, [C context]);
  R visitRSC(RSC$Arm i, [C context]);
  R visitSBC(SBC$Arm i, [C context]);
  R visitSUB(SUB$Arm i, [C context]);
  R visitAND(AND$Arm i, [C context]);
  R visitBIC(BIC$Arm i, [C context]);
  R visitEOR(EOR$Arm i, [C context]);
  R visitMOV(MOV$Arm i, [C context]);
  R visitMVN(MVN$Arm i, [C context]);
  R visitORR(ORR$Arm i, [C context]);
  R visitTEQ(TEQ$Arm i, [C context]);
  R visitTST(TST$Arm i, [C context]);
  R visitLDM(LDM$Arm i, [C context]);
  R visitLDR(LDR$Arm i, [C context]);
  R visitLDRH(LDRH$Arm i, [C context]);
  R visitLDRSB(LDRSB$Arm i, [C context]);
  R visitLDRSH(LDRSH$Arm i, [C context]);
  R visitSTM(STM$Arm i, [C context]);
  R visitSTR(STR$Arm i, [C context]);
  R visitSTRH(STRH$Arm i, [C context]);
  R visitSWP(SWP$Arm i, [C context]);
  R visitMLA(MLA$Arm i, [C context]);
  R visitMUL(MUL$Arm i, [C context]);
  R visitSMLAL(SMLAL$Arm i, [C context]);
  R visitSMULL(SMULL$Arm i, [C context]);
  R visitUMLAL(UMLAL$Arm i, [C context]);
  R visitUMULL(UMULL$Arm i, [C context]);
  R visitB(B$Arm i, [C context]);
  R visitBL(BL$Arm i, [C context]);
  R visitBX(BX$Arm i, [C context]);
  R visitMRS(MRS$Arm i, [C context]);
  R visitMSR(MSR$Arm i, [C context]);
  R visitSWI(SWI$Arm i, [C context]);
}

/// An object that visits methods based on the common super types.
///
/// For example, [visitADC] will call [visitDataProcessing].
///
/// Subclasses that override a visit method must either invoke the overriden
/// visit method or explicitly invoke the more general visit method.
///
/// > WARNING: This class should **extended** not implemented.
class Super$ArmVisitor<R, C> implements ArmInstructionVisitor<R, C> {
  const Super$ArmVisitor();

  R visitInstruction(ArmInstruction i, [C context]) {
    return null;
  }

  R visitDataProcessing(DataProcessing$Arm i, [C context]) {
    return visitInstruction(i, context);
  }

  R visitDataProcessingVoidReturn(DataProcessing$Arm i, [C context]) {
    return visitDataProcessing(i, context);
  }

  @override
  R visitADC(ADC$Arm i, [C context]) => visitDataProcessing(i, context);

  @override
  R visitADD(ADD$Arm i, [C context]) => visitDataProcessing(i, context);

  @override
  R visitCMN(CMN$Arm i, [C context]) =>
      visitDataProcessingVoidReturn(i, context);

  @override
  R visitCMP(CMP$Arm i, [C context]) =>
      visitDataProcessingVoidReturn(i, context);

  @override
  R visitRSB(RSB$Arm i, [C context]) => visitDataProcessing(i, context);

  @override
  R visitRSC(RSC$Arm i, [C context]) => visitDataProcessing(i, context);

  @override
  R visitSBC(SBC$Arm i, [C context]) => visitDataProcessing(i, context);

  @override
  R visitSUB(SUB$Arm i, [C context]) => visitDataProcessing(i, context);

  @override
  R visitAND(AND$Arm i, [C context]) => visitDataProcessing(i, context);

  @override
  R visitBIC(BIC$Arm i, [C context]) => visitDataProcessing(i, context);

  @override
  R visitEOR(EOR$Arm i, [C context]) => visitDataProcessing(i, context);

  @override
  R visitMOV(MOV$Arm i, [C context]) => visitDataProcessing(i, context);

  @override
  R visitMVN(MVN$Arm i, [C context]) => visitDataProcessing(i, context);

  @override
  R visitORR(ORR$Arm i, [C context]) => visitDataProcessing(i, context);

  @override
  R visitTEQ(TEQ$Arm i, [C context]) =>
      visitDataProcessingVoidReturn(i, context);

  @override
  R visitTST(TST$Arm i, [C context]) =>
      visitDataProcessingVoidReturn(i, context);

  R visitBlockDataTransfer(BlockDataTransfer$Arm i, [C context]) {
    return visitInstruction(i, context);
  }

  @override
  R visitSTM(STM$Arm i, [C context]) => visitBlockDataTransfer(i, context);

  @override
  R visitLDM(LDM$Arm i, [C context]) => visitBlockDataTransfer(i, context);

  R visitSingleDataTransfer(SingleDataTransfer$Arm i, [C context]) {
    return visitInstruction(i, context);
  }

  @override
  R visitLDR(LDR$Arm i, [C context]) => visitSingleDataTransfer(i, context);

  @override
  R visitSTR(STR$Arm i, [C context]) => visitSingleDataTransfer(i, context);

  R visitHalfwordDataTransfer(
    HalfwordDataTransfer$Arm i, [
    C context,
  ]) {
    return visitInstruction(i, context);
  }

  @override
  R visitLDRH(LDRH$Arm i, [C context]) => visitHalfwordDataTransfer(i, context);

  @override
  R visitLDRSB(LDRSB$Arm i, [C context]) =>
      visitHalfwordDataTransfer(i, context);

  @override
  R visitLDRSH(LDRSH$Arm i, [C context]) =>
      visitHalfwordDataTransfer(i, context);

  @override
  R visitSTRH(STRH$Arm i, [C context]) => visitHalfwordDataTransfer(i, context);

  @override
  R visitSWP(SWP$Arm i, [C context]) => visitInstruction(i, context);

  R visitMultiply(
    Multiply$Arm i, [
    C context,
  ]) {
    return visitInstruction(i, context);
  }

  @override
  R visitMLA(MLA$Arm i, [C context]) => visitMultiply(i);

  @override
  R visitMUL(MUL$Arm i, [C context]) => visitMultiply(i);

  R visitMultiplyLong(
    MultiplyLong$Arm i, [
    C context,
  ]) {
    return visitInstruction(i, context);
  }

  @override
  R visitSMLAL(SMLAL$Arm i, [C context]) => visitMultiplyLong(i);

  @override
  R visitSMULL(SMULL$Arm i, [C context]) => visitMultiplyLong(i);

  @override
  R visitUMLAL(UMLAL$Arm i, [C context]) => visitMultiplyLong(i);

  @override
  R visitUMULL(UMULL$Arm i, [C context]) => visitMultiplyLong(i);

  @override
  R visitB(B$Arm i, [C context]) => visitInstruction(i, context);

  @override
  R visitBL(BL$Arm i, [C context]) => visitInstruction(i, context);

  @override
  R visitBX(BX$Arm i, [C context]) => visitInstruction(i, context);

  R visitPsrTransfer(PsrTransfer$Arm i, [C context]) {
    return visitInstruction(i, context);
  }

  @override
  R visitMRS(MRS$Arm i, [C context]) => visitPsrTransfer(i, context);

  @override
  R visitMSR(MSR$Arm i, [C context]) => visitPsrTransfer(i, context);

  @override
  R visitSWI(SWI$Arm i, [C context]) => visitInstruction(i, context);
}
