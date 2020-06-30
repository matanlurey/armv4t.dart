import 'package:armv4t/src/decode/arm/condition.dart';
import 'package:armv4t/src/decode/arm/operands.dart';
import 'package:armv4t/src/decode/common.dart';
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
        InstructionPrintHelper,
        ArmLoadAndStoreWordOrUnsignedBytePrintHelper,
        ArmLoadAndStoreHalfWordOrLoadSignedByte,
        ArmLoadAndStoreMultiplePrintHelper,
        ArmLoadAndStoreCoprocessorPrintHelper
    implements ArmInstructionVisitor<String, void> {
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

  String _describeCondition(ArmInstruction i) {
    return _conditionDecoder
        .decodeBits(i.condition)
        .accept(_conditionPrinter)
        .toLowerCase();
  }

  String _s(int sBit) => sBit == 1 ? 's' : '';

  String _i(int iBit, int operand) => iBit == 1 ? '${operand}' : 'r${operand}';

  String _describeFieldMask(int bits) {
    if (bits == 0) return '';
    final result = StringBuffer('_');
    if (bits.getBit(3) == 1) {
      result.write('c');
    }
    if (bits.getBit(2) == 1) {
      result.write('x');
    }
    if (bits.getBit(1) == 1) {
      result.write('s');
    }
    if (bits.getBit(0) == 1) {
      result.write('f');
    }
    return result.toString();
  }

  @override
  String describeShifterOperand(bool treatAsImmediate, int bits) {
    ArmShifterOperand operand;
    if (treatAsImmediate) {
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
      'b${_describeCondition(i)} '
      '${i.targetAddress}';

  @override
  String visitBL(
    BL i, [
    void _,
  ]) =>
      'b${_describeCondition(i)} '
      '${i.targetAddress}';

  @override
  String visitBX(
    BX i, [
    void _,
  ]) =>
      'bx${_describeCondition(i)} '
      '${describeRegister(i.targetRegister)}';

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
        'ldm${_describeCondition(i)}$addressingMode '
        '${describeRegister(i.baseRegister)}${i.w == 1 ? '!' : ''}, '
        '{${describeRegisterList(i.registerList, length: 16)}}${i.s == 1 ? '^' : ''}';
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
        'stm${_describeCondition(i)}$addressingMode '
        '${describeRegister(i.baseRegister)}${i.w == 1 ? '!' : ''}, '
        '{${describeRegisterList(i.registerList, length: 16)}}${i.s == 1 ? '^' : ''}';
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
        'str${_describeCondition(i)}${i.w == 1 && i.p == 0 ? 't' : ''} '
        '${describeRegister(i.destinationRegister)}, '
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
        'str${_describeCondition(i)}b${i.w == 1 && i.p == 0 ? 't' : ''} '
        '${describeRegister(i.destinationRegister)}, '
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
        'ldr${_describeCondition(i)}${i.w == 1 && i.p == 0 ? 't' : ''} '
        '${describeRegister(i.destinationRegister)}, '
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
        'ldr${_describeCondition(i)}b${i.w == 1 && i.p == 0 ? 't' : ''} '
        '${describeRegister(i.destinationRegister)}, '
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
    return ''
        'ldr${_describeCondition(i)}h '
        '${describeRegister(i.sourceRegister)}, '
        '$addressMode3';
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
    return ''
        'str${_describeCondition(i)}h '
        '${describeRegister(i.destinationRegister)}, '
        '$addressMode3';
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
    return ''
        'ldr${_describeCondition(i)}sb '
        '${describeRegister(i.sourceRegister)}, '
        '$addressMode3';
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
    return ''
        'ldr${_describeCondition(i)}sh '
        '${describeRegister(i.sourceRegister)}, '
        '$addressMode3';
  }

  @override
  String visitMOV(
    MOV i, [
    void _,
  ]) =>
      'mov${_describeCondition(i)}${_s(i.s)} '
      '${describeRegister(i.destinationRegister)}, '
      '${describeShifterOperand(i.i == 1, i.shifterOperand)}';

  @override
  String visitMRS(
    MRS i, [
    void _,
  ]) =>
      'mrs${_describeCondition(i)} '
      '${describeRegister(i.destinationRegister)}, '
      '${i.sourcePSR == 0 ? 'cpsr' : 'spsr'}';

  @override
  String visitMSR(
    MSR i, [
    void _,
  ]) =>
      'msr${_describeCondition(i)} '
      '${i.destinationPSR == 0 ? 'cpsr' : 'spsr'}'
      '${_describeFieldMask(i.fieldMask)}, '
      '${_i(i.immediateOperand, i.sourceOperand)}';

  @override
  String visitMVN(
    MVN i, [
    void _,
  ]) =>
      'mvn${_describeCondition(i)}${_s(i.s)} '
      '${describeRegister(i.destinationRegister)}, '
      '${describeShifterOperand(i.i == 1, i.shifterOperand)}';

  @override
  String visitSWP(
    SWP i, [
    void _,
  ]) =>
      'swp${_describeCondition(i)} '
      '${describeRegister(i.sourceRegister1)}, '
      '${describeRegister(i.destinationRegister)}, '
      '[${describeRegister(i.sourceRegister2)}]';

  @override
  String visitSWPB(
    SWPB i, [
    void _,
  ]) =>
      'swp${_describeCondition(i)}b '
      '${describeRegister(i.sourceRegister1)}, '
      '${describeRegister(i.destinationRegister)}, '
      '[${describeRegister(i.sourceRegister2)}]';

  @override
  String visitAND(
    AND i, [
    void _,
  ]) =>
      'and${_describeCondition(i)}${_s(i.s)} '
      '${describeRegister(i.destinationRegister)}, '
      '${describeRegister(i.sourceRegister)}, '
      '${describeShifterOperand(i.i == 1, i.shifterOperand)}';

  @override
  String visitBIC(
    BIC i, [
    void _,
  ]) =>
      'bic${_describeCondition(i)}${_s(i.s)} '
      '${describeRegister(i.destinationRegister)}, '
      '${describeRegister(i.sourceRegister)}, '
      '${describeShifterOperand(i.i == 1, i.shifterOperand)}';

  @override
  String visitCMN(
    CMN i, [
    void _,
  ]) =>
      'cmn${_describeCondition(i)} '
      '${describeRegister(i.sourceRegister)}, '
      '${describeShifterOperand(i.i == 1, i.shifterOperand)}';

  @override
  String visitCMP(
    CMP i, [
    void _,
  ]) =>
      'cmp${_describeCondition(i)} '
      '${describeRegister(i.sourceRegister)}, '
      '${describeShifterOperand(i.i == 1, i.shifterOperand)}';

  @override
  String visitEOR(
    EOR i, [
    void _,
  ]) =>
      'eor${_describeCondition(i)}${_s(i.s)} '
      '${describeRegister(i.destinationRegister)}, '
      '${describeRegister(i.sourceRegister)}, '
      '${describeShifterOperand(i.i == 1, i.shifterOperand)}';

  @override
  String visitORR(
    ORR i, [
    void _,
  ]) =>
      'orr${_describeCondition(i)}${_s(i.s)} '
      '${describeRegister(i.destinationRegister)}, '
      '${describeRegister(i.sourceRegister)}, '
      '${describeShifterOperand(i.i == 1, i.shifterOperand)}';

  @override
  String visitTEQ(
    TEQ i, [
    void _,
  ]) =>
      'teq${_describeCondition(i)} '
      '${describeRegister(i.sourceRegister)}, '
      '${describeShifterOperand(i.i == 1, i.shifterOperand)}';

  @override
  String visitTST(
    TST i, [
    void _,
  ]) =>
      'tst${_describeCondition(i)} '
      '${describeRegister(i.sourceRegister)}, '
      '${describeShifterOperand(i.i == 1, i.shifterOperand)}';

  @override
  String visitADC(
    ADC i, [
    void _,
  ]) =>
      'adc${_describeCondition(i)}${_s(i.s)} '
      '${describeRegister(i.destinationRegister)}, '
      '${describeRegister(i.sourceRegister)}, '
      '${describeShifterOperand(i.i == 1, i.shifterOperand)}';

  @override
  String visitADD(
    ADD i, [
    void _,
  ]) =>
      'add${_describeCondition(i)}${_s(i.s)} '
      '${describeRegister(i.destinationRegister)}, '
      '${describeRegister(i.sourceRegister)}, '
      '${describeShifterOperand(i.i == 1, i.shifterOperand)}';

  @override
  String visitMLA(
    MLA i, [
    void _,
  ]) =>
      'mla${_describeCondition(i)}${_s(i.s)} '
      '${describeRegister(i.destinationRegister)}, '
      '${describeRegister(i.sourceRegister)}, '
      '${describeRegister(i.operandRegister1)}, '
      '${describeRegister(i.operandRegister2)}';

  @override
  String visitMUL(
    MUL i, [
    void _,
  ]) =>
      'mul${_describeCondition(i)}${_s(i.s)} '
      '${describeRegister(i.destinationRegister)}, '
      '${describeRegister(i.operandRegister)}, '
      '${describeRegister(i.sourceRegister)}';

  @override
  String visitRSB(
    RSB i, [
    void _,
  ]) =>
      'rsb${_describeCondition(i)}${_s(i.s)} '
      '${describeRegister(i.destinationRegister)}, '
      '${describeRegister(i.sourceRegister)}, '
      '${describeShifterOperand(i.i == 1, i.shifterOperand)}';

  @override
  String visitRSC(
    RSC i, [
    void _,
  ]) =>
      'rsc${_describeCondition(i)}${_s(i.s)} '
      '${describeRegister(i.destinationRegister)}, '
      '${describeRegister(i.sourceRegister)}, '
      '${describeShifterOperand(i.i == 1, i.shifterOperand)}';

  @override
  String visitSBC(
    SBC i, [
    void _,
  ]) =>
      'sbc${_describeCondition(i)}${_s(i.s)} '
      '${describeRegister(i.destinationRegister)}, '
      '${describeRegister(i.sourceRegister)}, '
      '${describeShifterOperand(i.i == 1, i.shifterOperand)}';

  @override
  String visitSUB(
    SUB i, [
    void _,
  ]) =>
      'sub${_describeCondition(i)}${_s(i.s)} '
      '${describeRegister(i.destinationRegister)}, '
      '${describeRegister(i.sourceRegister)}, '
      '${describeShifterOperand(i.i == 1, i.shifterOperand)}';

  @override
  String visitSMLAL(
    SMLAL i, [
    void _,
  ]) =>
      'smlal${_describeCondition(i)}${_s(i.s)} '
      '${describeRegister(i.destinationRegisterLSW)}, '
      '${describeRegister(i.destinationRegisterMSW)}, '
      '${describeRegister(i.sourceRegister)}, '
      '${describeRegister(i.operandRegister)}';

  @override
  String visitSMULL(
    SMULL i, [
    void _,
  ]) =>
      'smull${_describeCondition(i)}${_s(i.s)} '
      '${describeRegister(i.destinationRegisterLSW)}, '
      '${describeRegister(i.destinationRegisterMSW)}, '
      '${describeRegister(i.sourceRegister)}, '
      '${describeRegister(i.operandRegister)}';

  @override
  String visitUMLAL(
    UMLAL i, [
    void _,
  ]) =>
      'umlal${_describeCondition(i)}${_s(i.s)} '
      '${describeRegister(i.destinationRegisterLSW)}, '
      '${describeRegister(i.destinationRegisterMSW)}, '
      '${describeRegister(i.sourceRegister)}, '
      '${describeRegister(i.operandRegister)}';

  @override
  String visitUMULL(
    UMULL i, [
    void _,
  ]) =>
      'umull${_describeCondition(i)}${_s(i.s)} '
      '${describeRegister(i.destinationRegisterLSW)}, '
      '${describeRegister(i.destinationRegisterMSW)}, '
      '${describeRegister(i.sourceRegister)}, '
      '${describeRegister(i.operandRegister)}';

  @override
  String visitSWI(
    SWI i, [
    void _,
  ]) =>
      'swi${_describeCondition(i)} ${i.immediate24}';

  @override
  String visitCDP(
    CDP i, [
    void _,
  ]) =>
      'cdp${_describeCondition(i)} '
      'p${i.coprocessorNumber}, '
      '${i.coprocessorOpCode}, '
      'c${i.coprocessorDestinationRegister}, '
      'c${i.coprocessorOperandRegister1}, '
      'c${i.coprocessorOperandRegister2}, '
      '${i.coprocessorInformation}';

  @override
  String visitLDC(
    LDC i, [
    void _,
  ]) =>
      'ldc${_describeCondition(i)}${i.n == 1 ? 'l' : ''} '
      'p${i.coprocessorNumber}, '
      'c${i.coprocessorSourceOrDestinationRegister}, '
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
      'stc${_describeCondition(i)}${i.n == 1 ? 'l' : ''} '
      'p${i.coprocessorNumber}, '
      'c${i.coprocessorSourceOrDestinationRegister}, '
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
      'mcr${_describeCondition(i)} '
      'p${i.coprocessorNumber}, '
      '${i.coprocessorOperationCode}, '
      '${describeRegister(i.sourceRegister)}, '
      'c${i.coprocessorDestinationRegister}, '
      'c${i.coprocessorOperandRegister}';

  @override
  String visitMRC(
    MRC i, [
    void _,
  ]) =>
      'mrc${_describeCondition(i)} '
      'p${i.coprocessorNumber}, '
      '${i.coprocessorOperationCode}, '
      '${describeRegister(i.destinationRegister)}, '
      'c${i.coprocessorSourceRegister}, '
      'c${i.coprocessorOperandRegister}';
}
