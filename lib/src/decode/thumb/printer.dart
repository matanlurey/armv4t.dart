import 'package:armv4t/src/decode/common.dart' as common;
import 'package:armv4t/src/decode/thumb/instruction.dart';
import 'package:meta/meta.dart';

class ThumbInstructionPrinter implements ThumbInstructionVisitor<String, void> {
  @visibleForTesting
  static String describeRegisterList(int registerList, [String suffix]) {
    return common.describeRegisterList(
      registerList,
      length: 8,
      suffix: suffix,
    );
  }

  const ThumbInstructionPrinter();

  @override
  String visitLSL$MoveShiftedRegister(
    LSL$MoveShiftedRegister i, [
    void _,
  ]) =>
      'LSL '
      'R${i.destinationRegister}, '
      'R${i.sourceRegister}, '
      '#${i.immediateValue}';

  @override
  String visitLSR$MoveShiftedRegister(
    LSR$MoveShiftedRegister i, [
    void _,
  ]) =>
      'LSR '
      'R${i.destinationRegister}, '
      'R${i.sourceRegister}, '
      '#${i.immediateValue}';

  @override
  String visitASR$MoveShiftedRegister(
    ASR$MoveShiftedRegister i, [
    void _,
  ]) =>
      'ASR '
      'R${i.destinationRegister}, '
      'R${i.sourceRegister}, '
      '#${i.immediateValue}';

  @override
  String visitADD$AddSubtract$Register(
    ADD$AddSubtract$Register i, [
    void _,
  ]) =>
      'ADD '
      'R${i.destinationRegister}, '
      'R${i.sourceRegister}, '
      'R${i.otherRegister}';

  @override
  String visitADD$AddSubtract$Offset3(
    ADD$AddSubtract$Offset3 i, [
    void _,
  ]) =>
      'ADD '
      'R${i.destinationRegister}, '
      'R${i.sourceRegister}, '
      '#${i.immediateValue}';

  @override
  String visitSUB$AddSubtract$Register(
    SUB$AddSubtract$Register i, [
    void _,
  ]) =>
      'SUB '
      'R${i.destinationRegister}, '
      'R${i.sourceRegister}, '
      'R${i.otherRegister}';

  @override
  String visitSUB$AddSubtract$Offset3(
    SUB$AddSubtract$Offset3 i, [
    void _,
  ]) =>
      'SUB '
      'R${i.destinationRegister}, '
      'R${i.sourceRegister}, '
      '#${i.immediateValue}';

  @override
  String visitMOV$MoveCompareAddSubtractImmediate(
    MOV$MoveCompareAddSubtractImmediate i, [
    void _,
  ]) =>
      'MOV '
      'R${i.destinationRegister}, '
      '#${i.immediateValue}';

  @override
  String visitCMP$MoveCompareAddSubtractImmediate(
    CMP$MoveCompareAddSubtractImmediate i, [
    void _,
  ]) =>
      'CMP '
      'R${i.destinationRegister}, '
      '#${i.immediateValue}';

  @override
  String visitADD$MoveCompareAddSubtractImmediate(
    ADD$MoveCompareAddSubtractImmediate i, [
    void _,
  ]) =>
      'ADD '
      'R${i.destinationRegister}, '
      '#${i.immediateValue}';

  @override
  String visitSUB$MoveCompareAddSubtractImmediate(
    SUB$MoveCompareAddSubtractImmediate i, [
    void _,
  ]) =>
      'SUB '
      'R${i.destinationRegister}, '
      '#${i.immediateValue}';

  @override
  String visitAND(
    AND i, [
    void _,
  ]) =>
      'AND '
      'R${i.destinationRegister}, '
      'R${i.sourceRegister}';

  @override
  String visitEOR(
    EOR i, [
    void _,
  ]) =>
      'EOR '
      'R${i.destinationRegister}, '
      'R${i.sourceRegister}';

  @override
  String visitLSL$ALU(
    LSL$ALU i, [
    void _,
  ]) =>
      'LSL '
      'R${i.destinationRegister}, '
      'R${i.sourceRegister}';

  @override
  String visitLSR$ALU(
    LSR$ALU i, [
    void _,
  ]) =>
      'LSR '
      'R${i.destinationRegister}, '
      'R${i.sourceRegister}';

  @override
  String visitASR$ALU(
    ASR$ALU i, [
    void _,
  ]) =>
      'ASR '
      'R${i.destinationRegister}, '
      'R${i.sourceRegister}';

  @override
  String visitADC(
    ADC i, [
    void _,
  ]) =>
      'ADC '
      'R${i.destinationRegister}, '
      'R${i.sourceRegister}';

  @override
  String visitSBC(
    SBC i, [
    void _,
  ]) =>
      'SBC '
      'R${i.destinationRegister}, '
      'R${i.sourceRegister}';

  @override
  String visitROR(
    ROR i, [
    void _,
  ]) =>
      'ROR '
      'R${i.destinationRegister}, '
      'R${i.sourceRegister}';

  @override
  String visitTST(
    TST i, [
    void _,
  ]) =>
      'TST '
      'R${i.destinationRegister}, '
      'R${i.sourceRegister}';

  @override
  String visitNEG(
    NEG i, [
    void _,
  ]) =>
      'NEG '
      'R${i.destinationRegister}, '
      'R${i.sourceRegister}';

  @override
  String visitCMP$ALU(
    CMP$ALU i, [
    void _,
  ]) =>
      'CMP '
      'R${i.destinationRegister}, '
      'R${i.sourceRegister}';

  @override
  String visitCMN(
    CMN i, [
    void _,
  ]) =>
      'CMN '
      'R${i.destinationRegister}, '
      'R${i.sourceRegister}';

  @override
  String visitORR(
    ORR i, [
    void _,
  ]) =>
      'ORR '
      'R${i.destinationRegister}, '
      'R${i.sourceRegister}';

  @override
  String visitMUL(
    MUL i, [
    void _,
  ]) =>
      'MUL '
      'R${i.destinationRegister}, '
      'R${i.sourceRegister}';

  @override
  String visitBIC(
    BIC i, [
    void _,
  ]) =>
      'BIC '
      'R${i.destinationRegister}, '
      'R${i.sourceRegister}';

  @override
  String visitMVN(
    MVN i, [
    void _,
  ]) =>
      'MVN '
      'R${i.destinationRegister}, '
      'R${i.sourceRegister}';

  @override
  String visitADD$HiToLo(
    ADD$HiToLo i, [
    void _,
  ]) =>
      'ADD '
      'R${i.destinationRegister}, '
      'H${i.sourceRegister}';

  @override
  String visitADD$LoToHi(
    ADD$LoToHi i, [
    void _,
  ]) =>
      'ADD '
      'H${i.destinationRegister}, '
      'R${i.sourceRegister}';

  @override
  String visitADD$HiToHi(
    ADD$HiToHi i, [
    void _,
  ]) =>
      'ADD '
      'H${i.destinationRegister}, '
      'H${i.sourceRegister}';

  @override
  String visitCMP$HiToLo(
    CMP$HiToLo i, [
    void _,
  ]) =>
      'CMP '
      'R${i.destinationRegister}, '
      'H${i.sourceRegister}';

  @override
  String visitCMP$LoToHi(
    CMP$LoToHi i, [
    void _,
  ]) =>
      'CMP '
      'H${i.destinationRegister}, '
      'R${i.sourceRegister}';

  @override
  String visitCMP$HiToHi(
    CMP$HiToHi i, [
    void _,
  ]) =>
      'CMP '
      'H${i.destinationRegister}, '
      'H${i.sourceRegister}';

  @override
  String visitMOV$HiToLo(
    MOV$HiToLo i, [
    void _,
  ]) =>
      'MOV '
      'R${i.destinationRegister}, '
      'H${i.sourceRegister}';

  @override
  String visitMOV$LoToHi(
    MOV$LoToHi i, [
    void _,
  ]) =>
      'MOV '
      'H${i.destinationRegister}, '
      'R${i.sourceRegister}';

  @override
  String visitMOV$HiToHi(
    MOV$HiToHi i, [
    void _,
  ]) =>
      'MOV '
      'H${i.destinationRegister}, '
      'H${i.sourceRegister}';

  @override
  String visitBX$Lo(
    BX$Lo i, [
    void _,
  ]) =>
      'BX '
      'R${i.sourceRegister}';

  @override
  String visitBX$Hi(
    BX$Hi i, [
    void _,
  ]) =>
      'BX '
      'H${i.sourceRegister}';

  @override
  String visitLDR$PCRelative(
    LDR$PCRelative i, [
    void _,
  ]) =>
      'LDR '
      'R${i.destinationRegister}, '
      '[PC, #${i.immediateValue}]';

  @override
  String visitSTR$RelativeOffset(
    STR$RelativeOffset i, [
    void _,
  ]) =>
      'STR '
      'R${i.destinationRegister}, '
      '[R${i.baseRegister}, R${i.offsetRegister}]';

  @override
  String visitSTRB$RelativeOffset(
    STRB$RelativeOffset i, [
    void _,
  ]) =>
      'STRB '
      'R${i.destinationRegister}, '
      '[R${i.baseRegister}, R${i.offsetRegister}]';

  @override
  String visitLDR$RelativeOffset(
    LDR$RelativeOffset i, [
    void _,
  ]) =>
      'LDR '
      'R${i.destinationRegister}, '
      '[R${i.baseRegister}, R${i.offsetRegister}]';

  @override
  String visitLDRB$RelativeOffset(
    LDRB$RelativeOffset i, [
    void _,
  ]) =>
      'LDRB '
      'R${i.destinationRegister}, '
      '[R${i.baseRegister}, R${i.offsetRegister}]';

  @override
  String visitSTRH$SignExtendedByteOrHalfWord(
    STRH$SignExtendedByteOrHalfWord i, [
    void _,
  ]) =>
      'STRH '
      'R${i.destinationRegister}, '
      '[R${i.baseRegister}, R${i.offsetRegister}]';

  @override
  String visitLDRH$SignExtendedByteOrHalfWord(
    LDRH$SignExtendedByteOrHalfWord i, [
    void _,
  ]) =>
      'LDRH '
      'R${i.destinationRegister}, '
      '[R${i.baseRegister}, R${i.offsetRegister}]';

  @override
  String visitLDSB(
    LDSB i, [
    void _,
  ]) =>
      'LDSB '
      'R${i.destinationRegister}, '
      '[R${i.baseRegister}, R${i.offsetRegister}]';

  @override
  String visitLDSH(
    LDSH i, [
    void _,
  ]) =>
      'LDSH '
      'R${i.destinationRegister}, '
      '[R${i.baseRegister}, R${i.offsetRegister}]';

  @override
  String visitSTR$ImmediateOffset(
    STR$ImmediateOffset i, [
    void _,
  ]) =>
      'STR '
      'R${i.destinationRegister}, '
      '[R${i.baseRegister}, #${i.immediateValue}]';

  @override
  String visitLDR$ImmediateOffset(
    LDR$ImmediateOffset i, [
    void _,
  ]) =>
      'LDR '
      'R${i.destinationRegister}, '
      '[R${i.baseRegister}, #${i.immediateValue}]';

  @override
  String visitSTRB$ImmediateOffset(
    STRB$ImmediateOffset i, [
    void _,
  ]) =>
      'STRB '
      'R${i.destinationRegister}, '
      '[R${i.baseRegister}, #${i.immediateValue}]';

  @override
  String visitLDRB$ImmediateOffset(
    LDRB$ImmediateOffset i, [
    void _,
  ]) =>
      'LDRB '
      'R${i.destinationRegister}, '
      '[R${i.baseRegister}, #${i.immediateValue}]';

  @override
  String visitSTRH$HalfWord(
    STRH$HalfWord i, [
    void _,
  ]) =>
      'STRH '
      'R${i.destinationRegister}, '
      '[R${i.baseRegister}, #${i.immediateValue}]';

  @override
  String visitLDRH$HalfWord(
    LDRH$HalfWord i, [
    void _,
  ]) =>
      'LDRH '
      'R${i.destinationRegister}, '
      '[R${i.baseRegister}, #${i.immediateValue}]';

  @override
  String visitSTR$SPRelative(
    STR$SPRelative i, [
    void _,
  ]) =>
      'STR '
      'R${i.destinationRegister}, '
      '[SP, #${i.immediateValue}]';

  @override
  String visitLDR$SPRelative(
    LDR$SPRelative i, [
    void _,
  ]) =>
      'LDR '
      'R${i.destinationRegister}, '
      '[SP, #${i.immediateValue}]';

  @override
  String visitADD$LoadAddress$PC(
    ADD$LoadAddress$PC i, [
    void _,
  ]) =>
      'ADD '
      'R${i.destinationRegister}, '
      'PC, '
      '#${i.immediateValue}';

  @override
  String visitADD$LoadAddress$SP(
    ADD$LoadAddress$SP i, [
    void _,
  ]) =>
      'ADD '
      'R${i.destinationRegister}, '
      'SP, '
      '#${i.immediateValue}';

  @override
  String visitADD$OffsetToStackPointer$Positive(
    ADD$OffsetToStackPointer$Positive i, [
    void _,
  ]) =>
      'ADD '
      'SP, '
      '#${i.immediateValue}';

  @override
  String visitADD$OffsetToStackPointer$Negative(
    ADD$OffsetToStackPointer$Negative i, [
    void _,
  ]) =>
      'ADD '
      'SP, '
      '#-${i.immediateValue}';

  @override
  String visitPUSH$Registers(
    PUSH$Registers i, [
    void _,
  ]) =>
      'PUSH '
      '{${describeRegisterList(i.registerList)}}';

  @override
  String visitPUSH$RegistersAndLinkRegister(
    PUSH$RegistersAndLinkRegister i, [
    void _,
  ]) =>
      'PUSH '
      '{${describeRegisterList(i.registerList, 'LR')}}';

  @override
  String visitPOP$Registers(
    POP$Registers i, [
    void _,
  ]) =>
      'POP '
      '{${describeRegisterList(i.registerList)}}';

  @override
  String visitPOP$RegistersAndProgramCounter(
    POP$RegistersAndLinkRegister i, [
    void _,
  ]) =>
      'POP '
      '{${describeRegisterList(i.registerList, 'PC')}}';

  @override
  String visitSTMIA(
    STMIA i, [
    void _,
  ]) =>
      'STMIA '
      'R${i.baseRegister}!, '
      '{${describeRegisterList(i.registerList)}}';

  @override
  String visitLDMIA(
    LDMIA i, [
    void _,
  ]) =>
      'LDMIA '
      'R${i.baseRegister}!, '
      '{${describeRegisterList(i.registerList)}}';

  @override
  String visitBEQ(
    BEQ i, [
    void _,
  ]) =>
      'BEQ '
      '${i.label}';

  @override
  String visitBNE(
    BNE i, [
    void _,
  ]) =>
      'BNE '
      '${i.label}';

  @override
  String visitBCS(
    BCS i, [
    void _,
  ]) =>
      'BCS '
      '${i.label}';

  @override
  String visitBCC(
    BCC i, [
    void _,
  ]) =>
      'BCC '
      '${i.label}';

  @override
  String visitBMI(
    BMI i, [
    void _,
  ]) =>
      'BMI '
      '${i.label}';

  @override
  String visitBPL(
    BPL i, [
    void _,
  ]) =>
      'BPL '
      '${i.label}';

  @override
  String visitBVS(
    BVS i, [
    void _,
  ]) =>
      'BVS '
      '${i.label}';

  @override
  String visitBVC(
    BVC i, [
    void _,
  ]) =>
      'BVC '
      '${i.label}';

  @override
  String visitBHI(
    BHI i, [
    void _,
  ]) =>
      'BHI '
      '${i.label}';

  @override
  String visitBLS(
    BLS i, [
    void _,
  ]) =>
      'BLS '
      '${i.label}';

  @override
  String visitBGE(
    BGE i, [
    void _,
  ]) =>
      'BGE '
      '${i.label}';

  @override
  String visitBLT(
    BLT i, [
    void _,
  ]) =>
      'BLT '
      '${i.label}';

  @override
  String visitBGT(
    BGT i, [
    void _,
  ]) =>
      'BGT '
      '${i.label}';

  @override
  String visitBLE(
    BLE i, [
    void _,
  ]) =>
      'BLE '
      '${i.label}';

  @override
  String visitSWI(
    SWI i, [
    void _,
  ]) =>
      'SWI '
      '${i.value}';

  @override
  String visitB(
    B i, [
    void _,
  ]) =>
      'B '
      '${i.immdediateValue}';

  @override
  String visitBL(
    BL i, [
    void _,
  ]) =>
      'BL '
      '${i.offset}';
}
