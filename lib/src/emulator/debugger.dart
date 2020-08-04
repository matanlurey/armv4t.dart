import 'package:armv4t/armv4t.dart';
import 'package:binary/binary.dart';
import 'package:armv4t/decode.dart';
import 'package:meta/meta.dart';

import 'interpreter.dart';
import 'processor.dart';

/// A stateful implementation of [ArmDebugHooks].
///
/// On [onInstructionExecuting], all state is cleared (reset), and the debugger
/// starts tracking operations that read or write to the status register, normal
/// CPU registers, and/or memory.
///
/// This class is highly _provisional_ and subject to change or removal.
@experimental
class ArmDebugger implements ArmDebugHooks {
  final Arm7Processor _cpu;

  final _events = <String>[];

  /// Creates a debugger with direct access to the CPU.
  ArmDebugger(this._cpu);

  /// Events that were captured since last [onInstructionExecuting].
  Iterable<String> get events => _events;

  @override
  void onInstructionExecuting(
    ArmInstruction instruction,
    Uint32 address,
  ) {
    _events.clear();
    final decoded = instruction.accept(const ArmInstructionPrinter());
    _events.add('\n@0x${address.value.toRadixString(16)}:\n$decoded');
  }

  @override
  void onFlagsUpdated(
    StatusRegister previous,
  ) {
    final current = _cpu.cpsr;
    final buffer = <String>[];
    if (current.isSigned != previous.isSigned) {
      buffer.add('N=${current.isSigned ? 1 : 0}');
    }
    if (current.isZero != previous.isZero) {
      buffer.add('Z=${current.isZero ? 1 : 0}');
    }
    if (current.isCarry != previous.isCarry) {
      buffer.add('C=${current.isCarry ? 1 : 0}');
    }
    if (current.isOverflow != previous.isOverflow) {
      buffer.add('V=${current.isCarry ? 1 : 0}');
    }
    if (current.thumbState != previous.thumbState) {
      buffer.add('T=${current.thumbState ? 1 : 0}');
    }
    _events.add('  ${buffer.join(', ')}');
  }

  @override
  void onInstructionSkipped(
    ArmInstruction instruction,
    Uint32 address,
    StatusRegister cpsr,
  ) {
    final decoded = instruction.accept(const ArmInstructionPrinter());
    final condition = instruction.condition.mnuemonic;
    final flags = [
      'N=${cpsr.isSigned ? 1 : 0}',
      'Z=${cpsr.isZero ? 1 : 0}',
      'C=${cpsr.isCarry ? 1 : 0}',
      'V=${cpsr.isOverflow ? 1 : 0}'
    ];
    _events.clear();
    _events.add(
      '\n@0x${address.value.toRadixString(16)}:'
      '\n$decoded ; skip, $condition :: ${flags.join(', ')}',
    );
  }

  @override
  void onMemoryRead(
    Uint32 address,
    Uint32 value,
  ) {
    final a = '0x${address.value.toRadixString(16)}';
    final v = '0x${value.value.toRadixString(16)}';
    _events.add('  @${a.padRight(10, ' ')} >> $v');
  }

  @override
  void onMemoryWrite(
    Uint32 address,
    Uint32 newValue,
  ) {
    final a = '0x${address.value.toRadixString(16)}';
    final v = '0x${newValue.value.toRadixString(16)}';
    _events.add('  @${a.padRight(10, ' ')} << $v');
  }

  @override
  void onRegisterRead(
    Register register,
    Uint32 value, {
    bool forcedUserMode,
  }) {
    final r = 'r${register.index.value}';
    final v = '0x${value.value.toRadixString(16)}';
    _events.add('  ${r.padRight(11, ' ')} >> $v');
  }

  @override
  void onRegisterWrite(
    Register register,
    Uint32 newValue, {
    bool forcedUserMode,
  }) {
    final r = 'r${register.index.value}';
    final v = '0x${newValue.value.toRadixString(16)}';
    _events.add('  ${r.padRight(11, ' ')} << $v');
  }
}
