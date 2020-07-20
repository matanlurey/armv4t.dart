import 'package:armv4t/armv4t.dart';
import 'package:armv4t/src/decoder/arm/condition.dart';
import 'package:armv4t/src/emulator/condition.dart';
import 'package:armv4t/src/emulator/processor.dart';
import 'package:test/test.dart';

class TestConditionEvaluator with ConditionEvaluator {
  @override
  final Arm7Processor cpu;

  TestConditionEvaluator(this.cpu);
}

void main() {
  Arm7Processor cpu;
  TestConditionEvaluator evaluator;

  setUp(() {
    cpu = Arm7Processor();
    evaluator = TestConditionEvaluator(cpu);
  });

  test('EQ', () {
    final condition = Condition.eq;

    expect(evaluator.evaluateCondition(condition), isFalse);

    cpu.cpsr = cpu.cpsr.update(isZero: true);
    expect(evaluator.evaluateCondition(condition), isTrue);
  });

  test('NE', () {
    final condition = Condition.ne;

    expect(evaluator.evaluateCondition(condition), isTrue);

    cpu.cpsr = cpu.cpsr.update(isZero: true);
    expect(evaluator.evaluateCondition(condition), isFalse);
  });

  test('CS', () {
    final condition = Condition.cs;

    expect(evaluator.evaluateCondition(condition), isFalse);

    cpu.cpsr = cpu.cpsr.update(isCarry: true);
    expect(evaluator.evaluateCondition(condition), isTrue);
  });

  test('CC', () {
    final condition = Condition.cc;

    expect(evaluator.evaluateCondition(condition), isTrue);

    cpu.cpsr = cpu.cpsr.update(isCarry: true);
    expect(evaluator.evaluateCondition(condition), isFalse);
  });

  test('MI', () {
    final condition = Condition.mi;

    expect(evaluator.evaluateCondition(condition), isFalse);

    cpu.cpsr = cpu.cpsr.update(isSigned: true);
    expect(evaluator.evaluateCondition(condition), isTrue);
  });

  test('PL', () {
    final condition = Condition.pl;

    expect(evaluator.evaluateCondition(condition), isTrue);

    cpu.cpsr = cpu.cpsr.update(isSigned: true);
    expect(evaluator.evaluateCondition(condition), isFalse);
  });

  test('VS', () {
    final condition = Condition.vs;

    expect(evaluator.evaluateCondition(condition), isFalse);

    cpu.cpsr = cpu.cpsr.update(isOverflow: true);
    expect(evaluator.evaluateCondition(condition), isTrue);
  });

  test('VC', () {
    final condition = Condition.vc;

    expect(evaluator.evaluateCondition(condition), isTrue);

    cpu.cpsr = cpu.cpsr.update(isOverflow: true);
    expect(evaluator.evaluateCondition(condition), isFalse);
  });

  test('HI', () {
    final condition = Condition.hi;

    expect(evaluator.evaluateCondition(condition), isFalse);

    cpu.cpsr = cpu.cpsr.update(isCarry: true);
    expect(evaluator.evaluateCondition(condition), isTrue);

    cpu.cpsr = cpu.cpsr.update(isZero: true);
    expect(evaluator.evaluateCondition(condition), isFalse);
  });

  test('LS', () {
    final condition = Condition.ls;

    expect(evaluator.evaluateCondition(condition), isTrue);

    cpu.cpsr = cpu.cpsr.update(isCarry: true, isZero: true);
    expect(evaluator.evaluateCondition(condition), isTrue);

    cpu.cpsr = cpu.cpsr.update(isZero: false);
    expect(evaluator.evaluateCondition(condition), isFalse);
  });

  test('GE', () {
    final condition = Condition.ge;

    expect(evaluator.evaluateCondition(condition), isTrue);

    cpu.cpsr = cpu.cpsr.update(isSigned: true);
    expect(evaluator.evaluateCondition(condition), isFalse);

    cpu.cpsr = cpu.cpsr.update(isOverflow: true);
    expect(evaluator.evaluateCondition(condition), isTrue);
  });

  test('LT', () {
    final condition = Condition.lt;

    expect(evaluator.evaluateCondition(condition), isFalse);

    cpu.cpsr = cpu.cpsr.update(isSigned: true);
    expect(evaluator.evaluateCondition(condition), isTrue);

    cpu.cpsr = cpu.cpsr.update(isOverflow: true);
    expect(evaluator.evaluateCondition(condition), isFalse);
  });

  test('GT', () {
    final condition = Condition.gt;

    expect(evaluator.evaluateCondition(condition), isTrue);

    cpu.cpsr = cpu.cpsr.update(isZero: true);
    expect(evaluator.evaluateCondition(condition), isFalse);

    cpu.cpsr = cpu.cpsr.update(isOverflow: true, isSigned: true);
    expect(evaluator.evaluateCondition(condition), isFalse);

    cpu.cpsr = cpu.cpsr.update(isZero: false);
    expect(evaluator.evaluateCondition(condition), isTrue);
  });

  test('LE', () {
    final condition = Condition.le;

    expect(evaluator.evaluateCondition(condition), isFalse);

    cpu.cpsr = cpu.cpsr.update(isZero: true);
    expect(evaluator.evaluateCondition(condition), isTrue);

    cpu.cpsr = cpu.cpsr.update(isZero: false, isOverflow: true, isSigned: true);
    expect(evaluator.evaluateCondition(condition), isFalse);

    cpu.cpsr = cpu.cpsr.update(isSigned: false);
    expect(evaluator.evaluateCondition(condition), isTrue);
  });

  test('AL', () => expect(evaluator.evaluateCondition(Condition.al), isTrue));

  test('NV', () => expect(evaluator.evaluateCondition(Condition.nv), isFalse));
}
