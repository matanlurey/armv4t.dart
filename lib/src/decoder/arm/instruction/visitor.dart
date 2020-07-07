part of '../instruction.dart';

/// An object that can be used to visit an [ArmInstruction] structure.
///
/// It is intended to be a super-type for classes that use a visitor pattern
/// primarily as a dispatch mechanism (and hence don't need to recursively visit
/// a whole structure).
abstract class ArmInstructionVisitor<R, C> {
  R visitADC(ADCArmInstruction i, [C context]);
  R visitADD(ADDArmInstruction i, [C context]);
  R visitCMN(CMNArmInstruction i, [C context]);
  R visitCMP(CMPArmInstruction i, [C context]);
  R visitRSB(RSBArmInstruction i, [C context]);
  R visitRSC(RSCArmInstruction i, [C context]);
  R visitSBC(SBCArmInstruction i, [C context]);
  R visitSUB(SUBArmInstruction i, [C context]);
  R visitAND(ANDArmInstruction i, [C context]);
  R visitBIC(BICArmInstruction i, [C context]);
  R visitEOR(EORArmInstruction i, [C context]);
  R visitMOV(MOVArmInstruction i, [C context]);
  R visitMVN(MVNArmInstruction i, [C context]);
  R visitORR(ORRArmInstruction i, [C context]);
  R visitTEQ(TEQArmInstruction i, [C context]);
  R visitTST(TSTArmInstruction i, [C context]);
  R visitLDM(LDMArmInstruction i, [C context]);
  R visitLDR(LDRArmInstruction i, [C context]);
  R visitLDRH(LDRHArmInstruction i, [C context]);
  R visitLDRSB(LDRSBArmInstruction i, [C context]);
  R visitLDRSH(LDRSHArmInstruction i, [C context]);
  R visitSTM(STMArmInstruction i, [C context]);
  R visitSTR(STRArmInstruction i, [C context]);
  R visitSTRH(STRHArmInstruction i, [C context]);
  R visitSWP(SWPArmInstruction i, [C context]);
  R visitMLA(MLAArmInstruction i, [C context]);
  R visitMUL(MULArmInstruction i, [C context]);
  R visitSMLAL(SMLALArmInstruction i, [C context]);
  R visitSMULL(SMULLArmInstruction i, [C context]);
  R visitUMLAL(UMLALArmInstruction i, [C context]);
  R visitUMULL(UMULLArmInstruction i, [C context]);
  R visitB(BArmInstruction i, [C context]);
  R visitBL(BLArmInstruction i, [C context]);
  R visitBX(BXArmInstruction i, [C context]);
  R visitMRS(MRSArmInstruction i, [C context]);
  R visitMSR(MSRArmInstruction i, [C context]);
  R visitSWI(SWIArmInstruction i, [C context]);
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

  R visitDataProcessingVoidReturn(DataProcessingArmInstruction i, [C context]) {
    return visitDataProcessing(i, context);
  }

  @override
  R visitADC(ADCArmInstruction i, [C context]) =>
      visitDataProcessing(i, context);

  @override
  R visitADD(ADDArmInstruction i, [C context]) =>
      visitDataProcessing(i, context);

  @override
  R visitCMN(CMNArmInstruction i, [C context]) =>
      visitDataProcessingVoidReturn(i, context);

  @override
  R visitCMP(CMPArmInstruction i, [C context]) =>
      visitDataProcessingVoidReturn(i, context);

  @override
  R visitRSB(RSBArmInstruction i, [C context]) =>
      visitDataProcessing(i, context);

  @override
  R visitRSC(RSCArmInstruction i, [C context]) =>
      visitDataProcessing(i, context);

  @override
  R visitSBC(SBCArmInstruction i, [C context]) =>
      visitDataProcessing(i, context);

  @override
  R visitSUB(SUBArmInstruction i, [C context]) =>
      visitDataProcessing(i, context);

  @override
  R visitAND(ANDArmInstruction i, [C context]) =>
      visitDataProcessing(i, context);

  @override
  R visitBIC(BICArmInstruction i, [C context]) =>
      visitDataProcessing(i, context);

  @override
  R visitEOR(EORArmInstruction i, [C context]) =>
      visitDataProcessing(i, context);

  @override
  R visitMOV(MOVArmInstruction i, [C context]) =>
      visitDataProcessing(i, context);

  @override
  R visitMVN(MVNArmInstruction i, [C context]) =>
      visitDataProcessing(i, context);

  @override
  R visitORR(ORRArmInstruction i, [C context]) =>
      visitDataProcessing(i, context);

  @override
  R visitTEQ(TEQArmInstruction i, [C context]) =>
      visitDataProcessingVoidReturn(i, context);

  @override
  R visitTST(TSTArmInstruction i, [C context]) =>
      visitDataProcessingVoidReturn(i, context);

  R visitBlockDataTransfer(BlockDataTransferArmInstruction i, [C context]) {
    return visitInstruction(i, context);
  }

  @override
  R visitSTM(STMArmInstruction i, [C context]) =>
      visitBlockDataTransfer(i, context);

  @override
  R visitLDM(LDMArmInstruction i, [C context]) =>
      visitBlockDataTransfer(i, context);

  R visitSingleDataTransfer(SingleDataTransferArmInstruction i, [C context]) {
    return visitInstruction(i, context);
  }

  @override
  R visitLDR(LDRArmInstruction i, [C context]) =>
      visitSingleDataTransfer(i, context);

  @override
  R visitSTR(STRArmInstruction i, [C context]) =>
      visitSingleDataTransfer(i, context);

  R visitHalfwordDataTransfer(
    HalfwordDataTransferArmInstruction i, [
    C context,
  ]) {
    return visitInstruction(i, context);
  }

  @override
  R visitLDRH(LDRHArmInstruction i, [C context]) =>
      visitHalfwordDataTransfer(i, context);

  @override
  R visitLDRSB(LDRSBArmInstruction i, [C context]) =>
      visitHalfwordDataTransfer(i, context);

  @override
  R visitLDRSH(LDRSHArmInstruction i, [C context]) =>
      visitHalfwordDataTransfer(i, context);

  @override
  R visitSTRH(STRHArmInstruction i, [C context]) =>
      visitHalfwordDataTransfer(i, context);

  @override
  R visitSWP(SWPArmInstruction i, [C context]) => visitInstruction(i, context);

  R visitMultiply(
    MultiplyArmInstruction i, [
    C context,
  ]) {
    return visitInstruction(i, context);
  }

  @override
  R visitMLA(MLAArmInstruction i, [C context]) => visitMultiply(i);

  @override
  R visitMUL(MULArmInstruction i, [C context]) => visitMultiply(i);

  R visitMultiplyLong(
    MultiplyLongArmInstruction i, [
    C context,
  ]) {
    return visitInstruction(i, context);
  }

  @override
  R visitSMLAL(SMLALArmInstruction i, [C context]) => visitMultiplyLong(i);

  @override
  R visitSMULL(SMULLArmInstruction i, [C context]) => visitMultiplyLong(i);

  @override
  R visitUMLAL(UMLALArmInstruction i, [C context]) => visitMultiplyLong(i);

  @override
  R visitUMULL(UMULLArmInstruction i, [C context]) => visitMultiplyLong(i);

  @override
  R visitB(BArmInstruction i, [C context]) => visitInstruction(i, context);

  @override
  R visitBL(BLArmInstruction i, [C context]) => visitInstruction(i, context);

  @override
  R visitBX(BXArmInstruction i, [C context]) => visitInstruction(i, context);

  R visitPsrTransfer(PsrTransferArmInstruction i, [C context]) {
    return visitInstruction(i, context);
  }

  @override
  R visitMRS(MRSArmInstruction i, [C context]) => visitPsrTransfer(i, context);

  @override
  R visitMSR(MSRArmInstruction i, [C context]) => visitPsrTransfer(i, context);

  @override
  R visitSWI(SWIArmInstruction i, [C context]) => visitInstruction(i, context);
}
