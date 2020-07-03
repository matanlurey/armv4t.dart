import 'package:armv4t/src/decoder/arm/condition.dart';
import 'package:armv4t/src/decoder/arm/instruction.dart';
import 'package:binary/binary.dart';
import 'package:meta/meta.dart';

/// Given an [ArmInstruction], outputs the mnemonic (human-readable prefix).
@immutable
@sealed
class ArmMnemonicPrinter implements ArmInstructionVisitor<String, void> {
  const ArmMnemonicPrinter();

  @protected
  String visitCondition(Condition c) => c.mnuemonic;

  @protected
  String visitSetConditionCodes(bool v) => v ? 's' : '';

  @protected
  String visitSetPrivilegedMode(bool v) => v ? 'p' : '';

  @protected
  String visitMaySetConditionCodes(
    String mnemonic,
    MaySetConditionCodes i,
  ) {
    return ''
        '$mnemonic'
        '${visitCondition(i.condition)}'
        '${visitSetConditionCodes(i.setConditionCodes)}';
  }

  @override
  String visitADC(ADC i, [void _]) {
    return visitMaySetConditionCodes('adc', i);
  }

  @override
  String visitADD(ADD i, [void _]) {
    return visitMaySetConditionCodes('add', i);
  }

  @override
  String visitRSB(RSB i, [void _]) {
    return visitMaySetConditionCodes('rsb', i);
  }

  @override
  String visitRSC(RSC i, [void _]) {
    return visitMaySetConditionCodes('rsc', i);
  }

  @override
  String visitSBC(SBC i, [void _]) {
    return visitMaySetConditionCodes('sbc', i);
  }

  @override
  String visitSUB(SUB i, [void _]) {
    return visitMaySetConditionCodes('sub', i);
  }

  @override
  String visitAND(AND i, [void _]) {
    return visitMaySetConditionCodes('and', i);
  }

  @override
  String visitBIC(BIC i, [void _]) {
    return visitMaySetConditionCodes('bic', i);
  }

  @override
  String visitEOR(EOR i, [void _]) {
    return visitMaySetConditionCodes('eor', i);
  }

  @override
  String visitMOV(MOV i, [void _]) {
    return visitMaySetConditionCodes('mov', i);
  }

  @override
  String visitMVN(MVN i, [void _]) {
    return visitMaySetConditionCodes('mvn', i);
  }

  @override
  String visitORR(ORR i, [void _]) {
    return visitMaySetConditionCodes('orr', i);
  }

  @protected
  String visitDataProcessingWithVoidDestination(
    String mnemonic,
    DataProcessingArmInstruction i,
  ) {
    return ''
        '$mnemonic'
        '${visitCondition(i.condition)}'
        '${visitSetPrivilegedMode(i.destination == Register.filledWith1s)}';
  }

  @override
  String visitCMN(CMN i, [void _]) {
    return visitDataProcessingWithVoidDestination('cmn', i);
  }

  @override
  String visitCMP(CMP i, [void _]) {
    return visitDataProcessingWithVoidDestination('cmp', i);
  }

  @override
  String visitTEQ(TEQ i, [void _]) {
    return visitDataProcessingWithVoidDestination('teq', i);
  }

  @override
  String visitTST(TST i, [void _]) {
    return visitDataProcessingWithVoidDestination('tst', i);
  }

  @protected
  String visitSingleDataTransfer(
    String prefix,
    SingleDataTransferArmInstruction i, [
    String suffix = '',
  ]) {
    final b = i.transferByte ? 'b' : '';
    final t = i.forceNonPrivilegedAccess ? 't' : '';
    return '$prefix${visitCondition(i.condition)}$b$t$suffix';
  }

  @override
  String visitSTR(STR i, [void _]) {
    return visitSingleDataTransfer('str', i);
  }

  @override
  String visitLDR(LDR i, [void _]) {
    return visitSingleDataTransfer('ldr', i);
  }

  @override
  String visitLDRH(LDRH i, [void _]) {
    return 'ldr${visitCondition(i.condition)}h';
  }

  @override
  String visitLDRSB(LDRSB i, [void _]) {
    return 'ldr${visitCondition(i.condition)}h';
  }

  @override
  String visitLDRSH(LDRSH i, [void _]) {
    return 'ldr${visitCondition(i.condition)}sh';
  }

  @override
  String visitSTRH(STRH i, [void _]) {
    return 'str${visitCondition(i.condition)}h';
  }

  @protected
  String visitBlockDataTransfer(
    String mnemonic,
    BlockDataTransferArmInstruction i,
  ) {
    String addressingMode;
    if (i.addOffsetBeforeTransfer) {
      // P = 1
      if (i.addOffsetToBase) {
        addressingMode = 'ib';
      } else {
        // U = 0
        addressingMode = 'db';
      }
    } else {
      // P = 0
      if (i.addOffsetToBase) {
        // U = 1
        addressingMode = 'ia';
      } else {
        // U = 0
        addressingMode = 'da';
      }
    }
    return '$mnemonic${visitCondition(i.condition)}$addressingMode';
  }

  @override
  String visitLDM(LDM i, [void _]) {
    return visitBlockDataTransfer('ldm', i);
  }

  @override
  String visitSTM(STM i, [void _]) {
    return visitBlockDataTransfer('stm', i);
  }

  @override
  String visitSWP(SWP i, [void _]) {
    final b = i.transferByte ? 'b' : '';
    return 'swp${visitCondition(i.condition)}$b';
  }

  @override
  String visitMLA(MLA i, [void _]) {
    return visitMaySetConditionCodes('mla', i);
  }

  @override
  String visitMUL(MUL i, [void _]) {
    return visitMaySetConditionCodes('mul', i);
  }

  @override
  String visitSMLAL(SMLAL i, [void _]) {
    return visitMaySetConditionCodes('smlal', i);
  }

  @override
  String visitSMULL(SMULL i, [void _]) {
    return visitMaySetConditionCodes('smull', i);
  }

  @override
  String visitUMLAL(UMLAL i, [void _]) {
    return visitMaySetConditionCodes('umlal', i);
  }

  @override
  String visitUMULL(UMULL i, [void _]) {
    return visitMaySetConditionCodes('umull', i);
  }

  @override
  String visitB(B i, [void _]) {
    return 'b${visitCondition(i.condition)}';
  }

  @override
  String visitBL(BL i, [void _]) {
    return 'bl${visitCondition(i.condition)}';
  }

  @override
  String visitBX(BX i, [void _]) {
    return 'bx${visitCondition(i.condition)}';
  }

  @override
  String visitMRS(MRS i, [void _]) {
    return 'mrs${visitCondition(i.condition)}';
  }

  @override
  String visitMSR(MSR i, [void _]) {
    return 'msr${visitCondition(i.condition)}';
  }

  @override
  String visitSWI(SWI i, [void _]) {
    return 'swi${visitCondition(i.condition)}';
  }
}

/// Given an [ArmInstruction], outputs disassembled (human-readable) assembly.
///
/// The goal is to output as close as possible to the ARM assembly instructions
/// used to generate the encoded instructions, with the exceptions of aliases
/// and ambiguities.
@immutable
@sealed
class ArmInstructionPrinter extends SuperArmInstructionVisitor<String, void> {
  final ArmInstructionVisitor<String, void> _mnemonicPrinter;

  /// Creates a new instruction printer.
  ///
  /// If not specified [mnemonicPrinter] defaults to [ArmMnemonicPrinter], which
  /// is used to output the first part of the instruction (the name and various
  /// bit-flip codes that make up the first segment).
  const ArmInstructionPrinter({
    ArmInstructionVisitor<String, void> mnemonicPrinter,
  }) : _mnemonicPrinter = mnemonicPrinter ?? const ArmMnemonicPrinter();

  @protected
  String visitImmediate(Immediate<Integral<void>> immediate) {
    return '${immediate.value}';
  }

  @protected
  String visitRegister(Register<void> register) {
    return 'r${register.index.value}';
  }

  @protected
  String visitShiftedRegisterByRegister(
    ShiftedRegister<Register<void>, Register<void>> register,
  ) {
    final operand = visitRegister(register.operand);
    final typeOf = visitShiftType(register.type);
    final shiftBy = visitRegister(register.by);
    return '$operand, $typeOf $shiftBy';
  }

  @protected
  String visitShiftedRegisterByImmediate(
    ShiftedRegister<Immediate<Integral<void>>, Register<void>> register,
  ) {
    final operand = visitRegister(register.operand);
    final typeOf = visitShiftType(register.type);
    final shiftBy = visitImmediate(register.by);
    return '$operand, $typeOf $shiftBy';
  }

  @protected
  String visitShiftedImmediate(ShiftedImmediate<Integral<void>> immediate) {
    // Immediate values are signified by a leading # symbol. The operand is
    // actually stored in the instruction as an 8-bit value with a 4-bit
    // rotation code. The resultant value is the 8-th bit value rotated right
    // 0-30 bits (twice the rotation code amount).
    //
    // To undo the encoding, we rotate left 0-30 bits.
    final code = immediate.rorShift.value;
    final bits = immediate.immediate.value.value;
    final undo = bits << code;
    return '$undo';
  }

  @protected
  String visitShiftType(ShiftType type) {
    switch (type) {
      case ShiftType.LSL:
        return 'LSL';
      case ShiftType.LSR:
        return 'LSR';
      case ShiftType.ASR:
        return 'ASR';
      case ShiftType.ROR:
        return 'ROR';
      default:
        throw StateError('Unexpected shiftType: $type.');
    }
  }

  @override
  String visitInstruction(
    ArmInstruction i, [
    void _,
  ]) {
    return i.accept(_mnemonicPrinter);
  }

  @override
  String visitDataProcessing(
    DataProcessingArmInstruction i, [
    void _,
  ]) {
    final mnuemonic = super.visitDataProcessing(i);
    final destination = visitRegister(i.destination);
    final register = visitRegister(i.operand1);
    final operand2 = i.operand2.pick(
      (shiftedRegisterByImmediate) => visitShiftedRegisterByImmediate(
        shiftedRegisterByImmediate,
      ),
      (shiftedRegisterByRegister) => visitShiftedRegisterByRegister(
        shiftedRegisterByRegister,
      ),
      (shiftedImmediate) => visitShiftedImmediate(
        shiftedImmediate,
      ),
    );
    return '$mnuemonic $destination,$register,$operand2';
  }

  @override
  String visitDataProcessingVoidReturn(
    DataProcessingArmInstruction i, [
    void _,
  ]) {
    final mnuemonic = super.visitDataProcessing(i);
    final register = visitRegister(i.operand1);
    final operand2 = i.operand2.pick(
      visitShiftedRegisterByImmediate,
      visitShiftedRegisterByRegister,
      visitShiftedImmediate,
    );
    return '$mnuemonic $register,$operand2';
  }

  @override
  String visitBlockDataTransfer(
    BlockDataTransferArmInstruction i, [
    void _,
  ]) {
    final mnuemonic = super.visitBlockDataTransfer(i);
    return '$mnuemonic';
  }

  @override
  String visitSingleDataTransfer(
    SingleDataTransferArmInstruction i, [
    void _,
  ]) {
    final mnuemonic = super.visitSingleDataTransfer(i);
    final b = i.transferByte ? 'b' : '';
    final t = i.forceNonPrivilegedAccess ? 't' : '';
    final d = visitRegister(i.sourceOrDestination);
    final prefix = '$mnuemonic$b$t $d';
    return i.offset.pick(
      (immediate) {
        // 1. An expression which generates an address.
        return '$prefix ${visitImmediate(immediate)}';
      },
      (shiftedRegister) {
        if (i.addOffsetBeforeTransfer) {
          // 2. A pre-indexed addressing specification.
          //   [Rn]
          //   [Rn, expression]{!}
          //   [Rn, {+/-}Rm{,shift}]{!}
          final w = i.writeAddressIntoBase ? '!' : '';
          return '[]$w';
        } else {
          // 3. A post-indexed addressing specification.
          //   [Rn], expression
          //   [Rn], +/-Rm{, shift}
          return '[]';
        }
      },
    );
  }

  @override
  String visitHalfwordDataTransfer(
    HalfwordDataTransferArmInstruction i, [
    void _,
  ]) {
    final mnuemonic = super.visitHalfwordDataTransfer(i);
    return '$mnuemonic';
  }

  @override
  String visitMultiply(
    MultiplyArmInstruction i, [
    void _,
  ]) {
    final mnuemonic = super.visitMultiply(i);
    final d = visitRegister(i.destination);
    final m = visitRegister(i.operand1);
    final s = visitRegister(i.operand2);
    return '$mnuemonic $d,$m,$s';
  }

  @override
  String visitMultiplyLong(
    MultiplyLongArmInstruction i, [
    void _,
  ]) {
    final mnuemonic = super.visitMultiplyLong(i);
    final h = visitRegister(i.destinationHiBits);
    final l = visitRegister(i.destinationLoBits);
    final m = visitRegister(i.operand1);
    final s = visitRegister(i.operand2);
    return '$mnuemonic $l,$h,$m,$s';
  }

  @override
  String visitMRS(
    MRS i, [
    void _,
  ]) {
    final mnuemonic = super.visitPsrTransfer(i);
    final d = visitRegister(i.destination);
    final psr = i.useSPSR ? 'spsr' : 'cpsr';
    return '$mnuemonic $d,$psr';
  }

  @override
  String visitMSR(
    MSR i, [
    void _,
  ]) {
    final mnuemonic = super.visitPsrTransfer(i);
    final m = i.sourceOrImmediate.pick(
      visitRegister,
      visitShiftedImmediate,
    );
    var psr = i.useSPSR ? 'spsr' : 'cpsr';
    switch (i.writeToField) {
      case MSRWriteField.flag:
        psr = '${psr}_flg';
        break;
      case MSRWriteField.control:
        psr = '${psr}_ctl';
        break;
      default:
        break;
    }
    return '$mnuemonic $psr,$m';
  }

  @override
  String visitSWP(
    SWP i, [
    void _,
  ]) {
    final mnuemonic = super.visitSWP(i);
    return '$mnuemonic';
  }

  @override
  String visitB(
    B i, [
    void _,
  ]) {
    final mnuemonic = super.visitB(i);
    return '$mnuemonic ${i.offset.value}';
  }

  @override
  String visitBL(
    BL i, [
    void _,
  ]) {
    final mnuemonic = super.visitBL(i);
    return '$mnuemonic ${i.offset.value}';
  }

  @override
  String visitBX(
    BX i, [
    void _,
  ]) {
    final mnuemonic = super.visitBX(i);
    final register = visitRegister(i.operand);
    return '$mnuemonic $register';
  }

  @override
  String visitSWI(
    SWI i, [
    void _,
  ]) {
    final mnuemonic = super.visitSWI(i);
    return '$mnuemonic';
  }
}
