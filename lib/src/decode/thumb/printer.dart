import 'package:armv4t/src/decode/common.dart';
import 'package:armv4t/src/decode/thumb/instruction.dart';

class ThumbInstructionPrinter
    with InstructionPrintHelper
    implements ThumbInstructionVisitor<String, void> {
  const ThumbInstructionPrinter();

  @override
  String visitLSL$MoveShiftedRegister(
    LSL$MoveShiftedRegister i, [
    void _,
  ]) =>
      'lsl '
      '${describeRegister(i.destinationRegister)}, '
      '${describeRegister(i.sourceRegister)}, '
      '#${i.immediateValue}';

  @override
  String visitLSR$MoveShiftedRegister(
    LSR$MoveShiftedRegister i, [
    void _,
  ]) =>
      'lsr '
      '${describeRegister(i.destinationRegister)}, '
      '${describeRegister(i.sourceRegister)}, '
      '#${i.immediateValue}';

  @override
  String visitASR$MoveShiftedRegister(
    ASR$MoveShiftedRegister i, [
    void _,
  ]) =>
      'asr '
      '${describeRegister(i.destinationRegister)}, '
      '${describeRegister(i.sourceRegister)}, '
      '#${i.immediateValue}';

  @override
  String visitADD$AddSubtract$Register(
    ADD$AddSubtract$Register i, [
    void _,
  ]) =>
      'add '
      '${describeRegister(i.destinationRegister)}, '
      '${describeRegister(i.sourceRegister)}, '
      '${describeRegister(i.otherRegister)}';

  @override
  String visitADD$AddSubtract$Offset3(
    ADD$AddSubtract$Offset3 i, [
    void _,
  ]) =>
      'add '
      '${describeRegister(i.destinationRegister)}, '
      '${describeRegister(i.sourceRegister)}, '
      '#${i.immediateValue}';

  @override
  String visitSUB$AddSubtract$Register(
    SUB$AddSubtract$Register i, [
    void _,
  ]) =>
      'sub '
      '${describeRegister(i.destinationRegister)}, '
      '${describeRegister(i.sourceRegister)}, '
      '${describeRegister(i.otherRegister)}';

  @override
  String visitSUB$AddSubtract$Offset3(
    SUB$AddSubtract$Offset3 i, [
    void _,
  ]) =>
      'sub '
      '${describeRegister(i.destinationRegister)}, '
      '${describeRegister(i.sourceRegister)}, '
      '#${i.immediateValue}';

  @override
  String visitMOV$MoveCompareAddSubtractImmediate(
    MOV$MoveCompareAddSubtractImmediate i, [
    void _,
  ]) =>
      'mov '
      '${describeRegister(i.destinationRegister)}, '
      '#${i.immediateValue}';

  @override
  String visitCMP$MoveCompareAddSubtractImmediate(
    CMP$MoveCompareAddSubtractImmediate i, [
    void _,
  ]) =>
      'cmp '
      '${describeRegister(i.destinationRegister)}, '
      '#${i.immediateValue}';

  @override
  String visitADD$MoveCompareAddSubtractImmediate(
    ADD$MoveCompareAddSubtractImmediate i, [
    void _,
  ]) =>
      'add '
      '${describeRegister(i.destinationRegister)}, '
      '#${i.immediateValue}';

  @override
  String visitSUB$MoveCompareAddSubtractImmediate(
    SUB$MoveCompareAddSubtractImmediate i, [
    void _,
  ]) =>
      'sub '
      '${describeRegister(i.destinationRegister)}, '
      '#${i.immediateValue}';

  @override
  String visitAND(
    AND i, [
    void _,
  ]) =>
      'and '
      '${describeRegister(i.destinationRegister)}, '
      '${describeRegister(i.sourceRegister)}';

  @override
  String visitEOR(
    EOR i, [
    void _,
  ]) =>
      'eor '
      '${describeRegister(i.destinationRegister)}, '
      '${describeRegister(i.sourceRegister)}';

  @override
  String visitLSL$ALU(
    LSL$ALU i, [
    void _,
  ]) =>
      'lsl '
      '${describeRegister(i.destinationRegister)}, '
      '${describeRegister(i.sourceRegister)}';

  @override
  String visitLSR$ALU(
    LSR$ALU i, [
    void _,
  ]) =>
      'lsr '
      '${describeRegister(i.destinationRegister)}, '
      '${describeRegister(i.sourceRegister)}';

  @override
  String visitASR$ALU(
    ASR$ALU i, [
    void _,
  ]) =>
      'asr '
      '${describeRegister(i.destinationRegister)}, '
      '${describeRegister(i.sourceRegister)}';

  @override
  String visitADC(
    ADC i, [
    void _,
  ]) =>
      'adc '
      '${describeRegister(i.destinationRegister)}, '
      '${describeRegister(i.sourceRegister)}';

  @override
  String visitSBC(
    SBC i, [
    void _,
  ]) =>
      'sbc '
      '${describeRegister(i.destinationRegister)}, '
      '${describeRegister(i.sourceRegister)}';

  @override
  String visitROR(
    ROR i, [
    void _,
  ]) =>
      'ror '
      '${describeRegister(i.destinationRegister)}, '
      '${describeRegister(i.sourceRegister)}';

  @override
  String visitTST(
    TST i, [
    void _,
  ]) =>
      'tst '
      '${describeRegister(i.destinationRegister)}, '
      '${describeRegister(i.sourceRegister)}';

  @override
  String visitNEG(
    NEG i, [
    void _,
  ]) =>
      'neg '
      '${describeRegister(i.destinationRegister)}, '
      '${describeRegister(i.sourceRegister)}';

  @override
  String visitCMP$ALU(
    CMP$ALU i, [
    void _,
  ]) =>
      'cmp '
      '${describeRegister(i.destinationRegister)}, '
      '${describeRegister(i.sourceRegister)}';

  @override
  String visitCMN(
    CMN i, [
    void _,
  ]) =>
      'cmn '
      '${describeRegister(i.destinationRegister)}, '
      '${describeRegister(i.sourceRegister)}';

  @override
  String visitORR(
    ORR i, [
    void _,
  ]) =>
      'orr '
      '${describeRegister(i.destinationRegister)}, '
      '${describeRegister(i.sourceRegister)}';

  @override
  String visitMUL(
    MUL i, [
    void _,
  ]) =>
      'mul '
      '${describeRegister(i.destinationRegister)}, '
      '${describeRegister(i.sourceRegister)}';

  @override
  String visitBIC(
    BIC i, [
    void _,
  ]) =>
      'bic '
      '${describeRegister(i.destinationRegister)}, '
      '${describeRegister(i.sourceRegister)}';

  @override
  String visitMVN(
    MVN i, [
    void _,
  ]) =>
      'mvn '
      '${describeRegister(i.destinationRegister)}, '
      '${describeRegister(i.sourceRegister)}';

  @override
  String visitADD$HiToLo(
    ADD$HiToLo i, [
    void _,
  ]) =>
      'add '
      '${describeRegister(i.destinationRegister)}, '
      'h${i.sourceRegister}';

  @override
  String visitADD$LoToHi(
    ADD$LoToHi i, [
    void _,
  ]) =>
      'add '
      'h${i.destinationRegister}, '
      '${describeRegister(i.sourceRegister)}';

  @override
  String visitADD$HiToHi(
    ADD$HiToHi i, [
    void _,
  ]) =>
      'add '
      'h${i.destinationRegister}, '
      'h${i.sourceRegister}';

  @override
  String visitCMP$HiToLo(
    CMP$HiToLo i, [
    void _,
  ]) =>
      'cmp '
      '${describeRegister(i.destinationRegister)}, '
      'h${i.sourceRegister}';

  @override
  String visitCMP$LoToHi(
    CMP$LoToHi i, [
    void _,
  ]) =>
      'cmp '
      'h${i.destinationRegister}, '
      '${describeRegister(i.sourceRegister)}';

  @override
  String visitCMP$HiToHi(
    CMP$HiToHi i, [
    void _,
  ]) =>
      'cmp '
      'h${i.destinationRegister}, '
      'h${i.sourceRegister}';

  @override
  String visitMOV$HiToLo(
    MOV$HiToLo i, [
    void _,
  ]) =>
      'mov '
      '${describeRegister(i.destinationRegister)}, '
      'h${i.sourceRegister}';

  @override
  String visitMOV$LoToHi(
    MOV$LoToHi i, [
    void _,
  ]) =>
      'mov '
      'h${i.destinationRegister}, '
      '${describeRegister(i.sourceRegister)}';

  @override
  String visitMOV$HiToHi(
    MOV$HiToHi i, [
    void _,
  ]) =>
      'mov '
      'h${i.destinationRegister}, '
      'h${i.sourceRegister}';

  @override
  String visitBX$Lo(
    BX$Lo i, [
    void _,
  ]) =>
      'bx '
      '${describeRegister(i.sourceRegister)}';

  @override
  String visitBX$Hi(
    BX$Hi i, [
    void _,
  ]) =>
      'bx '
      'h${i.sourceRegister}';

  @override
  String visitLDR$PCRelative(
    LDR$PCRelative i, [
    void _,
  ]) =>
      'ldr '
      '${describeRegister(i.destinationRegister)}, '
      '[pc, #${i.immediateValue}]';

  @override
  String visitSTR$RelativeOffset(
    STR$RelativeOffset i, [
    void _,
  ]) =>
      'str '
      '${describeRegister(i.destinationRegister)}, '
      '[${describeRegister(i.baseRegister)}, ${describeRegister(i.offsetRegister)}]';

  @override
  String visitSTRB$RelativeOffset(
    STRB$RelativeOffset i, [
    void _,
  ]) =>
      'strb '
      '${describeRegister(i.destinationRegister)}, '
      '[${describeRegister(i.baseRegister)}, ${describeRegister(i.offsetRegister)}]';

  @override
  String visitLDR$RelativeOffset(
    LDR$RelativeOffset i, [
    void _,
  ]) =>
      'ldr '
      '${describeRegister(i.destinationRegister)}, '
      '[${describeRegister(i.baseRegister)}, ${describeRegister(i.offsetRegister)}]';

  @override
  String visitLDRB$RelativeOffset(
    LDRB$RelativeOffset i, [
    void _,
  ]) =>
      'ldrb '
      '${describeRegister(i.destinationRegister)}, '
      '[${describeRegister(i.baseRegister)}, ${describeRegister(i.offsetRegister)}]';

  @override
  String visitSTRH$SignExtendedByteOrHalfWord(
    STRH$SignExtendedByteOrHalfWord i, [
    void _,
  ]) =>
      'strh '
      '${describeRegister(i.destinationRegister)}, '
      '[${describeRegister(i.baseRegister)}, ${describeRegister(i.offsetRegister)}]';

  @override
  String visitLDRH$SignExtendedByteOrHalfWord(
    LDRH$SignExtendedByteOrHalfWord i, [
    void _,
  ]) =>
      'ldrh '
      '${describeRegister(i.destinationRegister)}, '
      '[${describeRegister(i.baseRegister)}, ${describeRegister(i.offsetRegister)}]';

  @override
  String visitLDSB(
    LDSB i, [
    void _,
  ]) =>
      'ldsb '
      '${describeRegister(i.destinationRegister)}, '
      '[${describeRegister(i.baseRegister)}, ${describeRegister(i.offsetRegister)}]';

  @override
  String visitLDSH(
    LDSH i, [
    void _,
  ]) =>
      'ldsh '
      '${describeRegister(i.destinationRegister)}, '
      '[${describeRegister(i.baseRegister)}, ${describeRegister(i.offsetRegister)}]';

  @override
  String visitSTR$ImmediateOffset(
    STR$ImmediateOffset i, [
    void _,
  ]) =>
      'str '
      '${describeRegister(i.destinationRegister)}, '
      '[${describeRegister(i.baseRegister)}, #${i.immediateValue}]';

  @override
  String visitLDR$ImmediateOffset(
    LDR$ImmediateOffset i, [
    void _,
  ]) =>
      'ldr '
      '${describeRegister(i.destinationRegister)}, '
      '[${describeRegister(i.baseRegister)}, #${i.immediateValue}]';

  @override
  String visitSTRB$ImmediateOffset(
    STRB$ImmediateOffset i, [
    void _,
  ]) =>
      'strb '
      '${describeRegister(i.destinationRegister)}, '
      '[${describeRegister(i.baseRegister)}, #${i.immediateValue}]';

  @override
  String visitLDRB$ImmediateOffset(
    LDRB$ImmediateOffset i, [
    void _,
  ]) =>
      'ldrb '
      '${describeRegister(i.destinationRegister)}, '
      '[${describeRegister(i.baseRegister)}, #${i.immediateValue}]';

  @override
  String visitSTRH$HalfWord(
    STRH$HalfWord i, [
    void _,
  ]) =>
      'strh '
      '${describeRegister(i.destinationRegister)}, '
      '[${describeRegister(i.baseRegister)}, #${i.immediateValue}]';

  @override
  String visitLDRH$HalfWord(
    LDRH$HalfWord i, [
    void _,
  ]) =>
      'ldrh '
      '${describeRegister(i.destinationRegister)}, '
      '[${describeRegister(i.baseRegister)}, #${i.immediateValue}]';

  @override
  String visitSTR$SPRelative(
    STR$SPRelative i, [
    void _,
  ]) =>
      'str '
      '${describeRegister(i.destinationRegister)}, '
      '[sp, #${i.immediateValue}]';

  @override
  String visitLDR$SPRelative(
    LDR$SPRelative i, [
    void _,
  ]) =>
      'ldr '
      '${describeRegister(i.destinationRegister)}, '
      '[sp, #${i.immediateValue}]';

  @override
  String visitADD$LoadAddress$PC(
    ADD$LoadAddress$PC i, [
    void _,
  ]) =>
      'add '
      '${describeRegister(i.destinationRegister)}, '
      'pc, '
      '#${i.immediateValue}';

  @override
  String visitADD$LoadAddress$SP(
    ADD$LoadAddress$SP i, [
    void _,
  ]) =>
      'add '
      '${describeRegister(i.destinationRegister)}, '
      'sp, '
      '#${i.immediateValue}';

  @override
  String visitADD$OffsetToStackPointer$Positive(
    ADD$OffsetToStackPointer$Positive i, [
    void _,
  ]) =>
      'add '
      'sp, '
      '#${i.immediateValue}';

  @override
  String visitADD$OffsetToStackPointer$Negative(
    ADD$OffsetToStackPointer$Negative i, [
    void _,
  ]) =>
      'add '
      'sp, '
      '#-${i.immediateValue}';

  @override
  String visitPUSH$Registers(
    PUSH$Registers i, [
    void _,
  ]) =>
      'push '
      '{${describeRegisterList(i.registerList, length: 8)}}';

  @override
  String visitPUSH$RegistersAndLinkRegister(
    PUSH$RegistersAndLinkRegister i, [
    void _,
  ]) =>
      'push '
      '{${describeRegisterList(i.registerList, length: 8, suffix: 'lr')}}';

  @override
  String visitPOP$Registers(
    POP$Registers i, [
    void _,
  ]) =>
      'pop '
      '{${describeRegisterList(i.registerList, length: 8)}}';

  @override
  String visitPOP$RegistersAndProgramCounter(
    POP$RegistersAndLinkRegister i, [
    void _,
  ]) =>
      'pop '
      '{${describeRegisterList(i.registerList, length: 8, suffix: 'pc')}}';

  @override
  String visitSTMIA(
    STMIA i, [
    void _,
  ]) =>
      'stmia '
      '${describeRegister(i.baseRegister)}!, '
      '{${describeRegisterList(i.registerList, length: 8)}}';

  @override
  String visitLDMIA(
    LDMIA i, [
    void _,
  ]) =>
      'ldmia '
      '${describeRegister(i.baseRegister)}!, '
      '{${describeRegisterList(i.registerList, length: 8)}}';

  @override
  String visitBEQ(
    BEQ i, [
    void _,
  ]) =>
      'beq '
      '${i.label}';

  @override
  String visitBNE(
    BNE i, [
    void _,
  ]) =>
      'bne '
      '${i.label}';

  @override
  String visitBCS(
    BCS i, [
    void _,
  ]) =>
      'bcs '
      '${i.label}';

  @override
  String visitBCC(
    BCC i, [
    void _,
  ]) =>
      'bcc '
      '${i.label}';

  @override
  String visitBMI(
    BMI i, [
    void _,
  ]) =>
      'bmi '
      '${i.label}';

  @override
  String visitBPL(
    BPL i, [
    void _,
  ]) =>
      'bpl '
      '${i.label}';

  @override
  String visitBVS(
    BVS i, [
    void _,
  ]) =>
      'bvs '
      '${i.label}';

  @override
  String visitBVC(
    BVC i, [
    void _,
  ]) =>
      'bvc '
      '${i.label}';

  @override
  String visitBHI(
    BHI i, [
    void _,
  ]) =>
      'bhi '
      '${i.label}';

  @override
  String visitBLS(
    BLS i, [
    void _,
  ]) =>
      'bls '
      '${i.label}';

  @override
  String visitBGE(
    BGE i, [
    void _,
  ]) =>
      'bge '
      '${i.label}';

  @override
  String visitBLT(
    BLT i, [
    void _,
  ]) =>
      'blt '
      '${i.label}';

  @override
  String visitBGT(
    BGT i, [
    void _,
  ]) =>
      'bgt '
      '${i.label}';

  @override
  String visitBLE(
    BLE i, [
    void _,
  ]) =>
      'ble '
      '${i.label}';

  @override
  String visitSWI(
    SWI i, [
    void _,
  ]) =>
      'swi '
      '${i.value}';

  @override
  String visitB(
    B i, [
    void _,
  ]) =>
      'b '
      '${i.immdediateValue}';

  @override
  String visitBL(
    BL i, [
    void _,
  ]) =>
      'bl '
      '${i.offset}';
}
