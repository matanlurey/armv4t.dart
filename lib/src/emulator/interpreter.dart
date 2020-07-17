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
  ///
  /// > NOTE: [ArmInstruction.condition] must evaluate to `true` for the [cpu].
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

  Uint32 _subWithCarry(
    Uint32 op1,
    Uint32 op2, {
    int carryIn = 0,
    bool setFlags = false,
  }) {
    var sum = op1 - op2;
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
  void visitSUB(SUBArmInstruction i, [void _]) {
    // rD = operand1 - operand2
    final op1 = _readRegister(i.operand1);
    final op2 = _visitOperand2(i.operand2);
    final res = _subWithCarry(
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
    final op2 = _visitOperand2(i.operand2);
    final res = _subWithCarry(
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
    final op1 = _readRegister(i.operand1);
    final op2 = _visitOperand2(i.operand2);
    final res = _subWithCarry(
      op2,
      op1,
      setFlags: i.setConditionCodes && !i.destination.isProgramCounter,
    );
    _writeRegister(i.destination, res);
  }

  @override
  void visitRSC(RSCArmInstruction i, [void _]) {
    // rD = operand2 - operand1 + carry - 1
    final op1 = _readRegister(i.operand1);
    final op2 = _visitOperand2(i.operand2);
    final res = _subWithCarry(
      op2,
      op1,
      carryIn: cpu.cpsr.isCarry ? 0 : -1,
      setFlags: i.setConditionCodes && !i.destination.isProgramCounter,
    );
    _writeRegister(i.destination, res);
  }

  void _writeToCZN(Uint32List result) {
    cpu.cpsr = cpu.cpsr.update(
      // C (Carry Flag of Shift Operation, Ignored if LSL #0 or Rs=00h)
      //
      // We don't update it here though, it does during shifting.

      // Z (If RES == 0)
      isZero: result.isZero,

      // N (If MSB == 1)
      isSigned: result.isSigned,
    );
  }

  @override
  void visitAND(ANDArmInstruction i, [void _]) {
    // rD = operand1 AND operand2
    final op1 = _readRegister(i.operand1);
    final op2 = _visitOperand2(i.operand2);
    final res = op1 & op2;
    if (i.setConditionCodes && !i.destination.isProgramCounter) {
      _writeToCZN(res.hiLo());
    }
    _writeRegister(i.destination, res);
  }

  @override
  void visitEOR(EORArmInstruction i, [void _]) {
    // rD = operand1 XOR operand2
    final op1 = _readRegister(i.operand1);
    final op2 = _visitOperand2(i.operand2);
    final res = op1 ^ op2;
    if (i.setConditionCodes && !i.destination.isProgramCounter) {
      _writeToCZN(res.hiLo());
    }
    _writeRegister(i.destination, res);
  }

  @override
  void visitORR(ORRArmInstruction i, [void _]) {
    // rD = operand1 OR operand2
    final op1 = _readRegister(i.operand1);
    final op2 = _visitOperand2(i.operand2);
    final res = op1 | op2;
    if (i.setConditionCodes && !i.destination.isProgramCounter) {
      _writeToCZN(res.hiLo());
    }
    _writeRegister(i.destination, res);
  }

  @override
  void visitBIC(BICArmInstruction i, [void _]) {
    // rD = operand1 AND NOT operand2
    final op1 = _readRegister(i.operand1);
    final op2 = _visitOperand2(i.operand2);
    final res = op1 & ~op2;
    if (i.setConditionCodes && !i.destination.isProgramCounter) {
      _writeToCZN(res.hiLo());
    }
    _writeRegister(i.destination, res);
  }

  @override
  void visitMOV(MOVArmInstruction i, [void _]) {
    // rD = operand2
    final op2 = _visitOperand2(i.operand2);
    final res = op2;
    if (i.setConditionCodes && !i.destination.isProgramCounter) {
      _writeToCZN(res.hiLo());
    }
    _writeRegister(i.destination, res);
  }

  @override
  void visitMVN(MVNArmInstruction i, [void _]) {
    // rD = NOT operand2
    final op2 = _visitOperand2(i.operand2);
    final res = ~op2;
    if (i.setConditionCodes && !i.destination.isProgramCounter) {
      _writeToCZN(res.hiLo());
    }
    _writeRegister(i.destination, res);
  }

  @override
  void visitTST(TSTArmInstruction i, [void _]) {
    // Rn AND Op2
    final op1 = _readRegister(i.operand1);
    final op2 = _visitOperand2(i.operand2);
    final res = op1 & op2;
    assert(i.setConditionCodes);
    if (i.destination == Register.filledWith1s) {
      // TST {P}:
      //   In user mode, N, Z, C, V can be changed
      //   Else, additionally I, F, M1, M0 can be changed
      throw UnimplementedError('TSTP');
    } else {
      // TST (Standard Logical Operation)
      _writeToCZN(res.hiLo());
    }
  }

  @override
  void visitTEQ(TEQArmInstruction i, [void _]) {
    // Rn XOR Op2
    final op1 = _readRegister(i.operand1);
    final op2 = _visitOperand2(i.operand2);
    final res = op1 ^ op2;
    assert(i.setConditionCodes);
    if (i.destination == Register.filledWith1s) {
      // TEQ {P}:
      //   In user mode, N, Z, C, V can be changed
      //   Else, additionally I, F, M1, M0 can be changed
      throw UnimplementedError('TEQP');
    } else {
      // TEQ (Standard Logical Operation)
      _writeToCZN(res.hiLo());
    }
  }

  @override
  void visitCMP(CMPArmInstruction i, [void _]) {
    // Rn - Op2
    final op1 = _readRegister(i.operand1);
    final op2 = _visitOperand2(i.operand2);
    assert(i.setConditionCodes);
    if (i.destination == Register.filledWith1s) {
      // CMP {P}:
      //   In user mode, N, Z, C, V can be changed
      //   Else, additionally I, F, M1, M0 can be changed
      throw UnimplementedError('CMPP');
    } else {
      // CMP (Standard Arithmetic Operation)
      final res = _subWithCarry(op1, op2, setFlags: true);
      _writeToCZN(res.hiLo());
    }
  }

  @override
  void visitCMN(CMNArmInstruction i, [void _]) {
    // Rn + op2
    final op1 = _readRegister(i.operand1);
    final op2 = _visitOperand2(i.operand2);
    assert(i.setConditionCodes);
    if (i.destination == Register.filledWith1s) {
      // CMN {P}:
      //   In user mode, N, Z, C, V can be changed
      //   Else, additionally I, F, M1, M0 can be changed
      throw UnimplementedError('CMNP');
    } else {
      // CMN (Standard Arithmetic Operation)
      final res = _addWithCarry(op1, op2, setFlags: true);
      _writeToCZN(res.hiLo());
    }
  }

  // PSR Transfer

  @override
  void visitMRS(MRSArmInstruction i, [void _]) {
    // Rd = PSR
    final psr = i.useSPSR ? cpu.spsr : cpu.cpsr;
    _writeRegister(i.destination, psr.toBits());
  }

  @override
  void visitMSR(MSRArmInstruction i, [void _]) {
    // Psr[field] = Op
    final op = i.sourceOrImmediate.pick(_readRegister, evaluateImmediate);

    // Read initial PSR, and then write to it.
    var psr = (i.useSPSR ? cpu.spsr : cpu.cpsr).toBits();
    if (i.allowChangingControls && cpu.cpsr.mode.isPriveleged) {
      psr = psr.replaceBitRange(7, 0, op.bitRange(7, 0).value);
    }
    if (i.allowChangingFlags) {
      psr = psr.replaceBitRange(31, 24, op.bitRange(31, 24).value);
    }
    if (i.useSPSR) {
      cpu.spsr = StatusRegister(psr);
    } else {
      cpu.cpsr = StatusRegister(psr);
    }
  }

  Uint32 _mul32WithAccumulate(
    Uint32 op1,
    Uint32 op2, {
    Uint32List accumulate,
    bool setFlags = false,
  }) {
    return _mul64WithAccumulate(
      op1,
      op2,
      accumulate: accumulate,
      setFlags: setFlags,
    ).toUint32();
  }

  Uint32List _mul64WithAccumulate(
    Uint32 op1,
    Uint32 op2, {
    Uint32List accumulate,
    bool asSigned = false,
    bool setFlags = false,
  }) {
    Uint32List product;
    if (asSigned) {
      final sOp1 = op1.toSigned();
      final sOp2 = op2.toSigned();
      var sProduct = sOp1 * sOp2;
      if (accumulate != null) {
        sProduct = sProduct.add64(accumulate.asSigned());
      }
      product = sProduct.asUnsigned();
    } else {
      product = op1 * op2;
      if (accumulate != null) {
        product = product.add64(accumulate);
      }
    }
    if (setFlags) {
      _writeToAllFlags(
        product,
        op1Signed: op1.msb,
        op2Signed: op2.msb,
      );
    }
    return product;
  }

  @override
  void visitMUL(MULArmInstruction i, [void _]) {
    // Rd = Rm * Rs
    final op1 = _readRegister(i.operand1);
    final op2 = _readRegister(i.operand2);
    final res = _mul32WithAccumulate(
      op1,
      op2,
      setFlags: i.setConditionCodes,
    );
    _writeRegister(i.destination, res);
  }

  @override
  void visitMLA(MLAArmInstruction i, [void _]) {
    // Rd = Rm * Rs + Rn
    final op1 = _readRegister(i.operand1);
    final op2 = _readRegister(i.operand2);
    final op3 = _readRegister(i.operand3);
    final res = _mul32WithAccumulate(
      op1,
      op2,
      accumulate: op3.hiLo(),
      setFlags: i.setConditionCodes,
    );
    _writeRegister(i.destination, res);
  }

  @override
  void visitSMULL(SMULLArmInstruction i, [void _]) {
    // RdHi = Rm * Rs
    final op1 = _readRegister(i.operand1);
    final op2 = _readRegister(i.operand2);
    final res = _mul64WithAccumulate(
      op1,
      op2,
      setFlags: i.setConditionCodes,
      asSigned: true,
    );
    _writeRegister(i.destinationHiBits, Uint32(res.hi));
    _writeRegister(i.destinationLoBits, Uint32(res.lo));
  }

  @override
  void visitSMLAL(SMLALArmInstruction i, [void _]) {
    // RdHiLo = Rm * Rs + RdHiLo
    final op1 = _readRegister(i.operand1);
    final op2 = _readRegister(i.operand2);
    final op3Hi = _readRegister(i.destinationHiBits);
    final op3Lo = _readRegister(i.destinationLoBits);
    final res = _mul64WithAccumulate(
      op1,
      op2,
      accumulate: Uint32List(2)
        ..hi = op3Hi.value
        ..lo = op3Lo.value,
      setFlags: i.setConditionCodes,
      asSigned: true,
    );
    _writeRegister(i.destinationHiBits, Uint32(res.hi));
    _writeRegister(i.destinationLoBits, Uint32(res.lo));
  }

  @override
  void visitUMULL(UMULLArmInstruction i, [void _]) {
    // RdHiLo = Rm * Rs
    final op1 = _readRegister(i.operand1);
    final op2 = _readRegister(i.operand2);
    final res = _mul64WithAccumulate(
      op1,
      op2,
      setFlags: i.setConditionCodes,
    );
    _writeRegister(i.destinationHiBits, Uint32(res.hi));
    _writeRegister(i.destinationLoBits, Uint32(res.lo));
  }

  @override
  void visitUMLAL(UMLALArmInstruction i, [void _]) {
    // RdHiLo = Rm * Rs + RdHiLo
    final op1 = _readRegister(i.operand1);
    final op2 = _readRegister(i.operand2);
    final op3Hi = _readRegister(i.destinationHiBits);
    final op3Lo = _readRegister(i.destinationLoBits);
    final res = _mul64WithAccumulate(
      op1,
      op2,
      accumulate: Uint32List(2)
        ..hi = op3Hi.value
        ..lo = op3Lo.value,
      setFlags: i.setConditionCodes,
    );
    _writeRegister(i.destinationHiBits, Uint32(res.hi));
    _writeRegister(i.destinationLoBits, Uint32(res.lo));
  }

  // TOOD: Implement.
  Uint32 _loadByte(Uint32 address) => Uint32(Uint8.zero.value);

  // TOOD: Implement.
  Uint32 _loadWord(Uint32 address) => Uint32(Uint16.zero.value);

  Uint32 _readMemory(
    Register register,
    Uint32 offset, {
    @required bool byte,
    @required bool before,
    @required bool add,
    @required bool write,
  }) {
    Uint32 result;
    Uint32 address;
    final base = _readRegister(register);
    if (before) {
      address = (add ? (base + offset) : (base - offset)).toUint32();
      result = byte ? _loadByte(address) : _loadWord(address);
    } else {
      address = base;
      result = byte ? _loadByte(address) : _loadWord(address);
      if (add) {
        result = (result + offset).toUint32();
      } else {
        result = (result - offset).toUint32();
      }
    }
    if (write) {
      _writeRegister(register, address);
    }
    return result;
  }

  @override
  void visitLDR(LDRArmInstruction i, [void _]) {
    // Rd = [Rn +/- Offset]
    // (Loads from memory into a register)
    final memory = _readMemory(
      i.base,
      i.offset.pick(
        (i) => Uint32(i.value.value),
        evaluateShiftRegister,
      ),
      byte: i.transferByte,
      before: i.addOffsetBeforeTransfer,
      add: i.addOffsetToBase,
      write: i.writeAddressIntoBase,
    );
    // TODO: Deal with force non-privleged access mode.
    _writeRegister(i.destination, memory);
  }

  // TOOD: Implement.
  void _storeByte(Uint32 address, Uint8 byte) {}

  // TOOD: Implement.
  void _storeWord(Uint32 address, Uint16 word) {}

  void _storeMemory(
    Register register,
    Uint32 offset,
    Uint32 source, {
    @required bool byte,
    @required bool before,
    @required bool add,
    @required bool write,
  }) {}

  @override
  void visitSTR(STRArmInstruction i, [void _]) {
    // [Rn +/- Offset] = Rd
    _storeMemory(
      i.base,
      i.offset.pick(
        (i) => Uint32(i.value.value),
        evaluateShiftRegister,
      ),
      _readRegister(i.source),
      byte: i.transferByte,
      before: i.addOffsetBeforeTransfer,
      add: i.addOffsetToBase,
      write: i.writeAddressIntoBase,
    );
    // TODO: Deal with force non-privleged access mode.
  }

  @override
  void visitB(BArmInstruction i, [void _]) {
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
  void visitLDM(LDMArmInstruction i, [void _]) {
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
  void visitSTM(STMArmInstruction i, [void _]) {
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
}
