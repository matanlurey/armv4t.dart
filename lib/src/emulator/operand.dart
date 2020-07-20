import 'package:armv4t/decode.dart';
import 'package:armv4t/src/emulator/processor.dart';
import 'package:binary/binary.dart';
import 'package:meta/meta.dart';

/// Provides functionality for evaluating operand values.
///
/// A novel feature of _ARM_ is that all data-processing instructions can
/// include an optional _shift”_ whereas most other architectures have separate
/// shift instructions.
mixin OperandEvaluator {
  static final _maxUint32 = Uint32(0xffffffff);

  /// Provides an implementation of the CPU to access registers and PSR.
  @protected
  Arm7Processor get cpu;

  /// Returns the result for the provided [immediate] value.
  ///
  /// Immediate constants are encoded in two parts (4-bit rotate, 8-bit value).
  /// Only a subset of 4096 32-bit numbers can be used directly as operands;
  /// there are actually **3073** distinct constants. There are 16 `0s`, and 4
  /// ways to represent all powers `2`.
  @protected
  @visibleForTesting
  Uint32 evaluateImmediate<I extends Integral<I>>(
    ShiftedImmediate<I> immediate,
  ) {
    final value = Uint32(immediate.immediate.value.value);
    final rorSh = immediate.rorShift.value;
    // Intentionally does not flow through rotateRightShift.
    final result = value.rotateRightShift(rorSh * 2);
    return Uint32(result.value);
  }

  Uint32 _performShifts(
    Uint32 value,
    ShiftType type,
    int n, {
    @required bool setFlags,
  }) {
    switch (type) {
      case ShiftType.LSL:
        return logicalShiftLeft(value, n, setFlags: setFlags);
      case ShiftType.LSR:
        return logicalShiftRight(value, n, setFlags: setFlags);
      case ShiftType.ASR:
        return arithmeticShiftRight(value, n, setFlags: setFlags);
      case ShiftType.ROR:
        return rotateRightShift(value, n, setFlags: setFlags);
      case ShiftType.RRX:
        return rotateRightOneBitWithExtend(value, setFlags: setFlags);
      default:
        throw StateError('Unexpected: $type');
    }
  }

  /// Returns the result for the provided [register] shifted by an immediate.
  @protected
  @visibleForTesting
  Uint32 evaluateShiftRegister(
    ShiftedRegister<Immediate, Register> register, {
    bool setFlags = false,
  }) {
    final index = register.operand.index.value;
    final input = cpu[index];
    final shift = register.type;
    final value = register.by.value.value;
    return _performShifts(input, shift, value, setFlags: setFlags);
  }

  /// Returns the result for the provided [register] shifted by a register.
  @protected
  @visibleForTesting
  Uint32 evaluateRegisters(
    ShiftedRegister<Register, Register> register, {
    bool setFlags = false,
  }) {
    final index = register.operand.index.value;
    final input = cpu[index];
    final shift = register.type;
    final value = cpu[register.by.index.value].value;
    return _performShifts(input, shift, value, setFlags: setFlags);
  }

  /// Arithmetic shift right (`>>>`) [value] by [n].
  ///
  /// Divides [value] by `2^n` if the contents are regarded as a two's
  /// complement signed integer. The original bit `[31]` is copied into the
  /// left-hand [n] bits of the register.
  ///
  /// If [setFlags], the most significant discard bit is shifted to _carry_.
  ///
  /// > NOTE: If [n] is `0` (e.g. represents `ASR 0`), it is used a special
  /// > encoding to represent `ASR #32`, which has a guaranteed result of either
  /// > all `1s` or all `0s`, depending on the most significant bit of [value],
  /// > and the most significant bit (31) is also shifted out to _carry_.
  ///
  /// ## Example
  ///
  /// ```asm
  /// MOV R0, R0, ASR 2
  /// ```
  ///
  /// R0     | Binary                                                  | Decimal
  /// ------ | ------------------------------------------------------- | ------
  /// Before | `1111` `1111` `1111` `1111` `1111` `1100` `0000` `0000` | 1024
  /// After  | `1111` `1111` `1111` `1111` `1111` `1111` `0000` `0000` | 256
  /// Diff   | `^^__` `____` `____` `____` `____` `____` `____` `____` | `=>`
  @protected
  @visibleForTesting
  Uint32 arithmeticShiftRight(
    Uint32 value,
    int n, {
    bool setFlags = false,
  }) {
    if (n == 0) {
      final msb = value.msb;
      cpu.cpsr = cpu.cpsr.update(isCarry: msb);
      return msb ? _maxUint32 : Uint32.zero;
    }
    if (setFlags) {
      cpu.cpsr = cpu.cpsr.update(isCarry: value.isSet(n));
    }
    return value.signedRightShift(n);
  }

  /// Logical shift right (`>>`) [value] by [n].
  ///
  /// Divdes [value] by `2^n`, if the contents are regarded as an unsigned
  /// integer. The left-hand [n] bits of the register are set to `0`.
  ///
  /// If [setFlags], the most significant discard bit is shifted to _carry_.
  ///
  /// > NOTE: If [n] is `0` (e.g. represents `LSR 0`), it is used as a special
  /// > encoding to represent `LSR #32`, which has a guaranteed zero result with
  /// > bit 31 representing _carry_ even if [setFlags] is not `true`.
  ///
  /// ## Example
  ///
  /// ```asm
  /// MOV R0, R0, LSR 2
  /// ```
  ///
  /// R0     | Binary                                                  | Decimal
  /// ------ | ------------------------------------------------------- | ------
  /// Before | `0000` `0000` `0000` `0000` `0000` `0100` `0000` `0000` | 1024
  /// After  | `0000` `0000` `0000` `0000` `0000` `0011` `1000` `0000` | 256
  /// Diff   | `^^__` `____` `____` `____` `____` `____` `____` `____` | `=>`
  @protected
  @visibleForTesting
  Uint32 logicalShiftRight(
    Uint32 value,
    int n, {
    bool setFlags = false,
  }) {
    // Special case: Return zero, shift the most significant bit to _carry_.
    // This is basically a shortcut to just move the nth-bit to carry.
    if (n == 0) {
      cpu.cpsr = cpu.cpsr.update(isCarry: value.isSet(31));
      return Uint32.zero;
    }
    if (setFlags) {
      cpu.cpsr = cpu.cpsr.update(isCarry: value.isSet(n));
    }
    return value >> Uint32(n);
  }

  /// Logical shift left (`<<`) [value] by [n].
  ///
  /// Multiples [value] by `2^n`, if the contents are regarded as an unsigned
  /// integer. Overflow may occur without warning. The right-hand [n] bits of
  /// the register are set to `0`.
  ///
  /// If [setFlags], the most significant discard bit is shifted to _carry_.
  ///
  /// > NOTE: If [n] is `0` (e.g. represents `LSL 0`), this is special cased as
  /// > an operation that directly uses [value] as the operand and does not set
  /// > a _carry_, even if [setFlags] is `true`.
  ///
  /// ## Example
  ///
  /// ```asm
  /// MOV R0, R0, LSL 7
  /// ```
  ///
  /// R0     | Binary                                                  | Decimal
  /// ------ | ------------------------------------------------------- | ------
  /// Before | `0000` `0000` `0000` `0000` `0000` `0000` `0000` `0111` | 7
  /// After  | `0000` `0000` `0000` `0000` `0000` `0011` `1000` `0000` | 896
  /// Diff   | `____` `____` `____` `____` `____` `____` `_^^^` `^^^^` | `<=`
  @protected
  @visibleForTesting
  Uint32 logicalShiftLeft(
    Uint32 value,
    int n, {
    bool setFlags = false,
  }) {
    // Special case: Do not carry, use value directly as the operand.
    // This is basically a shortcut to directly use an (unshifted) immediate.
    if (n == 0) {
      return value;
    }
    if (setFlags) {
      cpu.cpsr = cpu.cpsr.update(isCarry: value.isSet(32 - n));
    }
    return value << Uint32(n);
  }

  /// Moves the right-hand [n] bits of [value] into the left-hand [n] bits.
  ///
  /// At the same time, all other bits are moved right by [n] bits.
  ///
  /// If [setFlags], the least significant bit is shifted to _carry_.
  ///
  /// > NOTE: If [n] is `0` (e.g. represents `ROR 0`), this is special cased as
  /// > [rotateRightOneBitWithExtend] (`RRX`), which in turn will shift _carry_
  /// > if [setFlags] is set.
  ///
  /// ## Example
  ///
  /// ```asm
  /// MOV R0, R0, ROR 2
  /// ```
  ///
  /// R0     | Binary                                                  | Decimal
  /// ------ | ------------------------------------------------------- | ------
  /// Before | `0000` `0000` `0000` `0000` `0000` `0000` `0000` `0111` | 7
  /// After  | `1100` `0000` `0000` `0000` `0000` `0000` `0000` `0001` | *
  /// Diff   | `^^__` `____` `____` `____` `____` `____` `____` `__^^` | `<=`
  ///
  /// _*: `-1,073,741,823`._
  @protected
  @visibleForTesting
  Uint32 rotateRightShift(
    Uint32 value,
    int n, {
    bool setFlags = false,
  }) {
    if (n == 0) {
      return rotateRightOneBitWithExtend(value, setFlags: setFlags);
    }
    if (setFlags) {
      cpu.cpsr = cpu.cpsr.update(isCarry: value.isSet(0));
    }
    return value.rotateRightShift(n);
  }

  /// Shifts the contents of [value] by one bit.
  ///
  /// The _carry_ flag is copied into bit `[31]` of [value].
  ///
  /// If [setFlags], the old value of  bit `[0]` of [value] is shifted to carry.
  @protected
  @visibleForTesting
  Uint32 rotateRightOneBitWithExtend(
    Uint32 value, {
    bool setFlags = false,
  }) {
    final bit0 = value.isSet(0);
    final oldC = cpu.cpsr.isCarry;
    value = rotateRightShift(value, 1).toggleBit(31, oldC);
    if (setFlags) {
      cpu.cpsr = cpu.cpsr.update(isCarry: bit0);
    }
    return value;
  }
}
