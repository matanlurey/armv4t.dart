import 'package:armv4t/decode.dart';
import 'package:meta/meta.dart';

import 'processor.dart';
import 'interpreter.dart';
import 'memory.dart';

/// An ARMv4T Virtual Machine.
@sealed
class ArmVM {
  /// Processor and register state.
  final Arm7Processor _cpu;

  /// Memory state.
  final Memory _memory;

  /// ARM interpreter.
  final ArmInterpreter _interpreter;

  /// Creates a virtual machine with the provided [memory].
  ///
  /// Optionally, may specify an initial [cpu] state.
  factory ArmVM({
    Arm7Processor cpu,
    @required Memory memory,
  }) {
    ArgumentError.checkNotNull(memory, 'memory');
    cpu ??= Arm7Processor();
    return ArmVM._(cpu, memory, ArmInterpreter(cpu, memory));
  }

  const ArmVM._(
    this._cpu,
    this._memory,
    this._interpreter,
  );

  /// Returns the next instruction to be executed.
  ArmInstruction peek() {
    ArmInstruction result;
    final address = _cpu.programCounter;
    if (_cpu.cpsr.thumbState) {
      final opCode = _memory.loadHalfWord(address);
      result = ThumbToArmDecoder().convert(opCode);
    } else {
      final opCode = _memory.loadWord(address);
      final format = const ArmFormatDecoder().convert(opCode);
      result = format.accept(const ArmInstructionDecoder());
    }
    return result;
  }

  /// Runs the next instruction, if any.
  ///
  /// Returns whether the program can continue (i.e. is not at the end).
  bool step() {
    _interpreter.step(peek());
    return !_interpreter.atEndOfMemory;
  }
}
