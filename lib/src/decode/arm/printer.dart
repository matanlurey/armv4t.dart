import 'package:armv4t/src/decode/arm/condition.dart';
import 'package:binary/binary.dart';

import 'instruction.dart';

class ArmConditionPrinter implements ArmConditionVisitor<String, void> {
  const ArmConditionPrinter();

  @override
  String visitEQ([void _]) => 'EQ';

  @override
  String visitNE([void _]) => 'NE';

  @override
  String visitCS$HS([void _]) => 'CS';

  @override
  String visitCC$LO([void _]) => 'CC';

  @override
  String visitMI([void _]) => 'MI';

  @override
  String visitPL([void _]) => 'PL';

  @override
  String visitVS([void _]) => 'VS';

  @override
  String visitVC([void _]) => 'VC';

  @override
  String visitHI([void _]) => 'HI';

  @override
  String visitLS([void _]) => 'LS';

  @override
  String visitGE([void _]) => 'GE';

  @override
  String visitLT([void _]) => 'LT';

  @override
  String visitGT([void _]) => 'GT';

  @override
  String visitLE([void _]) => 'LE';

  @override
  String visitAL([void _]) => '';

  @override
  String visitNV([void _]) => 'NV';
}

class ArmInstructionPrinter implements ArmInstructionVisitor<String, void> {
  final ArmConditionDecoder _conditionDecoder;
  final ArmConditionPrinter _conditionPrinter;

  const ArmInstructionPrinter([
    this._conditionDecoder = const ArmConditionDecoder(),
    this._conditionPrinter = const ArmConditionPrinter(),
  ]);

  String _cond(ArmInstruction i) {
    return _conditionDecoder.decodeBits(i.condition).accept(_conditionPrinter);
  }

  String _s(int sBit) => sBit == 1 ? 'S' : '';

  String _i(int iBit, int operand) => iBit == 1 ? '#${operand}' : 'R${operand}';

  String _fieldMask(int bits) {
    if (bits == 0) return '';
    final result = StringBuffer('_');
    if (bits.getBit(3) == 1) {
      result.write('C');
    }
    if (bits.getBit(2) == 1) {
      result.write('X');
    }
    if (bits.getBit(1) == 1) {
      result.write('S');
    }
    if (bits.getBit(0) == 1) {
      result.write('F');
    }
    return result.toString();
  }

  @override
  String visitB(
    B i, [
    void _,
  ]) =>
      'B${_cond(i)} '
      '${i.targetAddress}';

  @override
  String visitBL(
    BL i, [
    void _,
  ]) =>
      'BL${_cond(i)} '
      '${i.targetAddress}';

  @override
  String visitBX(
    BX i, [
    void _,
  ]) =>
      'BX${_cond(i)} '
      'R${i.targetAddress}';

  @override
  String visitLDM(
    LDM i, [
    void _,
  ]) =>
      throw UnimplementedError();

  @override
  String visitLDR(
    LDR i, [
    void _,
  ]) =>
      'LDR${_cond(i)} '
      'R${i.destinationRegister}, '
      '[${i.addressingMode}]';

  @override
  String visitLDRB(
    LDRB i, [
    void _,
  ]) =>
      'LDRB${_cond(i)} '
      'R${i.destinationRegister}, '
      '[${i.addressingMode}]';

  @override
  String visitLDRH(
    LDRH i, [
    void _,
  ]) =>
      'LDRH${_cond(i)} '
      'R${i.destinationRegister}, '
      '[${i.addressingMode}]';

  @override
  String visitLDRSB(
    LDRSB i, [
    void _,
  ]) =>
      throw UnimplementedError();

  @override
  String visitLDRSH(
    LDRSH i, [
    void _,
  ]) =>
      throw UnimplementedError();

  @override
  String visitMOV(
    MOV i, [
    void _,
  ]) =>
      'MOV${_cond(i)}${_s(i.s)} '
      'R${i.destinationRegister}, '
      '${_i(i.i, i.shifterOperand)}';

  @override
  String visitMRS(
    MRS i, [
    void _,
  ]) =>
      'MRS${_cond(i)} '
      'R${i.destinationRegister}, '
      '${i.sourcePSR == 0 ? 'CPSR' : 'SPSR'}';

  @override
  String visitMSR(
    MSR i, [
    void _,
  ]) =>
      'MSR${_cond(i)} '
      '${i.destinationPSR == 0 ? 'CPSR' : 'SPSR'}${_fieldMask(i.fieldMask)}, '
      '${_i(i.immediateOperand, i.sourceOperand)}';

  @override
  String visitMVN(
    MVN i, [
    void _,
  ]) =>
      'MVN${_cond(i)}${_s(i.s)} '
      'R${i.destinationRegister}, '
      '${_i(i.i, i.shifterOperand)}';

  @override
  String visitSTM(
    STM i, [
    void _,
  ]) =>
      throw UnimplementedError();

  @override
  String visitSTR(
    STR i, [
    void _,
  ]) =>
      throw UnimplementedError();

  @override
  String visitSTRB(
    STRB i, [
    void _,
  ]) =>
      throw UnimplementedError();

  @override
  String visitSTRH(
    STRH i, [
    void _,
  ]) =>
      throw UnimplementedError();

  @override
  String visitSWP(
    SWP i, [
    void _,
  ]) =>
      'SWP${_cond(i)}, '
      'R${i.destinationRegister}, '
      'R${i.sourceRegister1}, '
      '[R${i.destinationRegister}]';

  @override
  String visitSWPB(
    SWPB i, [
    void _,
  ]) =>
      'SWPB${_cond(i)}, '
      'R${i.destinationRegister}, '
      'R${i.sourceRegister1}, '
      '[R${i.destinationRegister}]';

  @override
  String visitAND(
    AND i, [
    void _,
  ]) =>
      'AND${_cond(i)}${_s(i.s)} '
      'R${i.destinationRegister}, '
      'R${i.sourceRegister}, '
      '${_i(i.i, i.shifterOperand)}';

  @override
  String visitBIC(
    BIC i, [
    void _,
  ]) =>
      'BIC${_cond(i)}${_s(i.s)} '
      'R${i.destinationRegister}, '
      'R${i.sourceRegister}, '
      '${_i(i.i, i.shifterOperand)}';

  @override
  String visitCMN(
    CMN i, [
    void _,
  ]) =>
      'CMN${_cond(i)} '
      'R${i.destinationRegister}, '
      'R${i.sourceRegister}, '
      '${_i(i.i, i.shifterOperand)}';

  @override
  String visitCMP(
    CMP i, [
    void _,
  ]) =>
      'CMP${_cond(i)} '
      'R${i.destinationRegister}, '
      'R${i.sourceRegister}, '
      '${_i(i.i, i.shifterOperand)}';

  @override
  String visitEOR(
    EOR i, [
    void _,
  ]) =>
      'EOR${_cond(i)}${_s(i.s)} '
      'R${i.destinationRegister}, '
      'R${i.sourceRegister}, '
      '${_i(i.i, i.shifterOperand)}';

  @override
  String visitORR(
    ORR i, [
    void _,
  ]) =>
      'ORR${_cond(i)} '
      'R${i.destinationRegister}, '
      'R${i.sourceRegister}, '
      '${_i(i.i, i.shifterOperand)}';

  @override
  String visitTEQ(
    TEQ i, [
    void _,
  ]) =>
      'TEQ${_cond(i)} '
      'R${i.destinationRegister}, '
      'R${i.sourceRegister}, '
      '${_i(i.i, i.shifterOperand)}';

  @override
  String visitTST(
    TST i, [
    void _,
  ]) =>
      'TST${_cond(i)} '
      'R${i.destinationRegister}, '
      'R${i.sourceRegister}, '
      '${_i(i.i, i.shifterOperand)}';

  @override
  String visitADC(
    ADC i, [
    void _,
  ]) =>
      'ADC${_cond(i)}${_s(i.s)} '
      'R${i.destinationRegister}, '
      'R${i.sourceRegister}, '
      '${_i(i.i, i.shifterOperand)}';

  @override
  String visitADD(
    ADD i, [
    void _,
  ]) =>
      'ADD${_cond(i)}${_s(i.s)} '
      'R${i.destinationRegister}, '
      'R${i.sourceRegister}, '
      '${_i(i.i, i.shifterOperand)}';

  @override
  String visitMLA(
    MLA i, [
    void _,
  ]) =>
      'MLA${_cond(i)}${_s(i.s)} '
      'R${i.destinationRegister}, '
      'R${i.sourceRegister}, '
      'R${i.operandRegister1}, '
      'R${i.operandRegister2}';

  @override
  String visitMUL(
    MUL i, [
    void _,
  ]) =>
      'MUL${_cond(i)}${_s(i.s)} '
      'R${i.destinationRegister}, '
      'R${i.operandRegister}, '
      'R${i.sourceRegister}';

  @override
  String visitRSB(
    RSB i, [
    void _,
  ]) =>
      'RSB${_cond(i)}${_s(i.s)} '
      'R${i.destinationRegister}, '
      'R${i.sourceRegister}, '
      '${_i(i.i, i.shifterOperand)}';

  @override
  String visitRSC(
    RSC i, [
    void _,
  ]) =>
      'RSC${_cond(i)}${_s(i.s)} '
      'R${i.destinationRegister}, '
      'R${i.sourceRegister}, '
      '${_i(i.i, i.shifterOperand)}';

  @override
  String visitSBC(
    SBC i, [
    void _,
  ]) =>
      'SBC${_cond(i)}${_s(i.s)} '
      'R${i.destinationRegister}, '
      'R${i.sourceRegister}, '
      '${_i(i.i, i.shifterOperand)}';

  @override
  String visitSUB(
    SUB i, [
    void _,
  ]) =>
      'SUB${_cond(i)}${_s(i.s)} '
      'R${i.destinationRegister}, '
      'R${i.sourceRegister}, '
      '${_i(i.i, i.shifterOperand)}';

  @override
  String visitSMLAL(
    SMLAL i, [
    void _,
  ]) =>
      'SMLAL${_cond(i)}${_s(i.s)} '
      'R${i.destinationRegisterLSW}, '
      'R${i.destinationRegisterMSW}, '
      'R${i.sourceRegister}, '
      'R${i.operandRegister}';

  @override
  String visitSMULL(
    SMULL i, [
    void _,
  ]) =>
      'SMULL${_cond(i)}${_s(i.s)} '
      'R${i.destinationRegisterLSW}, '
      'R${i.destinationRegisterMSW}, '
      'R${i.sourceRegister}, '
      'R${i.operandRegister}';

  @override
  String visitUMLAL(
    UMLAL i, [
    void _,
  ]) =>
      'UMLAL${_cond(i)}${_s(i.s)} '
      'R${i.destinationRegisterLSW}, '
      'R${i.destinationRegisterMSW}, '
      'R${i.sourceRegister}, '
      'R${i.operandRegister}';

  @override
  String visitUMULL(
    UMULL i, [
    void _,
  ]) =>
      'UMULL${_cond(i)}${_s(i.s)} '
      'R${i.destinationRegisterLSW}, '
      'R${i.destinationRegisterMSW}, '
      'R${i.sourceRegister}, '
      'R${i.operandRegister}';

  @override
  String visitSWI(
    SWI i, [
    void _,
  ]) =>
      'SWI${_cond(i)} #${i.immediate24}';

  @override
  String visitCDP(
    CDP i, [
    void _,
  ]) =>
      'CDP${_cond(i)} '
      'P#${i.coprocessorNumber}, '
      '${i.coprocessorOpCode}, '
      'C${i.coprocessorDestinationRegister}, '
      'C${i.coprocessorOperandRegister1}, '
      'C${i.coprocessorOperandRegister2}, '
      '${i.coprocessorInformation}';

  @override
  String visitLDC(
    LDC i, [
    void _,
  ]) =>
      'LDP${_cond(i)}${i.n == 1 ? 'L' : ''} '
      'P#${i.coprocessorNumber}, '
      'C${i.coprocessorSourceOrDestinationRegister}, '
      '${i.unsigned8BitImmediateOffset}';

  @override
  String visitSTC(
    STC i, [
    void _,
  ]) =>
      'STC${_cond(i)}${i.n == 1 ? 'L' : ''} '
      'P#${i.coprocessorNumber}, '
      'C${i.coprocessorSourceOrDestinationRegister}, '
      '[R${i.baseRegister}, #${i.unsigned8BitImmediateOffset}]';

  @override
  String visitMCR(
    MCR i, [
    void _,
  ]) =>
      'MCR${_cond(i)} '
      'P${i.coprocessorNumber}, '
      '${i.coprocessorOperationCode}, '
      'R${i.sourceRegister}, '
      'C${i.coprocessorDestinationRegister}, '
      'C${i.coprocessorOperandRegister}';

  @override
  String visitMRC(
    MRC i, [
    void _,
  ]) =>
      'MRC${_cond(i)} '
      'P${i.coprocessorNumber}, '
      '${i.coprocessorOperationCode}, '
      'R${i.destinationRegister}, '
      'C${i.coprocessorSourceRegister}, '
      'C${i.coprocessorOperandRegister}';
}
