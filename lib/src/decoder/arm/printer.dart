import 'package:armv4t/src/decoder/arm/condition.dart';
import 'package:armv4t/src/decoder/arm/instruction.dart';
import 'package:armv4t/src/decoder/common.dart';
import 'package:binary/binary.dart';
import 'package:meta/meta.dart';

/// Given an [ArmInstruction], outputs the mnemonic (human-readable prefix).
@immutable
@sealed
class ArmMnemonicPrinter implements ArmInstructionVisitor<String, void> {
  const ArmMnemonicPrinter();

  @protected
  String visitCondition(Condition c) {
    return c == Condition.al ? '' : c.mnuemonic;
  }

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
  String visitADC(ADCArmInstruction i, [void _]) {
    return visitMaySetConditionCodes('adc', i);
  }

  @override
  String visitADD(ADDArmInstruction i, [void _]) {
    return visitMaySetConditionCodes('add', i);
  }

  @override
  String visitRSB(RSBArmInstruction i, [void _]) {
    return visitMaySetConditionCodes('rsb', i);
  }

  @override
  String visitRSC(RSCArmInstruction i, [void _]) {
    return visitMaySetConditionCodes('rsc', i);
  }

  @override
  String visitSBC(SBCArmInstruction i, [void _]) {
    return visitMaySetConditionCodes('sbc', i);
  }

  @override
  String visitSUB(SUBArmInstruction i, [void _]) {
    return visitMaySetConditionCodes('sub', i);
  }

  @override
  String visitAND(ANDArmInstruction i, [void _]) {
    return visitMaySetConditionCodes('and', i);
  }

  @override
  String visitBIC(BICArmInstruction i, [void _]) {
    return visitMaySetConditionCodes('bic', i);
  }

  @override
  String visitEOR(EORArmInstruction i, [void _]) {
    return visitMaySetConditionCodes('eor', i);
  }

  @override
  String visitMOV(MOVArmInstruction i, [void _]) {
    return visitMaySetConditionCodes('mov', i);
  }

  @override
  String visitMVN(MVNArmInstruction i, [void _]) {
    return visitMaySetConditionCodes('mvn', i);
  }

  @override
  String visitORR(ORRArmInstruction i, [void _]) {
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
  String visitCMN(CMNArmInstruction i, [void _]) {
    return visitDataProcessingWithVoidDestination('cmn', i);
  }

  @override
  String visitCMP(CMPArmInstruction i, [void _]) {
    return visitDataProcessingWithVoidDestination('cmp', i);
  }

  @override
  String visitTEQ(TEQArmInstruction i, [void _]) {
    return visitDataProcessingWithVoidDestination('teq', i);
  }

  @override
  String visitTST(TSTArmInstruction i, [void _]) {
    return visitDataProcessingWithVoidDestination('tst', i);
  }

  @protected
  String visitSingleDataTransfer(
    String prefix,
    SingleDataTransferArmInstruction i, [
    String suffix = '',
  ]) {
    final b = i.transferByte ? 'b' : '';
    // T is present if the W-bit will be set in a post-indexed instruction,
    // forcing non-privileged mode for the transfer cycle. T is not allowed when
    // a pre-indexed addressing mode is specified or implied.
    String t = '';
    if (!i.addOffsetBeforeTransfer) {
      if (i.writeAddressIntoBaseOrForceNonPrivilegedAccess) {
        t = 't';
      }
    }
    return '$prefix${visitCondition(i.condition)}$b$t$suffix';
  }

  @override
  String visitSTR(STRArmInstruction i, [void _]) {
    return visitSingleDataTransfer('str', i);
  }

  @override
  String visitLDR(LDRArmInstruction i, [void _]) {
    return visitSingleDataTransfer('ldr', i);
  }

  @override
  String visitLDRH(LDRHArmInstruction i, [void _]) {
    return 'ldr${visitCondition(i.condition)}h';
  }

  @override
  String visitLDRSB(LDRSBArmInstruction i, [void _]) {
    return 'ldr${visitCondition(i.condition)}sb';
  }

  @override
  String visitLDRSH(LDRSHArmInstruction i, [void _]) {
    return 'ldr${visitCondition(i.condition)}sh';
  }

  @override
  String visitSTRH(STRHArmInstruction i, [void _]) {
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
  String visitLDM(LDMArmInstruction i, [void _]) {
    return visitBlockDataTransfer('ldm', i);
  }

  @override
  String visitSTM(STMArmInstruction i, [void _]) {
    return visitBlockDataTransfer('stm', i);
  }

  @override
  String visitSWP(SWPArmInstruction i, [void _]) {
    final b = i.transferByte ? 'b' : '';
    return 'swp${visitCondition(i.condition)}$b';
  }

  @override
  String visitMLA(MLAArmInstruction i, [void _]) {
    return visitMaySetConditionCodes('mla', i);
  }

  @override
  String visitMUL(MULArmInstruction i, [void _]) {
    return visitMaySetConditionCodes('mul', i);
  }

  @override
  String visitSMLAL(SMLALArmInstruction i, [void _]) {
    return visitMaySetConditionCodes('smlal', i);
  }

  @override
  String visitSMULL(SMULLArmInstruction i, [void _]) {
    return visitMaySetConditionCodes('smull', i);
  }

  @override
  String visitUMLAL(UMLALArmInstruction i, [void _]) {
    return visitMaySetConditionCodes('umlal', i);
  }

  @override
  String visitUMULL(UMULLArmInstruction i, [void _]) {
    return visitMaySetConditionCodes('umull', i);
  }

  @override
  String visitB(BArmInstruction i, [void _]) {
    return 'b${visitCondition(i.condition)}';
  }

  @override
  String visitBL(BLArmInstruction i, [void _]) {
    return 'bl${visitCondition(i.condition)}';
  }

  @override
  String visitBX(BXArmInstruction i, [void _]) {
    return 'bx${visitCondition(i.condition)}';
  }

  @override
  String visitMRS(MRSArmInstruction i, [void _]) {
    return 'mrs${visitCondition(i.condition)}';
  }

  @override
  String visitMSR(MSRArmInstruction i, [void _]) {
    return 'msr${visitCondition(i.condition)}';
  }

  @override
  String visitSWI(SWIArmInstruction i, [void _]) {
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
  final String _delimiter;

  /// Creates a new instruction printer.
  ///
  /// If not specified [mnemonicPrinter] defaults to [ArmMnemonicPrinter], which
  /// is used to output the first part of the instruction (the name and various
  /// bit-flip codes that make up the first segment).
  const ArmInstructionPrinter({
    ArmInstructionVisitor<String, void> mnemonicPrinter,
    String delimiter,
  })  : _mnemonicPrinter = mnemonicPrinter ?? const ArmMnemonicPrinter(),
        _delimiter = delimiter ?? ', ';

  @protected
  String visitComponents(List<String> components) {
    return components.join(_delimiter);
  }

  @protected
  String visitImmediate(Immediate<Integral<void>> immediate) {
    return '${immediate.value.value}';
  }

  @alwaysThrows
  @protected
  String throwInvalidCase(Object any) {
    throw FormatException('Not an expected address or offset: $any');
  }

  @protected
  String visitRegister(Register<void> register) {
    return 'r${register.index.value}';
  }

  @protected
  String visitRegisterList(RegisterList<Register<void>> list) {
    final registers = list.registers.toList()..sort();
    if (registers.isEmpty) {
      return '';
    }
    final output = <String>[];
    final chain = <Register<void>>[];

    void write() {
      assert(chain.isNotEmpty);
      if (chain.length == 1) {
        output.add(visitRegister(chain.first));
      } else {
        output.add(
          '${visitRegister(chain.first)}-${visitRegister(chain.last)}',
        );
      }
      chain.clear();
    }

    for (final register in registers) {
      if (chain.isEmpty) {
        chain.add(register);
      } else if (chain.last.index.value + 1 == register.index.value) {
        chain.add(register);
      } else {
        write();
        chain.add(register);
      }
    }

    if (chain.isNotEmpty) {
      write();
    }

    return output.join(_delimiter);
  }

  @protected
  String visitShiftedRegisterByRegister(
    ShiftedRegister<Register<void>, Register<void>> register,
  ) {
    final operand = visitRegister(register.operand);
    final typeOf = visitShiftType(register.type);
    final shiftBy = visitRegister(register.by);
    return visitComponents([operand, '$typeOf $shiftBy']);
  }

  @protected
  String visitShiftedRegisterByImmediate(
    ShiftedRegister<Immediate<Integral<void>>, Register<void>> register,
  ) {
    final operand = visitRegister(register.operand);
    if (register.type == ShiftType.RRX) {
      return visitComponents([operand, 'rrx']);
    } else if (register.by.value.value == 0) {
      return visitComponents([operand]);
    } else {
      final typeOf = visitShiftType(register.type);
      final shiftBy = visitImmediate(register.by);
      return visitComponents([operand, '$typeOf $shiftBy']);
    }
  }

  @protected
  String visitShiftedImmediate(ShiftedImmediate<Integral<void>> immediate) {
    // Immediate values are signified by a leading # symbol. The operand is
    // actually stored in the instruction as an 8-bit value with a 4-bit
    // rotation code. The resultant value is the 8-th bit value rotated right
    // 0-30 bits (twice the rotation code amount).
    final code = immediate.rorShift.value * 2;
    final bits = Uint32(immediate.immediate.value.value);
    final undo = bits.rotateRightShift(code);
    return '${undo.value}';
  }

  @protected
  String visitShiftType(ShiftType type) {
    switch (type) {
      case ShiftType.LSL:
        return 'lsl';
      case ShiftType.LSR:
        return 'lsr';
      case ShiftType.ASR:
        return 'asr';
      case ShiftType.ROR:
        return 'ror';
      case ShiftType.RRX:
        return 'rrx';
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
      visitShiftedRegisterByImmediate,
      visitShiftedRegisterByRegister,
      visitShiftedImmediate,
    );
    if (i is MOVArmInstruction || i is MVNArmInstruction) {
      return visitComponents(['$mnuemonic $destination', operand2]);
    } else {
      return visitComponents(['$mnuemonic $destination', register, operand2]);
    }
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
    return visitComponents(['$mnuemonic $register', operand2]);
  }

  @override
  String visitBlockDataTransfer(
    BlockDataTransferArmInstruction i, [
    void _,
  ]) {
    // <LDM|STM>{cond}<FD|ED|FA|EA|IA|IB|DA|DB> Rn{!},<Rlist>{^}
    final mnuemonic = super.visitBlockDataTransfer(i);
    final w = i.writeAddressIntoBase ? '!' : '';
    final c = i.loadPsrOrForceUserMode ? '^' : '';
    return visitComponents([
      '$mnuemonic ${visitRegister(i.base)}$w',
      '{${visitRegisterList(i.registerList)}}$c',
    ]);
  }

  @override
  String visitSingleDataTransfer(
    SingleDataTransferArmInstruction i, [
    void _,
  ]) {
    final mnuemonic = super.visitSingleDataTransfer(i);
    final d = visitRegister(i.sourceOrDestination);
    // <LDR|STR>{cond}{B}{T} Rd, <Address>
    //   Rd = Register (Destination)
    //   Rn, Rm = Registers. If Rn is R15, then the assembler will subtract 8
    //            from the offset value to allow for pipelining. In this case
    //            write-back should not be specified.
    //
    //   <Address> can be:
    //     1. <expression>: An expression which generates an address; the
    //                      assember will attempt to generate an instruction
    //                      using the PC as a base and a corrected immediate
    //                      offset to address the location given by evaluating
    //                      the expression. This will be a PC-relative,
    //                      pre-indexed address.
    //
    //     2. A pre-indexed addressing specification:
    //       A. [Rn] (Offset of zero)
    //       B. [Rn, <#expression>]{!} (Offset of <expression> bytes)
    //       C. [Rn, {+/-}Rm{,<shift>}]{!} (Offset of +/- contents of index
    //                                      register, shifted by <shift>).
    //
    //     3. A post-indexed addressing specification:
    //       A. [Rn], <#expression> (Offset of <expression> bytes)
    //       B. [Rn], {+/-}Rm{, <shift>} (Offset of +/- contents of index
    //                                    register, shifted by <shift>).
    //
    //    <shift> is a general shift operation, by an immediate value
    //    {!} writes back the base register if present
    String address;
    if (i.base.isProgramCounter) {
      // Case 1.
      address = i.offset.pick(
        visitImmediate,
        throwInvalidCase,
      );
    } else {
      final u = i.addOffsetToBase ? '' : '-';
      if (i.addOffsetBeforeTransfer) {
        // Case 2 | P = 1 (Pre-indexed)
        var offsetOf0 = false;
        final operand = i.offset.pick(
          (immediate) {
            if (immediate.value.value == 0) {
              offsetOf0 = true;
            }
            return visitImmediate(immediate);
          },
          visitShiftedRegisterByImmediate,
        );
        final w = i.writeAddressIntoBaseOrForceNonPrivilegedAccess ? '!' : '';
        if (offsetOf0) {
          address = '[${visitRegister(i.base)}]$w';
        } else {
          address = '[${visitComponents([
            visitRegister(i.base),
            '$u$operand',
          ])}]$w';
        }
      } else {
        // Case 3 | P = 0 (Post-indexed)
        final operand = i.offset.pick(
          visitImmediate,
          visitShiftedRegisterByImmediate,
        );
        address = visitComponents([
          '[${visitRegister(i.base)}]',
          '$u$operand',
        ]);
      }
    }
    return visitComponents(['$mnuemonic $d', address]);
  }

  @override
  String visitHalfwordDataTransfer(
    HalfwordDataTransferArmInstruction i, [
    void _,
  ]) {
    final mnuemonic = super.visitHalfwordDataTransfer(i);
    final d = visitRegister(i.sourceOrDestination);
    final u = i.addOffsetToBase ? '' : '-';
    // Similar to "visitSingleDataTransfer", but a bit simpler.
    String address = '';
    if (i.base.isProgramCounter) {
      // Case 1.
      address = i.offset.pick(
        throwInvalidCase,
        visitImmediate,
      );
    } else {
      if (i.addOffsetBeforeTransfer) {
        // Case 2 | P = 1 (Pre-indexed)
        var offsetOf0 = false;
        final operand = i.offset.pick(
          visitRegister,
          (immediate) {
            if (immediate.value.value == 0) {
              offsetOf0 = true;
            }
            return visitImmediate(immediate);
          },
        );
        final w = i.writeAddressIntoBaseOrForceNonPrivilegedAccess ? '!' : '';
        if (offsetOf0) {
          address = '[${visitRegister(i.base)}]$w';
        } else {
          address = '[${visitComponents([
            visitRegister(i.base),
            '$u$operand',
          ])}]$w';
        }
      } else {
        // Case 3 | P = 0 (Post-indexed)
        final operand = i.offset.pick(
          visitRegister,
          visitImmediate,
        );
        address = visitComponents([
          '[${visitRegister(i.base)}]',
          '$u$operand',
        ]);
      }
    }
    return visitComponents(['$mnuemonic $d', address]);
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
    return visitComponents(['$mnuemonic $d', m, s]);
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
    return visitComponents(['$mnuemonic $l', h, m, s]);
  }

  @override
  String visitMRS(
    MRSArmInstruction i, [
    void _,
  ]) {
    // MRS - transfer PSR contents to a register
    final mnuemonic = super.visitPsrTransfer(i);
    final d = visitRegister(i.destination);
    final psr = i.useSPSR ? 'spsr' : 'cpsr';
    return visitComponents(['$mnuemonic $d', psr]);
  }

  @override
  String visitMSR(
    MSRArmInstruction i, [
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
    return visitComponents(['$mnuemonic $psr', m]);
  }

  @override
  String visitSWP(
    SWPArmInstruction i, [
    void _,
  ]) {
    final mnuemonic = super.visitSWP(i);
    return visitComponents([
      '$mnuemonic ${visitRegister(i.destination)}',
      visitRegister(i.source),
      '[${visitRegister(i.base)}]',
    ]);
  }

  @override
  String visitB(
    BArmInstruction i, [
    void _,
  ]) {
    final mnuemonic = super.visitB(i);
    return '$mnuemonic ${i.offset.value}';
  }

  @override
  String visitBL(
    BLArmInstruction i, [
    void _,
  ]) {
    final mnuemonic = super.visitBL(i);
    return '$mnuemonic ${i.offset.value}';
  }

  @override
  String visitBX(
    BXArmInstruction i, [
    void _,
  ]) {
    final mnuemonic = super.visitBX(i);
    final register = visitRegister(i.operand);
    return '$mnuemonic $register';
  }

  @override
  String visitSWI(
    SWIArmInstruction i, [
    void _,
  ]) {
    final mnuemonic = super.visitSWI(i);
    return '$mnuemonic ${i.comment.value.value}';
  }
}
