import 'package:armv4t/src/interpreter.dart';
import 'package:armv4t/src/processor.dart';
import 'package:binary/binary.dart';
import 'package:test/test.dart';

class TestOperandEvaluator with OperandEvaluator {
  @override
  final Arm7Processor cpu;

  TestOperandEvaluator(this.cpu);
}

void main() {
  TestOperandEvaluator evaluator;

  test('...', () {
    evaluator.arithmeticShiftRight(Uint32.zero, 0);
  });
}
