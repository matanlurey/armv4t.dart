import 'package:armv4t/src/decoder/arm/condition.dart';
import 'package:armv4t/src/processor.dart';
import 'package:meta/meta.dart';

/// Provides functionality for evaluating instruction conditions.
@immutable
mixin ConditionEvaluator {
  /// Provides an implementation of the CPU to access registers and PSR.
  @protected
  Arm7Processor get cpu;

  /// Returns the result for the provided [condition] based on the current CPSR.
  bool evaluateCondition(Condition condition) {
    final psr = cpu.cpsr;
    switch (condition) {
      case Condition.eq: // Equal                 Z= = 1
        return psr.isZero;
      case Condition.ne: // Not Equal             Z == 0
        return !psr.isZero;
      case Condition.cs: // Unsigned Higher       C == 1
        return psr.isCarry;
      case Condition.cc: // Unsigned Lower        C == 0
        return !psr.isCarry;
      case Condition.mi: // Signed Negative       N == 1
        return psr.isSigned;
      case Condition.pl: // Signed Positive       N == 0
        return !psr.isSigned;
      case Condition.vs: // Signed Overflow       V == 1
        return psr.isOverflow;
      case Condition.vc: // Signed No Overflow    V == 0
        return !psr.isOverflow;
      case Condition.hi: // Unsigned Higher       C == 1 and Z == 0
        return psr.isCarry && !psr.isZero;
      case Condition.ls: // Unsigned Lower Same   C == 0 or Z == 1
        return !psr.isCarry || psr.isZero;
      case Condition.ge: // Signed Greater/Equal  N == V
        return psr.isSigned == psr.isOverflow;
      case Condition.lt: // Signed Less Than      N <> V
        return psr.isSigned != psr.isOverflow;
      case Condition.gt: // Signed Greater Than   Z == 0 and N == V
        return !psr.isZero && psr.isSigned == psr.isOverflow;
      case Condition.le: // Signed Less/Equal     Z == 1 or N <> V
        return psr.isZero || psr.isSigned != psr.isOverflow;
      case Condition.al: // Always
        return true;
      case Condition.nv: // Never
        return false;
      default:
        throw StateError('Unexpected condition: $condition');
    }
  }
}
