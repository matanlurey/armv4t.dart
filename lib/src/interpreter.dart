import 'package:armv4t/decode.dart';
import 'package:armv4t/src/processor.dart';
import 'package:binary/binary.dart';
import 'package:meta/meta.dart';

/// Provides functionality for evaluating operand values.
@immutable
@visibleForTesting
mixin OperandEvaluator {
  /// Provides an implementation of the CPU to access registers and PSR.
  Arm7Processor get cpu;

  /// Returns the result for the provided [immediate] value.
  Uint32 evaluateImmediate(ShiftedImmediate immediate) {
    return Uint32.zero;
  }

  /// Returns the result for the provided [register] shifted by an immediate.
  Uint32 evaluateShiftRegister(ShiftedRegister<Immediate, Register> register) {
    return Uint32.zero;
  }

  /// Returns the result for the provided [register] shifted by a register.
  Uint32 evaluateRegisters(ShiftedRegister<Register, Register> register) {
    return Uint32.zero;
  }
}
