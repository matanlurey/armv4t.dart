import 'package:meta/meta.dart';

import 'format.dart';

part 'instruction/branch/b.dart';
part 'instruction/branch/bcc.dart';
part 'instruction/branch/bcs.dart';
part 'instruction/branch/beq.dart';
part 'instruction/branch/bge.dart';
part 'instruction/branch/bgt.dart';
part 'instruction/branch/bhi.dart';
part 'instruction/branch/bl.dart';
part 'instruction/branch/ble.dart';
part 'instruction/branch/bls.dart';
part 'instruction/branch/blt.dart';
part 'instruction/branch/bmi.dart';
part 'instruction/branch/bne.dart';
part 'instruction/branch/bpl.dart';
part 'instruction/branch/bvc.dart';
part 'instruction/branch/bvs.dart';
part 'instruction/branch/bx.dart';
part 'instruction/coproccess/cdp.dart';
part 'instruction/coproccess/ldc.dart';
part 'instruction/coproccess/mcr.dart';
part 'instruction/coproccess/mrc.dart';
part 'instruction/coproccess/stc.dart';
part 'instruction/data/ldmia.dart';
part 'instruction/data/ldr.dart';
part 'instruction/data/ldrb.dart';
part 'instruction/data/ldrh.dart';
part 'instruction/data/ldsh.dart';
part 'instruction/data/ldsb.dart';
part 'instruction/data/mov.dart';
part 'instruction/data/mvn.dart';
part 'instruction/data/stmia.dart';
part 'instruction/data/str.dart';
part 'instruction/data/strb.dart';
part 'instruction/data/strh.dart';
part 'instruction/logic/and.dart';
part 'instruction/logic/bic.dart';
part 'instruction/logic/cmn.dart';
part 'instruction/logic/cmp.dart';
part 'instruction/logic/eor.dart';
part 'instruction/logic/neg.dart';
part 'instruction/logic/orr.dart';
part 'instruction/logic/tst.dart';
part 'instruction/math/adc.dart';
part 'instruction/math/add.dart';
part 'instruction/math/mul.dart';
part 'instruction/math/rsb.dart';
part 'instruction/math/rsc.dart';
part 'instruction/math/sbc.dart';
part 'instruction/math/sub.dart';
part 'instruction/misc/pop.dart';
part 'instruction/misc/push.dart';
part 'instruction/misc/swi.dart';
part 'instruction/shift/asr.dart';
part 'instruction/shift/lsl.dart';
part 'instruction/shift/lsr.dart';
part 'instruction/shift/ror.dart';

/// An **internal** representation of a decoded `THUMB` instruction.
abstract class ThumbInstruction {
  const ThumbInstruction._();
}

/// Further decodes a [ThumbInstructionSet] into a [ThumbInstruction].
class Decoder implements ThumbInstructionSetVisitor<ThumbInstruction, void> {
  @alwaysThrows
  // ignore: prefer_void_to_null
  static Null _unrecognizedOpcode(int opcode) {
    throw StateError('Unrecognized opcode: $opcode');
  }

  @override
  ThumbInstruction visitALUOperation(
    ALUOperation set, [
    void _,
  ]) {
    switch (set.opcode) {
      case 0x0:
        return MOV();
      case 0x1:
        return EOR();
      case 0x2:
        return LSL();
      case 0x3:
        return LSR();
      case 0x4:
        return ASR();
      case 0x5:
        return ADC();
      case 0x6:
        return SBC();
      case 0x7:
        return ROR();
      case 0x8:
        return TST();
      case 0x9:
        return NEG();
      case 0xA:
        return CMP();
      case 0xB:
        return CMN();
      case 0xC:
        return ORR();
      case 0xD:
        return MUL();
      case 0xE:
        return BIC();
      case 0xF:
        return MVN();
      default:
        return _unrecognizedOpcode(set.opcode);
    }
  }

  @override
  ThumbInstruction visitAddAndSubtract(
    AddAndSubtract set, [
    void _,
  ]) {
    switch (set.opcode) {
      case 0x0:
        return ADD();
      case 0x1:
        return ADD();
      case 0x2:
        return SUB();
      case 0x3:
        return SUB();
      default:
        return _unrecognizedOpcode(set.opcode);
    }
  }

  @override
  ThumbInstruction visitAddOffsetToStackPointer(
    AddOffsetToStackPointer set, [
    void _,
  ]) {
    switch (set.s) {
      case 0x0:
        return ADD();
      case 0x1:
        return ADD();
      default:
        throw StateError('Invalid S: ${set.s}');
    }
  }

  @override
  ThumbInstruction visitConditionalBranch(
    ConditionalBranch set, [
    void _,
  ]) {
    switch (set.condition) {
      case 0x0:
        return BEQ();
      case 0x1:
        return BNE();
      case 0x2:
        return BCS();
      case 0x3:
        return BCC();
      case 0x4:
        return BMI();
      case 0x5:
        return BPL();
      case 0x6:
        return BVS();
      case 0x7:
        return BVC();
      case 0x8:
        return BHI();
      case 0x9:
        return BLS();
      case 0xA:
        return BGE();
      case 0xB:
        return BLT();
      case 0xC:
        return BGT();
      case 0xD:
        return BLE();
      default:
        throw StateError('Invalid Cond: ${set.condition}');
    }
  }

  @override
  ThumbInstruction visitHighRegisterOperationsAndBranchExchange(
    HighRegisterOperationsAndBranchExchange set, [
    void _,
  ]) {
    switch (set.opcode) {
      case 0x0:
        return ADD();
      case 0x1:
        return ADD();
      case 0x2:
        return ADD();
      case 0x3:
        return CMP();
      case 0x4:
        return CMP();
      case 0x5:
        return CMP();
      case 0x6:
        return MOV();
      case 0x7:
        return MOV();
      case 0x8:
        return MOV();
      case 0x9:
        return BX();
      case 0xA:
        return BX();
      default:
        return _unrecognizedOpcode(set.opcode);
    }
  }

  @override
  ThumbInstruction visitLoadAddress(
    LoadAddress set, [
    void _,
  ]) {
    switch (set.sp) {
      case 0x0:
        return ADD();
      case 0x1:
        return ADD();
      default:
        throw StateError('Invalid SP: ${set.sp}');
    }
  }

  @override
  ThumbInstruction visitLoadAndStoreHalfWord(
    LoadAndStoreHalfWord set, [
    void _,
  ]) {
    switch (set.l) {
      case 0x0:
        return STRH();
      case 0x1:
        return LDRH();
      default:
        throw StateError('Invalid L: ${set.l}');
    }
  }

  @override
  ThumbInstruction visitLoadAndStoreSignExtendedByteAndHalfWord(
    LoadAndStoreSignExtendedByteAndHalfWord set, [
    void _,
  ]) {
    if (set.s == 0) {
      if (set.h == 0) {
        return STRH();
      } else if (set.h == 1) {
        return LDRH();
      }
    } else if (set.s == 1) {
      if (set.h == 0) {
        return LDSB();
      } else if (set.h == 1) {
        return LDSH();
      }
    }
    throw StateError('Invalid S or H: ${set.s}, ${set.h}');
  }

  @override
  ThumbInstruction visitLoadAndStoreWithImmediateOffset(
    LoadAndStoreWithImmediateOffset set, [
    void _,
  ]) {
    if (set.l == 0) {
      if (set.b == 0) {
        return STR();
      } else if (set.b == 1) {
        return LDR();
      }
    } else if (set.l == 1) {
      if (set.b == 0) {
        return STRB();
      } else if (set.b == 1) {
        return LDRB();
      }
    }
    throw StateError('Invalid L or B: ${set.l}, ${set.b}');
  }

  @override
  ThumbInstruction visitLoadAndStoreWithRelativeOffset(
    LoadAndStoreWithRelativeOffset set, [
    void _,
  ]) {
    if (set.l == 0) {
      if (set.b == 0) {
        return STR();
      } else if (set.b == 1) {
        return STRB();
      }
    } else if (set.l == 1) {
      if (set.b == 0) {
        return LDR();
      } else if (set.b == 1) {
        return LDRB();
      }
    }
    throw StateError('Invalid L or B: ${set.l}, ${set.b}');
  }

  @override
  ThumbInstruction visitLongBranchWithLink(
    LongBranchWithLink set, [
    void _,
  ]) {
    switch (set.h) {
      case 0:
        return BL();
      case 1:
        // TODO: Figure out how to cleanly implement this:
        // - visitLongBranchWithLink returns List<ThumbInstruction>
        // - visitLongBranchWithLink where H = 1 returns a "Psuedo" instruction.
        //   (e.g. something like BL_MultiInstruction?)
        // - visitLongBranchWithLink returns a special Marker instruction that
        //   interpreters/compilers know to further splice into multiple
        //   instructions.
        throw UnimplementedError();
      default:
        throw StateError('Invalid H: ${set.h}');
    }
  }

  @override
  ThumbInstruction visitMoveCompareAddAndSubtractImmediate(
    MoveCompareAddAndSubtractImmediate set, [
    void _,
  ]) {
    switch (set.opcode) {
      case 0x0:
        return MOV();
      case 0x1:
        return CMP();
      case 0x2:
        return ADD();
      case 0x3:
        return SUB();
      default:
        return _unrecognizedOpcode(set.opcode);
    }
  }

  @override
  ThumbInstruction visitMoveShiftedRegister(
    MoveShiftedRegister set, [
    void _,
  ]) {
    switch (set.opcode) {
      case 0x0:
        return LSL();
      case 0x1:
        return LSR();
      case 0x2:
        return ASR();
      default:
        return _unrecognizedOpcode(set.opcode);
    }
  }

  @override
  ThumbInstruction visitMultipleLoadAndStore(
    MultipleLoadAndStore set, [
    void _,
  ]) {
    switch (set.l) {
      case 0x0:
        return STMIA();
      case 0x1:
        return LDMIA();
      default:
        throw StateError('Invalid L: ${set.l}');
    }
  }

  @override
  ThumbInstruction visitPCRelativeLoad(
    PCRelativeLoad set, [
    void _,
  ]) {
    return LDR();
  }

  @override
  ThumbInstruction visitPushAndPopRegisters(
    PushAndPopRegisters set, [
    void _,
  ]) {
    if (set.l == 0) {
      if (set.r == 0) {
        return PUSH();
      } else if (set.r == 1) {
        return PUSH();
      }
    } else if (set.l == 1) {
      if (set.r == 0) {
        return POP();
      } else if (set.r == 1) {
        return POP();
      }
    }
    throw StateError('Invalid L or R: ${set.l}, ${set.r}');
  }

  @override
  ThumbInstruction visitSPRelativeLoadAndStore(
    SPRelativeLoadAndStore set, [
    void _,
  ]) {
    switch (set.l) {
      case 0x0:
        return STR();
      case 0x1:
        return LDR();
      default:
        throw StateError('Invalid L: ${set.l}');
    }
  }

  @override
  ThumbInstruction visitSoftwareInterrupt(
    SoftwareInterrupt set, [
    void _,
  ]) {
    return SWI();
  }

  @override
  ThumbInstruction visitUnconditionalBranch(
    UnconditionalBranch set, [
    void _,
  ]) {
    return B();
  }
}
