import 'package:armv4t/src/decode/arm/condition.dart';
import 'package:armv4t/src/decode/arm/operands.dart';
import 'package:binary/binary.dart';
import 'package:meta/meta.dart';

import 'instruction.dart';

/// Converts a [Condition] instance into its assembly-based [String] equivalent.
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

/// Converts an [ArmInstruction] into its assembly-based [String] equivalent.
class ArmInstructionPrinter
    with
        ArmLoadAndStoreWordOrUnsignedBytePrintHelper,
        ArmLoadAndStoreCoprocessorPrintHelper
    implements ArmInstructionVisitor<String, void> {
  final ArmConditionDecoder _conditionDecoder;
  final ArmConditionPrinter _conditionPrinter;
  final ShifterOperandDecoder _operandDecoder;
  final ShifterOperandPrinter _operandPrinter;

  const ArmInstructionPrinter([
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
  ]) =>
      throw UnimplementedError();

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
  String visitSTM(
    STM i, [
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

/// Encapsulates code to print instructions that use addressing mode 2.
mixin ArmLoadAndStoreWordOrUnsignedBytePrintHelper {
  /// Provide a way to encode a shifter operand.
  @visibleForOverriding
  String _shifterOperand(int immediate, int bits);

  /// Converst and [offset] into an assembler string.
  String _addressingMode2(
    int offset,
    int register, {
    @required int immediateOffset,
    @required int prePostIndexingBit,
    @required int upDownBit,
    @required int writeBackBit,
  }) {
    if (prePostIndexingBit == 0) {
      return _addressingMode2$PostIndexedOffset(
        offset,
        register,
        immediateOffset: immediateOffset,
        upDownBit: upDownBit,
      );
    } else {
      // PRE.
      if (writeBackBit == 0) {
        return _addressingMode2$ImmediateOffset(
          offset,
          register,
          immediateOffset: immediateOffset,
          upDownBit: upDownBit,
        );
      } else {
        return _addressingMode2$PreIndexedOffset(
          offset,
          register,
          immediateOffset: immediateOffset,
          upDownBit: upDownBit,
        );
      }
    }
  }

  String _addressingMode2$ImmediateOffset(
    int offset,
    int register, {
    @required int immediateOffset,
    @required int upDownBit,
  }) {
    var result = '[R$register, ';
    if (upDownBit == 0) {
      result = '$result-';
    } else {
      result = '$result+';
    }
    return '$result${_shifterOperand(immediateOffset, offset)}]';
  }

  String _addressingMode2$PreIndexedOffset(
    int offset,
    int register, {
    @required int immediateOffset,
    @required int upDownBit,
  }) {
    final result = _addressingMode2$ImmediateOffset(
      offset,
      register,
      immediateOffset: immediateOffset,
      upDownBit: upDownBit,
    );
    return '$result!';
  }

  String _addressingMode2$PostIndexedOffset(
    int offset,
    int register, {
    @required int immediateOffset,
    @required int upDownBit,
  }) {
    final op = _shifterOperand(immediateOffset, offset);
    if (op.endsWith('RRX')) {
      return _addressingMode2$PostIndexedOffset$RRX(
        register,
        op,
        upDownBit: upDownBit,
      );
    } else {
      var result = '[R$register], ';
      if (upDownBit == 0) {
        result = '$result-';
      } else {
        result = '$result+';
      }
      return '$result$op';
    }
  }

  String _addressingMode2$PostIndexedOffset$RRX(
    int register,
    String offset, {
    @required int upDownBit,
  }) {
    final prefix = upDownBit == 0 ? '-' : '+';
    return '[R$register, $prefix$offset]';
  }
}

/// Encapsulates code to print coprocessor data transfers (`LDC`, `STC`).
mixin ArmLoadAndStoreCoprocessorPrintHelper {
  /// Converts an [offset] into an assembler string.
  ///
  /// [offset], or _addressing mode 5_ as specified in ARM, can be:
  ///
  /// 1. An expression which generates an address: `<expression>`.
  ///    The assembler will attempt to generate an instruction using the program
  ///    counter (`PC`) as a base and a corrected immediate offset to address
  ///    the location by evaluating the expression. This will be a PC-relative,
  ///    pre-indexed address. If the address is out of range, and error will be
  ///    generated.
  ///
  ///    Format: `[Rn, #+/-(8bit_Offset*4)]`
  ///
  /// 2. A pre-indexed addressing specification:
  ///    - `[Rn]`: Offset of zero.
  ///    - `[Rn, <#expression>]{!}`: Offset of `<expression>` bytes.
  ///
  ///    Format: `[Rn, #+/-(8bit_Offset*4)]!`
  ///
  /// 3. A post-indexed addressing specification:
  ///   - `[Rn], <#expression>`: Offset of `<expression>` bytes.
  ///
  ///   Format: `[Rn], #+/-(8bit_Offset*4)`
  ///
  /// > NOTE: If `Rn` is `R15`, the assembler will subtract 8 from the offset
  /// > value to allow for ARM7TDI pipelining.
  String _addressingMode5(
    int offset,
    int register, {
    @required int prePostIndexingBit,
    @required int upDownBit,
    @required int writeBackBit,
  }) {
    final prefix = '#${upDownBit == 0 ? '-' : '+'}';
    if (prePostIndexingBit == 0) {
      if (writeBackBit == 0) {
        // 1: [Rn, #+/-(Offset)]
        return '[R$register, $prefix$offset]';
      } else {
        // 2: [Rn, #+/-(8bit_Offset*4)]!
        return '[R$register, $prefix$offset]!';
      }
    } else {
      // 3: [Rn], #+/-(8bit_Offset*4)
      assert(writeBackBit == 0);
      return '[R$register], $prefix$offset';
    }
  }
}
