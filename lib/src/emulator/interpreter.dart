import 'dart:typed_data';

import 'package:armv4t/decode.dart';
import 'package:armv4t/src/common/binary.dart';
import 'package:armv4t/src/decoder/arm/instruction.dart';
import 'package:armv4t/src/emulator/condition.dart';
import 'package:armv4t/src/emulator/memory.dart';
import 'package:armv4t/src/emulator/operand.dart';
import 'package:armv4t/src/emulator/processor.dart';
import 'package:binary/binary.dart';
import 'package:meta/meta.dart';

/// Provides a virtual dispatch-based interpretation of [ArmInstruction]s.
@sealed
abstract class ArmInterpreter {
  factory ArmInterpreter(
    Arm7Processor cpu,
    Memory memory,
  ) = _ArmInterpreter;

  /// Whether [Arm7Processor.programCounter] has exceeded [Memory.length];
  bool get atEndOfMemory;

  /// Runs [instruction] relative to current [cpu].
  ///
  /// Returns whether the instruction was executed (e.g. due to conditions).
  ///
  /// Unlike [step], [Arm7Processor.programCounter] is _not_ modified as a
  /// result of normal execution (but it might be as a result of a branching
  /// instruction or other instructions that write into `r15`). See [step].
  bool run(ArmInstruction instruction);

  /// Runs [instruction] relative to the current [cpu].
  ///
  /// The [Arm7Processor.programCounter] is incremented as a result, and it is
  /// possible that the program should stop executing (e.g. the end of the
  /// program has been reached). See [atEndOfMemory].
  ///
  /// Returns whether the instruction was executed (e.g. due to conditions).
  bool step(ArmInstruction instruction);

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

  final Memory _memory;

  _ArmInterpreter(this.cpu, this._memory);

  @override
  bool get atEndOfMemory {
    final nextByte = cpu.programCounter.value;
    return nextByte >= _memory.length;
  }

  @override
  bool run(ArmInstruction instruction) {
    if (evaluateCondition(instruction.condition)) {
      instruction.accept(this);
      return true;
    } else {
      return false;
    }
  }

  /// A flag that marks whether [_branch] was used.
  ///
  /// This allows skipping the program counter increment in [step].
  var _executedBranch = false;

  @override
  bool step(ArmInstruction instruction) {
    _executedBranch = false;
    final ran = run(instruction);
    if (!_executedBranch) {
      cpu.incrementProgramCounter();
    }
    return ran;
  }

  // SHARED / COMMON

  Uint32 _readRegister(
    Register r, {
    bool forceUserMode = false,
  }) =>
      cpu[r.index.value];

  Uint32 _writeRegister(
    Register r,
    Uint32 v, {
    bool forceUserMode = false,
  }) =>
      cpu[r.index.value] = v;

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
    bool result64 = false,
  }) {
    cpu.cpsr = cpu.cpsr.update(
      // V (If + and + is -, or - and - is +)
      isOverflow: result.hadOverflow(op1Signed, op2Signed),

      // C (Discard MSB)
      isCarry: result.isCarry,

      // Z (If RES == 0)
      isZero: result64 ? result.isZero64 : result.isZero32,

      // N (If MSB == 1)
      isSigned: result.isSigned,
    );
  }

  // DATA PROCESSING

  // Arithmetic

  Uint32List _addWithCarry(
    Uint32 op1,
    Uint32 op2, {
    int carryIn = 0,
  }) {
    var sum = op1 + op2;
    if (carryIn != 0) {
      sum = sum.add64(carryIn.hiLo());
    }
    return sum;
  }

  @override
  void visitADD(ADDArmInstruction i, [void _]) {
    //  rD = operand1 + operand2
    final op1 = _readRegister(i.operand1);
    final op2 = _visitOperand2(i.operand2);
    final res = _addWithCarry(
      op1,
      op2,
    );
    if (i.setConditionCodes && !i.destination.isProgramCounter) {
      _writeToAllFlags(
        res,
        op1Signed: op1.msb,
        op2Signed: op2.msb,
      );
    }
    _writeRegister(i.destination, res.toUint32());
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
    );
    if (i.setConditionCodes && !i.destination.isProgramCounter) {
      _writeToAllFlags(
        res,
        op1Signed: op1.msb,
        op2Signed: op2.msb,
      );
    }
    _writeRegister(i.destination, res.toUint32());
  }

  @override
  void visitSUB(SUBArmInstruction i, [void _]) {
    // rD = operand1 - operand2
    final op1 = _readRegister(i.operand1);
    final op2 = ~_visitOperand2(i.operand2);
    final res = _addWithCarry(
      op1,
      op2,
      carryIn: 1,
    );
    if (i.setConditionCodes && !i.destination.isProgramCounter) {
      _writeToAllFlags(
        res,
        op1Signed: op1.msb,
        op2Signed: op2.msb,
      );
    }
    _writeRegister(i.destination, res.toUint32());
  }

  @override
  void visitSBC(SBCArmInstruction i, [void _]) {
    // rD = operand1 - operand2 + carry - 1
    final op1 = _readRegister(i.operand1);
    final op2 = ~_visitOperand2(i.operand2);
    final res = _addWithCarry(
      op1,
      op2,
      carryIn: cpu.cpsr.isCarry ? 1 : 0,
    );
    if (i.setConditionCodes && !i.destination.isProgramCounter) {
      _writeToAllFlags(
        res,
        op1Signed: op1.msb,
        op2Signed: op2.msb,
      );
    }
    _writeRegister(i.destination, res.toUint32());
  }

  @override
  void visitRSB(RSBArmInstruction i, [void _]) {
    // rD = operand2 - operand1
    final op1 = ~_readRegister(i.operand1);
    final op2 = _visitOperand2(i.operand2);
    final res = _addWithCarry(
      op2,
      op1,
      carryIn: 1,
    );
    if (i.setConditionCodes && !i.destination.isProgramCounter) {
      _writeToAllFlags(
        res,
        op1Signed: op1.msb,
        op2Signed: op2.msb,
      );
    }
    _writeRegister(i.destination, res.toUint32());
  }

  @override
  void visitRSC(RSCArmInstruction i, [void _]) {
    // rD = operand2 - operand1 + carry - 1
    final op1 = ~_readRegister(i.operand1);
    final op2 = _visitOperand2(i.operand2);
    final res = _addWithCarry(
      op2,
      op1,
      carryIn: cpu.cpsr.isCarry ? 1 : 0,
    );
    if (i.setConditionCodes && !i.destination.isProgramCounter) {
      _writeToAllFlags(
        res,
        op1Signed: op1.msb,
        op2Signed: op2.msb,
      );
    }
    _writeRegister(i.destination, res.toUint32());
  }

  void _writeToCZN(Uint32List result) {
    cpu.cpsr = cpu.cpsr.update(
      // C (Carry Flag of Shift Operation, Ignored if LSL #0 or Rs=00h)
      //
      // We don't update it here though, it does during shifting.

      // Z (If RES == 0)
      isZero: result.isZero32,

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
    final op2 = ~_visitOperand2(i.operand2);
    assert(i.setConditionCodes);
    if (i.destination == Register.filledWith1s) {
      // CMP {P}:
      //   In user mode, N, Z, C, V can be changed
      //   Else, additionally I, F, M1, M0 can be changed
      throw UnimplementedError('CMPP');
    } else {
      // CMP (Standard Arithmetic Operation)
      final res = _addWithCarry(
        op1,
        op2,
        carryIn: 1,
      );
      _writeToAllFlags(res, op1Signed: op1.msb, op2Signed: op2.msb);
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
      final res = _addWithCarry(
        op1,
        op2,
      );
      _writeToAllFlags(res, op1Signed: op1.msb, op2Signed: op2.msb);
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
    bool result64 = false,
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
        result64: result64,
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
      result64: true,
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
      result64: true,
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
      result64: true,
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
      result64: true,
    );
    _writeRegister(i.destinationHiBits, Uint32(res.hi));
    _writeRegister(i.destinationLoBits, Uint32(res.lo));
  }

  Uint32 _loadFromAddress(
    Uint32 address,
    _Size size, {
    @required bool signed,
  }) {
    Uint32 result;
    switch (size) {
      case _Size.byte:
        result = Uint32(_memory.loadByte(address).value);
        if (signed) {
          result = result.signExtend(7);
        }
        break;
      case _Size.halfWord:
        result = Uint32(_memory.loadHalfWord(address).value);
        if (signed) {
          result = result.signExtend(15);
        }
        break;
      case _Size.word:
        result = Uint32(_memory.loadWord(address).value);
        break;
      default:
        throw StateError('Unexpected: $size');
    }
    return result;
  }

  Uint32 _loadMemory(
    Register baseRegister,
    Uint32 offset, {
    @required _Size size,
    @required bool signed,
    @required bool before,
    @required bool add,
    @required bool write,
    @required bool forceUserMode,
  }) {
    Uint32 result;
    Uint32 address;

    final base = _readRegister(baseRegister, forceUserMode: forceUserMode);
    if (before) {
      address = (add ? (base + offset) : (base - offset)).toUint32();
      result = _loadFromAddress(address, size, signed: signed);
    } else {
      address = base;
      result = _loadFromAddress(address, size, signed: signed);
      if (add) {
        address = (address + offset).toUint32();
      } else {
        address = (address - offset).toUint32();
      }
    }
    if (write) {
      _writeRegister(baseRegister, address, forceUserMode: forceUserMode);
    }
    return result;
  }

  @override
  void visitLDR(LDRArmInstruction i, [void _]) {
    // Rd = [Rn +/- Offset]
    // (Loads from memory into a register)
    final memory = _loadMemory(
      i.base,
      i.offset.pick(
        (i) => Uint32(i.value.value),
        evaluateShiftRegister,
      ),
      size: i.transferByte ? _Size.byte : _Size.word,
      signed: false,
      before: i.addOffsetBeforeTransfer,
      add: i.addOffsetToBase,
      write: i.writeAddressIntoBase,
      forceUserMode: i.forceNonPrivilegedAccess,
    );
    _writeRegister(
      i.destination,
      memory,
      forceUserMode: i.forceNonPrivilegedAccess,
    );
  }

  void _storeMemory(
    Register baseRegister,
    Uint32 offset,
    Uint32 source, {
    @required _Size size,
    @required bool before,
    @required bool add,
    @required bool write,
    @required bool forceUserMode,
  }) {
    Uint32 address;

    void store() {
      switch (size) {
        case _Size.byte:
          _memory.storeByte(address, Uint8(source.bitRange(7, 0).value));
          break;
        case _Size.halfWord:
          _memory.storeHalfWord(address, Uint16(source.bitRange(15, 0).value));
          break;
        case _Size.word:
          _memory.storeWord(address, source);
          break;
        default:
          throw StateError('Unexpected: $size');
      }
    }

    final base = _readRegister(baseRegister, forceUserMode: forceUserMode);
    if (before) {
      address = (add ? (base + offset) : (base - offset)).toUint32();
      store();
    } else {
      address = base;
      store();
      address = (add ? address + offset : address - offset).toUint32();
    }
    if (write) {
      _writeRegister(baseRegister, address, forceUserMode: forceUserMode);
    }
  }

  @override
  void visitSTR(STRArmInstruction i, [void _]) {
    // [Rn +/- Offset] = Rd
    _storeMemory(
      i.base,
      i.offset.pick(
        (i) => Uint32(i.value.value),
        evaluateShiftRegister,
      ),
      _readRegister(
        i.source,
        forceUserMode: i.forceNonPrivilegedAccess,
      ),
      size: i.transferByte ? _Size.byte : _Size.word,
      before: i.addOffsetBeforeTransfer,
      add: i.addOffsetToBase,
      write: i.writeAddressIntoBase,
      forceUserMode: i.forceNonPrivilegedAccess,
    );
  }

  @override
  void visitLDRH(LDRHArmInstruction i, [void _]) {
    final result = _loadMemory(
      i.base,
      i.offset.pick(
        _readRegister,
        (i) => Uint32(i.value.value),
      ),
      size: _Size.halfWord,
      signed: false,
      before: i.addOffsetBeforeTransfer,
      add: i.addOffsetToBase,
      write: i.writeAddressIntoBase,
      forceUserMode: i.forceNonPrivilegedAccess,
    );
    _writeRegister(
      i.destination,
      result,
      forceUserMode: i.forceNonPrivilegedAccess,
    );
  }

  @override
  void visitLDRSH(LDRSHArmInstruction i, [void _]) {
    final result = _loadMemory(
      i.base,
      i.offset.pick(
        _readRegister,
        (i) => Uint32(i.value.value),
      ),
      size: _Size.halfWord,
      signed: true,
      before: i.addOffsetBeforeTransfer,
      add: i.addOffsetToBase,
      write: i.writeAddressIntoBase,
      forceUserMode: i.forceNonPrivilegedAccess,
    );
    _writeRegister(
      i.destination,
      result,
      forceUserMode: i.forceNonPrivilegedAccess,
    );
  }

  @override
  void visitLDRSB(LDRSBArmInstruction i, [void _]) {
    final result = _loadMemory(
      i.base,
      i.offset.pick(
        _readRegister,
        (i) => Uint32(i.value.value),
      ),
      size: _Size.byte,
      signed: true,
      before: i.addOffsetBeforeTransfer,
      add: i.addOffsetToBase,
      write: i.writeAddressIntoBase,
      forceUserMode: i.forceNonPrivilegedAccess,
    );
    _writeRegister(
      i.destination,
      result,
      forceUserMode: i.forceNonPrivilegedAccess,
    );
  }

  @override
  void visitSTRH(STRHArmInstruction i, [void _]) {
    _storeMemory(
      i.base,
      i.offset.pick(
        _readRegister,
        (i) => Uint32(i.value.value),
      ),
      _readRegister(
        i.source,
        forceUserMode: i.forceNonPrivilegedAccess,
      ),
      size: _Size.halfWord,
      before: i.addOffsetBeforeTransfer,
      add: i.addOffsetToBase,
      write: i.writeAddressIntoBase,
      forceUserMode: i.forceNonPrivilegedAccess,
    );
  }

  @override
  void visitLDM(LDMArmInstruction i, [void _]) {
    // If write-back is not used, we want to restore the base register.
    final base = _readRegister(
      i.base,
      forceUserMode: i.forceNonPrivilegedAccess,
    );
    // Loads multiple memory locations into multiple registers.
    for (final register in i.registerList.registers) {
      final result = _loadMemory(
        // Base register containing the *initial* memory address.
        i.base,
        Uint32(4),
        size: _Size.word,
        signed: false,
        // Addressing mode:
        //   IA: Increment address after each transfer  (e.g. FD)
        //   IB: Increment address before each transfer (e.g. ED)
        //   DA: Decrement address after each transfer  (e.g. FA)
        //   DB: Decrement address before each transfer (e.g. EA)
        before: i.addOffsetBeforeTransfer,
        add: i.addOffsetToBase,
        // Always "write-back" - e.g. increment/decrement address.
        write: true,
        // Whether to write to user-bank registers regardless of current mode.
        forceUserMode: i.forceNonPrivilegedAccess,
      );
      _writeRegister(
        register,
        result,
        forceUserMode: i.forceNonPrivilegedAccess,
      );
    }
    if (i.loadPsr) {
      if (i.registerList.registers.last.isProgramCounter) {
        // Mode change.
        cpu.cpsr = cpu.spsr;
      } else {
        // User bank transfer.
        // No write-back possible, so restore the base register.
        assert(!i.writeAddressIntoBase, 'Should not be set');
      }
    }
    // Restore base register if write-back disabled.
    if (!i.writeAddressIntoBase) {
      _writeRegister(
        i.base,
        base,
        forceUserMode: i.forceNonPrivilegedAccess,
      );
    }
  }

  @override
  void visitSTM(STMArmInstruction i, [void _]) {
    // If write-back is not used, we want to restore the base register.
    final base = _readRegister(
      i.base,
      forceUserMode: i.forceNonPrivilegedAccess,
    );
    // Stores into multiple memory locations from multiple registers.
    for (final register in i.registerList.registers) {
      _storeMemory(
        i.base,
        Uint32(4),
        _readRegister(
          register,
          forceUserMode: i.forceNonPrivilegedAccess,
        ),
        size: _Size.word,
        // Addressing mode:
        //   IA: Increment address after each transfer  (e.g. FD)
        //   IB: Increment address before each transfer (e.g. ED)
        //   DA: Decrement address after each transfer  (e.g. FA)
        //   DB: Decrement address before each transfer (e.g. EA)
        before: i.addOffsetBeforeTransfer,
        add: i.addOffsetToBase,
        // Always "write-back" - e.g. increment/decrement address.
        write: true,
        // Whether to write to user-bank registers regardless of current mode.
        forceUserMode: i.forceNonPrivilegedAccess,
      );
    }
    // Restore base register if write-back disabled.
    if (!i.writeAddressIntoBase) {
      _writeRegister(
        i.base,
        base,
        forceUserMode: i.forceNonPrivilegedAccess,
      );
    }
  }

  @override
  void visitSWP(SWPArmInstruction i, [void _]) {
    // Rd = [Rm]
    final result = _loadMemory(
      i.source,
      Uint32.zero,
      size: i.transferByte ? _Size.byte : _Size.word,
      signed: false,
      before: true,
      add: true,
      write: false,
      forceUserMode: false,
    );
    _writeRegister(i.destination, result);

    // [Rn] = Rm
    _storeMemory(
      i.base,
      Uint32.zero,
      _readRegister(i.source),
      size: i.transferByte ? _Size.byte : _Size.word,
      before: false,
      add: true,
      write: true,
      forceUserMode: false,
    );
  }

  void _branch(int offset) {
    // PC = PC + 8 + Offset * 4
    final origin = cpu.programCounter.value;
    final destination = origin + (offset * 4) + 8;
    cpu.programCounter = Uint32(destination);
    _executedBranch = true;
  }

  @override
  void visitB(BArmInstruction i, [void _]) {
    _branch(i.offset.value);
  }

  @override
  void visitBL(BLArmInstruction i, [void _]) {
    final returnTo = cpu.programCounter.value + 4;
    cpu.linkRegister = Uint32(returnTo);
    _branch(i.offset.value);
  }

  @override
  void visitBX(BXArmInstruction i, [void _]) {
    // PC = Rn, T = Rn.0
    if (i.switchToThumbMode(_readRegister)) {
      cpu.unsafeSetCpsr(cpu.cpsr.update(thumbState: true));
      final jump = _readRegister(i.operand).value - 1;
      cpu.programCounter = Uint32(jump);
    } else {
      cpu.unsafeSetCpsr(cpu.cpsr.update(thumbState: false));
      cpu.programCounter = _readRegister(i.operand);
    }
  }

  // TODO: Implement for other exception types.
  void _enterExceptionSWI() {
    const _baseVector = 0x00000000;
    const _swiOffsets = 0x08;

    // R14_<new mode>   = PC + nn
    // SPSR_<new mode>  = CPSR
    // CPSR_T           = 0
    // CPSR_M           = mode
    // CPSR_F           = 1 (Reset and FIQ Only)
    // PC               = EXCEPTION_VECTOR
    final cpsr = cpu.cpsr;
    cpu
      ..linkRegister = cpu.programCounter
      ..unsafeSetCpsr(cpu.cpsr.update(
        thumbState: false,
        mode: ArmOperatingMode.svc,
      ))
      ..spsr = cpsr
      ..programCounter = Uint32(_baseVector + _swiOffsets);
  }

  @override
  void visitSWI(SWIArmInstruction i, [void _]) {
    _enterExceptionSWI();
  }
}

enum _Size {
  byte,
  halfWord,
  word,
}
