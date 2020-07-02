part of '../instruction.dart';

abstract class ArmInstructionVisitor<R, C> {
  /// Invoked by [ADC.accept].
  R visitADC(ADC i, [C context]);

  /// Invoked by [ADD.accept].
  R visitADD(ADD i, [C context]);

  /// Invoked by [CMN.accept].
  R visitCMN(CMN i, [C context]);

  /// Invoked by [CMP.accept].
  R visitCMP(CMP i, [C context]);

  /// Invoked by [RSB.accept].
  R visitRSB(RSB i, [C context]);

  /// Invoked by [RSC.accept].
  R visitRSC(RSC i, [C context]);

  /// Invoked by [SBC.accept].
  R visitSBC(SBC i, [C context]);

  /// Invoked by [SUB.accept].
  R visitSUB(SUB i, [C context]);

  /// Invoked by [AND.accept].
  R visitAND(AND i, [C context]);

  /// Invoked by [BIC.accept].
  R visitBIC(BIC i, [C context]);

  /// Invoked by [EOR.accept].
  R visitEOR(EOR i, [C context]);

  /// Invoked by [MOV.accept].
  R visitMOV(MOV i, [C context]);

  /// Invoked by [MVN.accept].
  R visitMVN(MVN i, [C context]);

  /// Invoked by [ORR.accept].
  R visitORR(ORR i, [C context]);

  /// Invoked by [TEQ.accept].
  R visitTEQ(TEQ i, [C context]);

  /// Invoked by [TST.accept].
  R visitTST(TST i, [C context]);

  /// Invoked by [LDM.accept].
  R visitLDM(LDM i, [C context]);

  /// Invoked by [LDR.accept].
  R visitLDR(LDR i, [C context]);

  /// Invoked by [LDRH.accept].
  R visitLDRH(LDRH i, [C context]);

  /// Invoked by [LDRSB.accept].
  R visitLDRSB(LDRSB i, [C context]);

  /// Invoked by [LDRSH.accept].
  R visitLDRSH(LDRSH i, [C context]);

  /// Invoked by [STM.accept].
  R visitSTM(STM i, [C context]);

  /// Invoked by [STR.accept].
  R visitSTR(STR i, [C context]);

  /// Invoked by [STRH.accept].
  R visitSTRH(STRH i, [C context]);

  /// Invoked by [SWP.accept].
  R visitSWP(SWP i, [C context]);

  /// Invoked by [MLA.accept].
  R visitMLA(MLA i, [C context]);

  /// Invoked by [MUL.accept].
  R visitMUL(MUL i, [C context]);

  /// Invoked by [SMLAL.accept].
  R visitSMLAL(SMLAL i, [C context]);

  /// Invoked by [SMULL.accept].
  R visitSMULL(SMULL i, [C context]);

  /// Invoked by [UMLAL.accept].
  R visitUMLAL(UMLAL i, [C context]);

  /// Invoked by [UMULL.accept].
  R visitUMULL(UMULL i, [C context]);

  /// Invoked by [B.accept].
  R visitB(B i, [C context]);

  /// Invoked by [BL.accept].
  R visitBL(BL i, [C context]);

  /// Invoked by [BX.accept].
  R visitBX(BX i, [C context]);

  /// Invoked by [MRS.accept].
  R visitMRS(MRS i, [C context]);

  /// Invoked by [MSR.accept].
  R visitMSR(MSR i, [C context]);

  /// Invoked by [SWI.accept].
  R visitSWI(SWI i, [C context]);
}
