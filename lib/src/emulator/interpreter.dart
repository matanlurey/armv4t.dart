import 'dart:typed_data';

import 'package:armv4t/decode.dart';
import 'package:armv4t/src/common/binary.dart';
import 'package:armv4t/src/decoder/arm/instruction.dart';
import 'package:armv4t/src/emulator/condition.dart';
import 'package:armv4t/src/emulator/memory.dart';
import 'package:armv4t/src/emulator/operand.dart';
import 'package:armv4t/src/emulator/processor.dart';
import 'package:armv4t/src/emulator/stack.dart';
import 'package:binary/binary.dart';
import 'package:meta/meta.dart';

/// Provides a virtual dispatch-based interpretation of [ArmInstruction]s.
@sealed
abstract class ArmInterpreter {
  factory ArmInterpreter(
    Arm7Processor cpu,
    Memory memory, [
    ArmDebugHooks debugHooks,
  ]) = _ArmInterpreter;

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

/// May be extended and invoked by [ArmInterpreter] when provided.
@experimental
class ArmDebugHooks {
  const ArmDebugHooks();

  /// Invoked when [ArmInstruction] will be executed.
  void onInstructionExecuting(
    ArmInstruction instruction,
    Uint32 address,
  ) {}

  /// Invoked when [ArmInstruction.condition] skips execution based on [cpsr].
  void onInstructionSkipped(
    ArmInstruction instruction,
    Uint32 address,
    StatusRegister cpsr,
  ) {}

  /// Invoked when [register] is read as a result of execution.
  void onRegisterRead(
    Register register,
    Uint32 value, {
    @required bool forcedUserMode,
  }) {}

  /// Invoked when [register] is written to as a result of execution.
  ///
  /// This hook occurs right before writing, so it is possible to read from
  /// [register] and the _previous_ value before overwritten by [newValue], if
  /// desired.
  ///
  /// **NOTE**: This method is called even if the value is the same.
  void onRegisterWrite(
    Register register,
    Uint32 newValue, {
    @required bool forcedUserMode,
  }) {}

  /// Invoked when [StatusRegister] is updated as a result of execution.
  ///
  /// This hook occurs right after updating, so it is possible to compare
  /// [previous] to the _current_ value.
  ///
  /// **NOTE**: This method is _not_ called if no flags were updated.
  void onFlagsUpdated(StatusRegister previous) {}

  /// Invoked when a memory [address] was read (as [value]).
  ///
  /// **NOTE**: This method is not informed what the size of the data read was
  /// (e.g. [value] could be representing a byte, half-word, or a word).
  void onMemoryRead(Uint32 address, Uint32 value) {}

  /// Invoked when a memory [address] is written to (with [newValue]).
  ///
  /// This hook occurs right before writing, so it is possible to read from
  /// [Memory] and the _previous_ value before being overwrriten by [newValue],
  /// if desired.
  ///
  /// **NOTE**: This method is not informed what the size of the data written
  /// was (e.g. [newValue] could be representing a byte, half-word, or a word).
  void onMemoryWrite(Uint32 address, Uint32 newValue) {}
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

  @protected
  final ArmDebugHooks _debugHooks;

  _ArmInterpreter(
    this.cpu,
    this._memory, [
    ArmDebugHooks debugHooks,
  ]) : _debugHooks = debugHooks ?? const ArmDebugHooks();

  @override
  @protected
  Uint32 readRegister(Register register) => _readRegister(register);

  @override
  @protected
  StatusRegister readCpsr() => cpu.cpsr;

  @override
  @protected
  void writeCpsr(StatusRegister psr) => cpu.cpsr = psr;

  @override
  bool get atEndOfMemory {
    final nextByte = cpu.programCounter.value;
    return nextByte >= _memory.length;
  }

  @override
  bool run(ArmInstruction instruction) {
    if (evaluateCondition(instruction.condition)) {
      _debugHooks.onInstructionExecuting(
        instruction,
        cpu.programCounter,
      );
      instruction.accept(this);
      return true;
    } else {
      _debugHooks.onInstructionSkipped(
        instruction,
        cpu.programCounter,
        cpu.cpsr,
      );
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
    Register register, {
    bool forceUserMode = false,
  }) {
    Uint32 value;
    if (forceUserMode) {
      value = cpu.forceUserModeRead(register.index.value);
    } else {
      value = cpu[register.index.value];
    }
    _debugHooks.onRegisterRead(register, value, forcedUserMode: forceUserMode);
    return value;
  }

  void _writeRegister(
    Register register,
    Uint32 value, {
    bool forceUserMode = false,
  }) {
    if (register.isProgramCounter) {
      _executedBranch = true;
    }
    _debugHooks.onRegisterWrite(register, value, forcedUserMode: forceUserMode);
    if (forceUserMode) {
      cpu.forceUserModeWrite(register.index.value, value);
    } else {
      cpu[register.index.value] = value;
    }
  }

  Uint32 _visitOperand2(
    Or3<
            ShiftedRegister<Immediate<Uint5>, RegisterAny>,
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
    final previous = cpu.cpsr;
    final updated = cpu.cpsr = previous.update(
      // V (If + and + is -, or - and - is +)
      isOverflow: result.hadOverflow(op1Signed, op2Signed),

      // C (Discard MSB)
      isCarry: result.isCarry,

      // Z (If RES == 0)
      isZero: result64 ? result.isZero64 : result.isZero32,

      // N (If MSB == 1)
      isSigned: result.isSigned,
    );
    if (previous != updated) {
      _debugHooks.onFlagsUpdated(previous);
    }
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
    final previous = cpu.cpsr;
    final updated = cpu.cpsr = previous.update(
      // C (Carry Flag of Shift Operation, Ignored if LSL #0 or Rs=00h)
      //
      // We don't update it here though, it does during shifting.

      // Z (If RES == 0)
      isZero: result.isZero32,

      // N (If MSB == 1)
      isSigned: result.isSigned,
    );
    if (previous != updated) {
      _debugHooks.onFlagsUpdated(previous);
    }
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

  Uint32 _loadFromMemory(
    Uint32 address, {
    _Size size = _Size.word,
    bool signed = false,
  }) {
    Uint32 value;
    switch (size) {
      case _Size.byte:
        var byte = _memory.loadByte(address);
        if (signed) {
          byte = byte.signExtend(7);
        }
        value = Uint32(byte.value);
        break;
      case _Size.halfWord:
        var hword = _memory.loadHalfWord(address);
        if (signed) {
          hword = hword.signExtend(15);
        }
        value = Uint32(hword.value);
        break;
      case _Size.word:
        value = _memory.loadWord(address);
        break;
      default:
        throw StateError('Unexpected: $size');
    }
    _debugHooks.onMemoryRead(address, value);
    return value;
  }

  /// Rotated read: Used for mis-aligned `LDR`, or the read part of `SWP`.
  ///
  /// Reads from a forcibly aligned address ([address] `& ~3`), and then rotates
  /// the resulting data as `ROR(` [address] `& 3) * 8`. This effect is used
  /// interally by `LDRB` and `LDRH` opcodes (which do then mask-out the unused
  /// bits).
  ///
  /// The `SWP` opcode works like a combination of `LDR` and `STR`: that means
  /// it does read-rotated, but it does write-unrotated.
  Uint32 _loadWordFromMemoryAndForceAlignWithRotatedRead(Uint32 address) {
    if (address.isWordAligned) {
      return _loadFromMemory(address);
    }
    final ror = (address.value & 3) * 8;
    return _loadFromMemory(address.forceWordAligned()).rotateRightShift(ror);
  }

  /// Rotated read: Used for mis-aligned `LDRH` in ARMv4.
  ///
  /// `LDRH Rd, [odd]` -> `LDRH Rd, [odd - 1] ROR 8`.
  Uint32 _loadHalfWordFromMemoryAndForceAlignWithRotatedRead(Uint32 address) {
    if (address.isHalfWordAligned) {
      return _loadFromMemory(address, size: _Size.halfWord);
    }
    return _loadFromMemory(address.forceHalfWordAligned()).rotateRightShift(8);
  }

  /// Sign-expanded read: Used for mis-aligned `LDRSH` in ARMv4.
  ///
  /// `LDRSH Rd, [odd]` -> `LDRSB Rd, [odd]`.
  Uint32 _loadSignedHalfWordFromMemorySignExpanded(Uint32 address) {
    return _loadFromMemory(
      address,
      size: address.isHalfWordAligned ? _Size.halfWord : _Size.byte,
      signed: true,
    );
  }

  void _storeIntoMemory(
    Uint32 address,
    Uint32 value, {
    _Size size = _Size.word,
  }) {
    _debugHooks.onMemoryWrite(address, value);
    switch (size) {
      case _Size.byte:
        return _memory.storeByte(
          address,
          Uint8(value.bitRange(7, 0).value),
        );
      case _Size.halfWord:
        return _memory.storeHalfWord(
          address,
          Uint16(value.bitRange(15, 0).value),
        );
      case _Size.word:
        return _memory.storeWord(address, value);
      default:
        throw StateError('Unexpected: $size');
    }
  }

  @override
  void visitLDR(LDRArmInstruction i, [void _]) {
    final offset = i.offset.pick(
      (i) => Uint32(i.value.value),
      evaluateShiftRegister,
    );
    final base = _readRegister(i.base);
    var address = base;

    void moveAddress() {
      if (i.addOffsetToBase) {
        address = (address + offset).toUint32();
      } else {
        address = (address - offset).toUint32();
      }
    }

    if (i.addOffsetBeforeTransfer) {
      moveAddress();
    }

    Uint32 value;
    if (!i.transferByte) {
      value = _loadWordFromMemoryAndForceAlignWithRotatedRead(address);
    } else {
      value = _loadFromMemory(
        address,
        size: i.transferByte ? _Size.byte : _Size.word,
      );
    }

    _writeRegister(
      i.destination,
      value,
      forceUserMode: i.forceNonPrivilegedAccess,
    );

    if (i.writeAddressIntoBase) {
      if (!i.addOffsetBeforeTransfer) {
        moveAddress();
      }
      _writeRegister(i.base, address);
    }
  }

  @override
  void visitSTR(STRArmInstruction i, [void _]) {
    final offset = i.offset.pick(
      (i) => Uint32(i.value.value),
      evaluateShiftRegister,
    );
    final base = _readRegister(i.base);
    var address = base;

    void moveAddress() {
      if (i.addOffsetToBase) {
        address = (address + offset).toUint32();
      } else {
        address = (address - offset).toUint32();
      }
    }

    if (i.addOffsetBeforeTransfer) {
      moveAddress();
    }

    if (!i.transferByte) {
      address = address.forceWordAligned();
    }
    _storeIntoMemory(
      address,
      _readRegister(
        i.source,
        forceUserMode: i.forceNonPrivilegedAccess,
      ),
      size: i.transferByte ? _Size.byte : _Size.word,
    );

    if (i.writeAddressIntoBase) {
      if (!i.addOffsetBeforeTransfer) {
        moveAddress();
      }
      _writeRegister(i.base, address);
    }
  }

  @override
  void visitLDRH(LDRHArmInstruction i, [void _]) {
    final offset = i.offset.pick(
      _readRegister,
      (i) => Uint32(i.value.value),
    );
    final base = _readRegister(i.base);
    var address = base;

    void moveAddress() {
      if (i.addOffsetToBase) {
        address = (address + offset).toUint32();
      } else {
        address = (address - offset).toUint32();
      }
    }

    if (i.addOffsetBeforeTransfer) {
      moveAddress();
    }

    _writeRegister(
      i.destination,
      _loadHalfWordFromMemoryAndForceAlignWithRotatedRead(address),
      forceUserMode: i.forceNonPrivilegedAccess,
    );

    if (i.writeAddressIntoBase) {
      if (!i.addOffsetBeforeTransfer) {
        moveAddress();
      }
      _writeRegister(i.base, address);
    }
  }

  @override
  void visitLDRSH(LDRSHArmInstruction i, [void _]) {
    final offset = i.offset.pick(
      _readRegister,
      (i) => Uint32(i.value.value),
    );
    final base = _readRegister(i.base);
    var address = base;

    void moveAddress() {
      if (i.addOffsetToBase) {
        address = (address + offset).toUint32();
      } else {
        address = (address - offset).toUint32();
      }
    }

    if (i.addOffsetBeforeTransfer) {
      moveAddress();
    }

    _writeRegister(
      i.destination,
      _loadSignedHalfWordFromMemorySignExpanded(address),
      forceUserMode: i.forceNonPrivilegedAccess,
    );

    if (i.writeAddressIntoBase) {
      if (!i.addOffsetBeforeTransfer) {
        moveAddress();
      }
      _writeRegister(i.base, address);
    }
  }

  @override
  void visitLDRSB(LDRSBArmInstruction i, [void _]) {
    final offset = i.offset.pick(
      _readRegister,
      (i) => Uint32(i.value.value),
    );
    final base = _readRegister(i.base);
    var address = base;

    void moveAddress() {
      if (i.addOffsetToBase) {
        address = (address + offset).toUint32();
      } else {
        address = (address - offset).toUint32();
      }
    }

    if (i.addOffsetBeforeTransfer) {
      moveAddress();
    }

    _writeRegister(
      i.destination,
      _loadFromMemory(
        address,
        size: _Size.byte,
        signed: true,
      ),
      forceUserMode: i.forceNonPrivilegedAccess,
    );

    if (i.writeAddressIntoBase) {
      if (!i.addOffsetBeforeTransfer) {
        moveAddress();
      }
      _writeRegister(i.base, address);
    }
  }

  @override
  void visitSTRH(STRHArmInstruction i, [void _]) {
    final offset = i.offset.pick(
      _readRegister,
      (i) => Uint32(i.value.value),
    );
    final base = _readRegister(i.base);
    var address = base;

    void moveAddress() {
      if (i.addOffsetToBase) {
        address = (address + offset).toUint32();
      } else {
        address = (address - offset).toUint32();
      }
    }

    if (i.addOffsetBeforeTransfer) {
      moveAddress();
    }

    _storeIntoMemory(
      address.forceHalfWordAligned(),
      _readRegister(
        i.source,
        forceUserMode: i.forceNonPrivilegedAccess,
      ),
      size: _Size.halfWord,
    );

    if (i.writeAddressIntoBase) {
      if (!i.addOffsetBeforeTransfer) {
        moveAddress();
      }
      _writeRegister(i.base, address);
    }
  }

  static RegisterStack _stack(
    BlockDataTransferArmInstruction i,
    Uint32 base, {
    int offset = 4,
    int size = 1,
  }) {
    return i.addOffsetToBase
        ? i.addOffsetBeforeTransfer
            ? RegisterStack.incrementBefore(base, offset, size: size)
            : RegisterStack.incrementAfter(base, offset, size: size)
        : i.addOffsetBeforeTransfer
            ? RegisterStack.decrementBefore(base, offset, size: size)
            : RegisterStack.decrementAfter(base, offset, size: size);
  }

  @override
  void visitLDM(LDMArmInstruction i, [void _]) {
    final baseAddress = _readRegister(i.base);
    final registers = i.registerList.registers.toList();
    final addresses = _stack(i, baseAddress, size: registers.length);
    final writeBack = i.writeAddressIntoBase;

    // Precompute some different execution scenarios.
    final containsPc = registers.contains(RegisterAny.pc);
    final transferPsr = i.loadPsrOrForceUserMode && containsPc;
    final userBankTransfer = i.loadPsrOrForceUserMode && !containsPc;

    for (final register in registers) {
      _writeRegister(
        register,
        _loadFromMemory(addresses.next().forceWordAligned()),
        forceUserMode: userBankTransfer,
      );
      if (register.isProgramCounter && transferPsr) {
        cpu.cpsr = cpu.spsr;
      }
    }

    if (writeBack) {
      _writeRegister(i.base, addresses.writeBack.forceWordAligned());
    }
  }

  @override
  void visitSTM(STMArmInstruction i, [void _]) {
    final baseAddress = _readRegister(i.base);
    final registers = i.registerList.registers.toList();
    final addresses = _stack(i, baseAddress, size: registers.length);
    final writeBack = i.writeAddressIntoBase;
    if (i.loadPsrOrForceUserMode) {
      for (final register in registers) {
        _storeIntoMemory(
          addresses.next().forceWordAligned(),
          _readRegister(
            register,
            forceUserMode: true,
          ),
        );
      }
    } else {
      for (final register in registers) {
        Uint32 value;
        if (register.isProgramCounter) {
          // Whenever R15 is stored to memory the stored value is the address
          // of the STM instruction (e.g. the current program counter) plus 12.
          value = (cpu.programCounter + Uint32(12)).toUint32();
        } else if (register == i.base &&
            register == registers.first &&
            writeBack) {
          value = baseAddress;
        } else {
          value = _readRegister(register);
        }
        _storeIntoMemory(addresses.next().forceWordAligned(), value);
      }
    }
    if (writeBack) {
      _writeRegister(i.base, addresses.writeBack.forceWordAligned());
    }
  }

  @override
  void visitSWP(SWPArmInstruction i, [void _]) {
    final address = _readRegister(i.base);

    // Rd = [Rm]
    Uint32 value;
    if (!i.transferByte) {
      value = _loadWordFromMemoryAndForceAlignWithRotatedRead(address);
    } else {
      value = _loadFromMemory(address, size: _Size.byte);
    }
    _writeRegister(i.destination, value);

    // [Rn] = Rm
    _storeIntoMemory(
      i.transferByte ? address : address.forceWordAligned(),
      _readRegister(i.source),
      size: i.transferByte ? _Size.byte : _Size.word,
    );
  }

  void _branch(int offset) {
    // PC = PC + 8 + Offset * 4
    final isThumb = cpu.cpsr.thumbState;
    final numBytes = isThumb ? 2 : 4;
    final origin = cpu.programCounter.value;
    final destination = Uint32(
      origin + (offset * numBytes) + (2 * numBytes),
    );
    cpu.programCounter = destination;
    _debugHooks.onRegisterWrite(
      RegisterAny.pc,
      destination,
      forcedUserMode: false,
    );
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
    _writeRegister(RegisterAny.lr, Uint32(returnTo));
    _branch(i.offset.value);
  }

  @override
  void visitBX(BXArmInstruction i, [void _]) {
    // PC = Rn, T = Rn.0
    final to = _readRegister(i.operand).value;
    if (to.isSet(0)) {
      cpu.unsafeSetCpsr(cpu.cpsr.update(thumbState: true));
      final jump = to - 1;
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

extension _ForcedAlignment on Uint32 {
  /// Whether `this` represents a word-aligned address.
  bool get isWordAligned => value % 4 == 0;

  /// Returns an address represented as an [Uint32] word-aligned.
  ///
  /// E.g. `200` stays `200`, but `201`, `202`, `203`, become `200`.
  Uint32 forceWordAligned() => Uint32(value & ~3);

  /// Whether `this` represents a half-word-aligned address.
  bool get isHalfWordAligned => value % 2 == 0;

  /// Returns an address represented as an [Uint32] half-word aligned.
  ///
  /// E.g. `200` stays `200`, but `201` becomes `200`.
  Uint32 forceHalfWordAligned() => Uint32(value & ~1);
}
