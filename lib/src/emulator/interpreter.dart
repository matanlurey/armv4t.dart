import 'dart:typed_data';

import 'package:armv4t/decode.dart';
import 'package:armv4t/src/common/binary.dart';
import 'package:armv4t/src/decoder/arm/instruction.dart';
import 'package:armv4t/src/emulator/condition.dart';
import 'package:armv4t/src/emulator/operand.dart';
import 'package:armv4t/src/processor.dart';
import 'package:binary/binary.dart';
import 'package:meta/meta.dart';

/// Provides a virtual dispatch-based interpretation of [ArmInstruction]s.
@sealed
abstract class ArmInterpreter {
  factory ArmInterpreter(Arm7Processor cpu) = _ArmInterpreter;

  /// Executes [instruction] relative to current [cpu].
  void execute(ArmInstruction instruction);

  /// Implement to provide access to the processor.
  @protected
  Arm7Processor get cpu;
}

class _ArmInterpreter
    /**/ extends ArmInstructionVisitor<void, void>
    /**/ with
        ConditionEvaluator,
        OperandEvaluator
    /**/ implements
        ArmInterpreter {
  @override
  final Arm7Processor cpu;

  _ArmInterpreter(this.cpu);

  @override
  void execute(ArmInstruction instruction) {
    if (evaluateCondition(instruction.condition)) {
      instruction.accept(this);
    }
  }

  // SHARED / COMMON

  Uint32 _readRegister(Register r) => cpu[r.index.value];

  Uint32 _writeRegister(Register r, Uint32 v) => cpu[r.index.value] = v;

  Uint32 _visitOperand2(
    Or3<
            ShiftedRegister<Immediate<Uint4>, RegisterAny>,
            ShiftedRegister<RegisterNotPC, RegisterAny>,
            ShiftedImmediate<Uint8>>
        operand2,
  ) {
    return operand2.pick(
      evaluateShiftRegister,
      evaluateRegisters,
      evaluateImmediate,
    );
  }

  void _writeToAllFlags(
    Uint32List result, {
    @required bool op1Signed,
    @required bool op2Signed,
  }) {
    cpu.cpsr = cpu.cpsr.update(
      // V (If + and + is -, or - and - is +)
      isOverflow: result.hadOverflow(op1Signed, op2Signed),

      // C (Discard MSB)
      isCarry: result.isCarry,

      // Z (If RES == 0)
      isZero: result.isZero,

      // N (If MSB == 1)
      isSigned: result.isSigned,
    );
  }

  // DATA PROCESSING

  // Arithmetic

  Uint32 _addWithCarry(
    Uint32 op1,
    Uint32 op2, {
    int carryIn = 0,
    bool setFlags = false,
  }) {
    var sum = op1 + op2;
    if (carryIn != 0) {
      sum = sum.add64(carryIn.hiLo());
    }
    if (setFlags) {
      _writeToAllFlags(
        sum,
        op1Signed: op1.msb,
        op2Signed: op2.msb,
      );
    }
    return sum.toUint32();
  }

  @override
  void visitADD(ADDArmInstruction i, [void _]) {
    //  rD = operand1 + operand2
    final op1 = _readRegister(i.operand1);
    final op2 = _visitOperand2(i.operand2);
    final res = _addWithCarry(
      op1,
      op2,
      setFlags: i.setConditionCodes && !i.destination.isProgramCounter,
    );
    _writeRegister(i.destination, res);
  }

  @override
  void visitADC(ADCArmInstruction i, [void _]) {
    // rD = operand1 + operand2 + carry
    final op1 = _readRegister(i.operand1);
    final op2 = _visitOperand2(i.operand2);
    final res = _addWithCarry(
      op1,
      op2,
      carryIn: cpu.cpsr.isCarry ? 1 : 0,
      setFlags: i.setConditionCodes && !i.destination.isProgramCounter,
    );
    _writeRegister(i.destination, res);
  }

  @override
  void visitSUB(SUBArmInstruction i, [void _]) {
    // rD = operand1 - operand2
    final op1 = _readRegister(i.operand1);
    final op2 = ~_visitOperand2(i.operand2);
    final res = _addWithCarry(
      op1,
      op2,
      setFlags: i.setConditionCodes && !i.destination.isProgramCounter,
    );
    _writeRegister(i.destination, res);
  }

  @override
  void visitSBC(SBCArmInstruction i, [void _]) {
    // rD = operand1 - operand2 + carry - 1
    final op1 = _readRegister(i.operand1);
    final op2 = ~_visitOperand2(i.operand2);
    final res = _addWithCarry(
      op1,
      op2,
      carryIn: cpu.cpsr.isCarry ? 0 : -1,
      setFlags: i.setConditionCodes && !i.destination.isProgramCounter,
    );
    _writeRegister(i.destination, res);
  }

  @override
  void visitRSB(RSBArmInstruction i, [void _]) {
    // rD = operand2 - operand1
    final op1 = ~_readRegister(i.operand1);
    final op2 = _visitOperand2(i.operand2);
    final res = _addWithCarry(
      op2,
      op1,
      setFlags: i.setConditionCodes && !i.destination.isProgramCounter,
    );
    _writeRegister(i.destination, res);
  }

  @override
  void visitRSC(RSCArmInstruction i, [void _]) {
    // rD = operand2 - operand1 + carry - 1
    final op1 = ~_readRegister(i.operand1);
    final op2 = _visitOperand2(i.operand2);
    final res = _addWithCarry(
      op2,
      op1,
      carryIn: cpu.cpsr.isCarry ? 0 : -1,
      setFlags: i.setConditionCodes && !i.destination.isProgramCounter,
    );
    _writeRegister(i.destination, res);
  }

  @override
  void visitAND(ANDArmInstruction i, [void _]) {
    throw UnimplementedError();
  }

  @override
  void visitB(BArmInstruction i, [void _]) {
    throw UnimplementedError();
  }

  @override
  void visitBIC(BICArmInstruction i, [void _]) {
    throw UnimplementedError();
  }

  @override
  void visitBL(BLArmInstruction i, [void _]) {
    throw UnimplementedError();
  }

  @override
  void visitBX(BXArmInstruction i, [void _]) {
    throw UnimplementedError();
  }

  @override
  void visitCMN(CMNArmInstruction i, [void _]) {
    throw UnimplementedError();
  }

  @override
  void visitCMP(CMPArmInstruction i, [void _]) {
    throw UnimplementedError();
  }

  @override
  void visitEOR(EORArmInstruction i, [void _]) {
    throw UnimplementedError();
  }

  @override
  void visitLDM(LDMArmInstruction i, [void _]) {
    throw UnimplementedError();
  }

  @override
  void visitLDR(LDRArmInstruction i, [void _]) {
    throw UnimplementedError();
  }

  @override
  void visitLDRH(LDRHArmInstruction i, [void _]) {
    throw UnimplementedError();
  }

  @override
  void visitLDRSB(LDRSBArmInstruction i, [void _]) {
    throw UnimplementedError();
  }

  @override
  void visitLDRSH(LDRSHArmInstruction i, [void _]) {
    throw UnimplementedError();
  }

  @override
  void visitMLA(MLAArmInstruction i, [void _]) {
    throw UnimplementedError();
  }

  @override
  void visitMOV(MOVArmInstruction i, [void _]) {
    throw UnimplementedError();
  }

  @override
  void visitMRS(MRSArmInstruction i, [void _]) {
    throw UnimplementedError();
  }

  @override
  void visitMSR(MSRArmInstruction i, [void _]) {
    throw UnimplementedError();
  }

  @override
  void visitMUL(MULArmInstruction i, [void _]) {
    throw UnimplementedError();
  }

  @override
  void visitMVN(MVNArmInstruction i, [void _]) {
    throw UnimplementedError();
  }

  @override
  void visitORR(ORRArmInstruction i, [void _]) {
    throw UnimplementedError();
  }

  @override
  void visitSMLAL(SMLALArmInstruction i, [void _]) {
    throw UnimplementedError();
  }

  @override
  void visitSMULL(SMULLArmInstruction i, [void _]) {
    throw UnimplementedError();
  }

  @override
  void visitSTM(STMArmInstruction i, [void _]) {
    throw UnimplementedError();
  }

  @override
  void visitSTR(STRArmInstruction i, [void _]) {
    throw UnimplementedError();
  }

  @override
  void visitSTRH(STRHArmInstruction i, [void _]) {
    throw UnimplementedError();
  }

  @override
  void visitSWI(SWIArmInstruction i, [void _]) {
    throw UnimplementedError();
  }

  @override
  void visitSWP(SWPArmInstruction i, [void _]) {
    throw UnimplementedError();
  }

  @override
  void visitTEQ(TEQArmInstruction i, [void _]) {
    throw UnimplementedError();
  }

  @override
  void visitTST(TSTArmInstruction i, [void _]) {
    throw UnimplementedError();
  }

  @override
  void visitUMLAL(UMLALArmInstruction i, [void _]) {
    throw UnimplementedError();
  }

  @override
  void visitUMULL(UMULLArmInstruction i, [void _]) {
    throw UnimplementedError();
  }
}
