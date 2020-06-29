import 'package:armv4t/src/decode/common.dart' as common;
import 'package:armv4t/src/decode/arm/condition.dart';
import 'package:armv4t/src/decode/arm/operands.dart';
import 'package:binary/binary.dart';
import 'package:meta/meta.dart';

import 'instruction.dart';

part 'printer/condition.dart';
part 'printer/coprocessor.dart';
part 'printer/half_word_or_signed_byte.dart';
part 'printer/multiple.dart';
part 'printer/word_or_unsigned_byte.dart';

/// Converts an [ArmInstruction] into its assembly-based [String] equivalent.
class ArmInstructionPrinter
    with
        ArmLoadAndStoreWordOrUnsignedBytePrintHelper,
        ArmLoadAndStoreHalfWordOrLoadSignedByte,
        ArmLoadAndStoreMultiplePrintHelper,
        ArmLoadAndStoreCoprocessorPrintHelper
    implements ArmInstructionVisitor<String, void> {
  @visibleForTesting
  static String describeRegisterList(int registerList, [String suffix]) {
    return common.describeRegisterList(
      registerList,
      length: 16,
      suffix: suffix,
    );
  }

  final ArmConditionDecoder _conditionDecoder;
  final ArmConditionPrinter _conditionPrinter;
  final ShifterOperandDecoder _operandDecoder;
  final ShifterOperandPrinter _operandPrinter;

  ArmInstructionPrinter([
    this._conditionDecoder = const ArmConditionDecoder(),
    this._conditionPrinter = const ArmConditionPrinter(),
    this._operandDecoder = const ShifterOperandDecoder(),
    this._operandPrinter = const ShifterOperandPrinter(),
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
  String _shifterOperand(int immediate, int bits) {
    ArmShifterOperand operand;
    if (immediate == 0) {
      operand = _operandDecoder.decodeImmediate(bits);
    } else {
      operand = _operandDecoder.decodeRegister(bits);
    }
    return operand.accept(_operandPrinter);
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
  ]) {
    // <LDM|STM>{cond}<FD|ED|FA|EA|IA|IB|DA|DB> Rn{!},<Rlist>{^}
    //
    // The mneumonics of the stack operators instead of the normal operators are
    // apparently optional (aliases in ARM assembly) and there does not appear
    // to be a way to determine whether this instruction is intended to be a
    // stack operation or not (at least not based on a bit value).
    //
    // If there is, we should update this code to be dynamic.
    final addressingMode = _addressingMode4L(
      prePostIndexingBit: i.p,
      upDownBit: i.u,
    );
    return ''
        'LDM${_cond(i)}$addressingMode '
        'R${i.baseRegister}${i.w == 1 ? '!' : ''}, '
        '{${describeRegisterList(i.registerList)}}${i.s == 1 ? '^' : ''}';
  }

  @override
  String visitSTM(
    STM i, [
    void _,
  ]) {
    // <LDM|STM>{cond}<FD|ED|FA|EA|IA|IB|DA|DB> Rn{!},<Rlist>{^}
    //
    // The mneumonics of the stack operators instead of the normal operators are
    // apparently optional (aliases in ARM assembly) and there does not appear
    // to be a way to determine whether this instruction is intended to be a
    // stack operation or not (at least not based on a bit value).
    //
    // If there is, we should update this code to be dynamic.
    final addressingMode = _addressingMode4L(
      prePostIndexingBit: i.p,
      upDownBit: i.u,
    );
    return ''
        'STM${_cond(i)}$addressingMode '
        'R${i.baseRegister}${i.w == 1 ? '!' : ''}, '
        '{${describeRegisterList(i.registerList)}}${i.s == 1 ? '^' : ''}';
  }

  @override
  String visitSTR(
    STR i, [
    void _,
  ]) {
    final addressMode2 = _addressingMode2(
      i.addressingMode2Offset,
      i.sourceRegister,
      immediateOffset: i.i,
      prePostIndexingBit: i.p,
      upDownBit: i.u,
      writeBackBit: i.w,
    );
    return ''
        'STR${_cond(i)}${i.w == 1 && i.p == 0 ? 'T' : ''} '
        'R${i.destinationRegister}, '
        '$addressMode2';
  }

  @override
  String visitSTRB(
    STRB i, [
    void _,
  ]) {
    final addressMode2 = _addressingMode2(
      i.addressingMode2Offset,
      i.sourceRegister,
      immediateOffset: i.i,
      prePostIndexingBit: i.p,
      upDownBit: i.u,
      writeBackBit: i.w,
    );
    return ''
        'STR${_cond(i)}B${i.w == 1 && i.p == 0 ? 'T' : ''} '
        'R${i.destinationRegister}, '
        '$addressMode2';
  }

  @override
  String visitLDR(
    LDR i, [
    void _,
  ]) {
    final addressMode2 = _addressingMode2(
      i.addressingMode2Offset,
      i.sourceRegister,
      immediateOffset: i.i,
      prePostIndexingBit: i.p,
      upDownBit: i.u,
      writeBackBit: i.w,
    );
    return ''
        'LDR${_cond(i)}${i.w == 1 && i.p == 0 ? 'T' : ''} '
        'R${i.destinationRegister}, '
        '$addressMode2';
  }

  @override
  String visitLDRB(
    LDRB i, [
    void _,
  ]) {
    final addressMode2 = _addressingMode2(
      i.addressingMode2Offset,
      i.sourceRegister,
      immediateOffset: i.i,
      prePostIndexingBit: i.p,
      upDownBit: i.u,
      writeBackBit: i.w,
    );
    return ''
        'LDR${_cond(i)}B${i.w == 1 && i.p == 0 ? 'T' : ''} '
        'R${i.destinationRegister}, '
        '$addressMode2';
  }

  @override
  String visitLDRH(
    LDRH i, [
    void _,
  ]) {
    // <LDR|STR>{cond}<H|SH|SB> Rd,<address>
    final highNibbleShifted = i.addressingMode2HighNibble << 4;
    final combinedAddress = highNibbleShifted | i.addressingMode2LowNibble;
    final addressMode3 = _addressingMode3(
      combinedAddress,
      i.baseRegister,
      immediateOffset: i.i,
      prePostIndexingBit: i.p,
      upDownBit: i.u,
      writeBackBit: i.w,
    );
    return 'LDR${_cond(i)}H R${i.sourceRegister}, $addressMode3';
  }

  @override
  String visitSTRH(
    STRH i, [
    void _,
  ]) {
    // <LDR|STR>{cond}<H|SH|SB> Rd,<address>
    final highNibbleShifted = i.addressingMode2HighNibble << 4;
    final combinedAddress = highNibbleShifted | i.addressingMode2LowNibble;
    final addressMode3 = _addressingMode3(
      combinedAddress,
      i.baseRegister,
      immediateOffset: i.i,
      prePostIndexingBit: i.p,
      upDownBit: i.u,
      writeBackBit: i.w,
    );
    return 'STR${_cond(i)}H R${i.destinationRegister}, $addressMode3';
  }

  @override
  String visitLDRSB(
    LDRSB i, [
    void _,
  ]) {
    // <LDR|STR>{cond}<H|SH|SB> Rd,<address>
    final highNibbleShifted = i.addressingMode2HighNibble << 4;
    final combinedAddress = highNibbleShifted | i.addressingMode2LowNibble;
    final addressMode3 = _addressingMode3(
      combinedAddress,
      i.baseRegister,
      immediateOffset: i.i,
      prePostIndexingBit: i.p,
      upDownBit: i.u,
      writeBackBit: i.w,
    );
    return 'LDR${_cond(i)}SB R${i.sourceRegister}, $addressMode3';
  }

  @override
  String visitLDRSH(
    LDRSH i, [
    void _,
  ]) {
    // <LDR|STR>{cond}<H|SH|SB> Rd,<address>
    final highNibbleShifted = i.addressingMode2HighNibble << 4;
    final combinedAddress = highNibbleShifted | i.addressingMode2LowNibble;
    final addressMode3 = _addressingMode3(
      combinedAddress,
      i.baseRegister,
      immediateOffset: i.i,
      prePostIndexingBit: i.p,
      upDownBit: i.u,
      writeBackBit: i.w,
    );
    return 'LDR${_cond(i)}SH R${i.sourceRegister}, $addressMode3';
  }

  @override
  String visitMOV(
    MOV i, [
    void _,
  ]) =>
      'MOV${_cond(i)}${_s(i.s)} '
      'R${i.destinationRegister}, '
      '${_shifterOperand(i.i, i.shifterOperand)}';

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
      '${_shifterOperand(i.i, i.shifterOperand)}';

  @override
  String visitSWP(
    SWP i, [
    void _,
  ]) =>
      'SWP${_cond(i)} '
      'R${i.sourceRegister1}, '
      'R${i.destinationRegister}, '
      '[R${i.sourceRegister2}]';

  @override
  String visitSWPB(
    SWPB i, [
    void _,
  ]) =>
      'SWPB${_cond(i)} '
      'R${i.sourceRegister1}, '
      'R${i.destinationRegister}, '
      '[R${i.sourceRegister2}]';

  @override
  String visitAND(
    AND i, [
    void _,
  ]) =>
      'AND${_cond(i)}${_s(i.s)} '
      'R${i.destinationRegister}, '
      'R${i.sourceRegister}, '
      '${_shifterOperand(i.i, i.shifterOperand)}';

  @override
  String visitBIC(
    BIC i, [
    void _,
  ]) =>
      'BIC${_cond(i)}${_s(i.s)} '
      'R${i.destinationRegister}, '
      'R${i.sourceRegister}, '
      '${_shifterOperand(i.i, i.shifterOperand)}';

  @override
  String visitCMN(
    CMN i, [
    void _,
  ]) =>
      'CMN${_cond(i)} '
      'R${i.destinationRegister}, '
      'R${i.sourceRegister}, '
      '${_shifterOperand(i.i, i.shifterOperand)}';

  @override
  String visitCMP(
    CMP i, [
    void _,
  ]) =>
      'CMP${_cond(i)} '
      'R${i.destinationRegister}, '
      'R${i.sourceRegister}, '
      '${_shifterOperand(i.i, i.shifterOperand)}';

  @override
  String visitEOR(
    EOR i, [
    void _,
  ]) =>
      'EOR${_cond(i)}${_s(i.s)} '
      'R${i.destinationRegister}, '
      'R${i.sourceRegister}, '
      '${_shifterOperand(i.i, i.shifterOperand)}';

  @override
  String visitORR(
    ORR i, [
    void _,
  ]) =>
      'ORR${_cond(i)}${_s(i.s)} '
      'R${i.destinationRegister}, '
      'R${i.sourceRegister}, '
      '${_shifterOperand(i.i, i.shifterOperand)}';

  @override
  String visitTEQ(
    TEQ i, [
    void _,
  ]) =>
      'TEQ${_cond(i)} '
      'R${i.destinationRegister}, '
      'R${i.sourceRegister}, '
      '${_shifterOperand(i.i, i.shifterOperand)}';

  @override
  String visitTST(
    TST i, [
    void _,
  ]) =>
      'TST${_cond(i)} '
      'R${i.destinationRegister}, '
      'R${i.sourceRegister}, '
      '${_shifterOperand(i.i, i.shifterOperand)}';

  @override
  String visitADC(
    ADC i, [
    void _,
  ]) =>
      'ADC${_cond(i)}${_s(i.s)} '
      'R${i.destinationRegister}, '
      'R${i.sourceRegister}, '
      '${_shifterOperand(i.i, i.shifterOperand)}';

  @override
  String visitADD(
    ADD i, [
    void _,
  ]) =>
      'ADD${_cond(i)}${_s(i.s)} '
      'R${i.destinationRegister}, '
      'R${i.sourceRegister}, '
      '${_shifterOperand(i.i, i.shifterOperand)}';

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
      '${_shifterOperand(i.i, i.shifterOperand)}';

  @override
  String visitRSC(
    RSC i, [
    void _,
  ]) =>
      'RSC${_cond(i)}${_s(i.s)} '
      'R${i.destinationRegister}, '
      'R${i.sourceRegister}, '
      '${_shifterOperand(i.i, i.shifterOperand)}';

  @override
  String visitSBC(
    SBC i, [
    void _,
  ]) =>
      'SBC${_cond(i)}${_s(i.s)} '
      'R${i.destinationRegister}, '
      'R${i.sourceRegister}, '
      '${_shifterOperand(i.i, i.shifterOperand)}';

  @override
  String visitSUB(
    SUB i, [
    void _,
  ]) =>
      'SUB${_cond(i)}${_s(i.s)} '
      'R${i.destinationRegister}, '
      'R${i.sourceRegister}, '
      '${_shifterOperand(i.i, i.shifterOperand)}';

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
      'P${i.coprocessorNumber}, '
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
      'LDC${_cond(i)}${i.n == 1 ? 'L' : ''} '
      'P${i.coprocessorNumber}, '
      'C${i.coprocessorSourceOrDestinationRegister}, '
      '${_addressingMode5(
        i.unsigned8BitImmediateOffset,
        i.baseRegister,
        prePostIndexingBit: i.p,
        upDownBit: i.u,
        writeBackBit: i.w,
      )}';

  @override
  String visitSTC(
    STC i, [
    void _,
  ]) =>
      'STC${_cond(i)}${i.n == 1 ? 'L' : ''} '
      'P${i.coprocessorNumber}, '
      'C${i.coprocessorSourceOrDestinationRegister}, '
      '${_addressingMode5(
        i.unsigned8BitImmediateOffset,
        i.baseRegister,
        prePostIndexingBit: i.p,
        upDownBit: i.u,
        writeBackBit: i.w,
      )}';

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
