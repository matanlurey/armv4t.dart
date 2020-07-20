import 'package:armv4t/src/emulator/operand.dart';
import 'package:armv4t/src/emulator/processor.dart';
import 'package:binary/binary.dart';
import 'package:test/test.dart';

class TestOperandEvaluator with OperandEvaluator {
  @override
  final Arm7Processor cpu;

  TestOperandEvaluator(this.cpu);
}

void main() {
  Arm7Processor cpu;
  TestOperandEvaluator evaluator;

  setUp(() {
    cpu = Arm7Processor();
    evaluator = TestOperandEvaluator(cpu);
  });

  group('arithmeticShiftRight', () {
    group('should shift to right, adding 1s as MSB', () {
      //          MSB/Sign                                          MSB Discard
      //          V                                                 V
      final i = ('1000' '0000' '0000' '0000' '0000' '0000' '0000' '1100').bits;
      final o = ('1111' '0000' '0000' '0000' '0000' '0000' '0000' '0001').bits;
      //          ^^^
      //          Replicated

      test('(No Carry)', () {
        expect(
          evaluator.arithmeticShiftRight(Uint32(i), 3),
          Uint32(o),
          reason: '${i.toBinaryPadded(32)}\n${o.toBinaryPadded(32)}',
        );
        expect(cpu.cpsr.isCarry, isFalse);
      });

      test('(Carry MSB Discard Bit)', () {
        expect(
          evaluator.arithmeticShiftRight(Uint32(i), 3, setFlags: true),
          Uint32(o),
          reason: '${i.toBinaryPadded(32)}\n${o.toBinaryPadded(32)}',
        );
        expect(cpu.cpsr.isCarry, isTrue);
      });
    });

    group('should shift to right, adding 0s as MSB', () {
      //          MSB/Sign                                          MSB Discard
      //          V                                                 V
      final i = ('0100' '0000' '0000' '0000' '0000' '0000' '0000' '1100').bits;
      final o = ('0000' '1000' '0000' '0000' '0000' '0000' '0000' '0001').bits;
      //          ^^^
      //          Replicated

      test('(No Carry)', () {
        expect(
          evaluator.arithmeticShiftRight(Uint32(i), 3),
          Uint32(o),
          reason: '${i.toBinaryPadded(32)}\n${o.toBinaryPadded(32)}',
        );
        expect(cpu.cpsr.isCarry, isFalse);
      });

      test('(Carry MSB Discard Bit)', () {
        expect(
          evaluator.arithmeticShiftRight(Uint32(i), 3, setFlags: true),
          Uint32(o),
          reason: '${i.toBinaryPadded(32)}\n${o.toBinaryPadded(32)}',
        );
        expect(cpu.cpsr.isCarry, isTrue);
      });
    });

    test('should special case ASR 0 as ASR 32, MSB = 0', () {
      //          MSB/Sign
      //          V
      final i = ('0100' '0000' '0000' '0000' '0000' '0000' '0000' '1100').bits;
      final o = ('0000' '0000' '0000' '0000' '0000' '0000' '0000' '0000').bits;
      //          ^^^^   ^^^^   ^^^^   ^^^^   ^^^^   ^^^^   ^^^^   ^^^^
      //          Replicated
      expect(
        evaluator.arithmeticShiftRight(Uint32(i), 0),
        Uint32(o),
        reason: '${i.toBinaryPadded(32)}\n${o.toBinaryPadded(32)}',
      );
      expect(cpu.cpsr.isCarry, isFalse);
    });

    test('should special case ASR 0 as ASR 32, MSB = 1', () {
      //          MSB/Sign
      //          V
      final i = ('1100' '0000' '0000' '0000' '0000' '0000' '0000' '1100').bits;
      final o = ('1111' '1111' '1111' '1111' '1111' '1111' '1111' '1111').bits;
      //          ^^^^   ^^^^   ^^^^   ^^^^   ^^^^   ^^^^   ^^^^   ^^^^
      //          Replicated
      expect(
        evaluator.arithmeticShiftRight(Uint32(i), 0),
        Uint32(o),
        reason: '${i.toBinaryPadded(32)}\n${o.toBinaryPadded(32)}',
      );
      expect(cpu.cpsr.isCarry, isTrue);
    });
  });

  group('logicalShiftRight', () {
    group('should shift to right, adding 0s as the MSB', () {
      //                                                            MSB Discard
      //                                                            V
      final i = ('0100' '0000' '0000' '0000' '0000' '0000' '0000' '1100').bits;
      final o = ('0000' '1000' '0000' '0000' '0000' '0000' '0000' '0001').bits;
      //          ^^^
      //          Replicated

      test('(No Carry)', () {
        expect(
          evaluator.logicalShiftRight(Uint32(i), 3),
          Uint32(o),
          reason: '${i.toBinaryPadded(32)}\n${o.toBinaryPadded(32)}',
        );
        expect(cpu.cpsr.isCarry, isFalse);
      });

      test('(Carry)', () {
        expect(
          evaluator.logicalShiftRight(Uint32(i), 3, setFlags: true),
          Uint32(o),
          reason: '${i.toBinaryPadded(32)}\n${o.toBinaryPadded(32)}',
        );
        expect(cpu.cpsr.isCarry, isTrue);
      });
    });

    test('should special case LSR 0 as LSR 32', () {
      //          MSB
      //          v
      final i = ('1100' '0000' '0000' '0000' '0000' '0000' '0000' '1100').bits;
      final o = ('0000' '0000' '0000' '0000' '0000' '0000' '0000' '0000').bits;
      //          ^^^^   ^^^^   ^^^^   ^^^^   ^^^^   ^^^^   ^^^^   ^^^^
      //          Cleared

      expect(
        evaluator.logicalShiftRight(Uint32(i), 0),
        Uint32(o),
      );
      expect(cpu.cpsr.isCarry, isTrue);
    });
  });

  group('logicalShiftLeft', () {
    group('should shift to left, adding 0s as the LSB', () {
      //            MSB Discard                                     Shifted
      //            v                                               vvv
      final i = ('0010' '0000' '0000' '0000' '0000' '0000' '0000' '0100').bits;
      final o = ('0000' '0000' '0000' '0000' '0000' '0000' '0010' '0000').bits;
      //                                                            ^^^
      //                                                            Cleared

      test('(No Carry)', () {
        expect(
          evaluator.logicalShiftLeft(Uint32(i), 3),
          Uint32(o),
          reason: '${i.toBinaryPadded(32)}\n${o.toBinaryPadded(32)}',
        );
        expect(cpu.cpsr.isCarry, isFalse);
      });

      test('(Carry)', () {
        expect(
          evaluator.logicalShiftLeft(Uint32(i), 3, setFlags: true),
          Uint32(o),
          reason: '${i.toBinaryPadded(32)}\n${o.toBinaryPadded(32)}',
        );
        expect(cpu.cpsr.isCarry, isTrue);
      });
    });

    test('should special case LSL 0 as no shift', () {
      final i = ('1100' '0000' '0000' '0000' '0000' '0000' '0000' '1100').bits;

      expect(
        evaluator.logicalShiftLeft(Uint32(i), 0, setFlags: true),
        Uint32(i),
      );
      expect(cpu.cpsr.isCarry, isFalse);
    });
  });

  group('rotateRightShift', () {
    group('should move bits to right, setting LSB as MSB', () {
      final i = ('0000' '0000' '0000' '0000' '0000' '0000' '0000' '0111').bits;
      final o = ('1100' '0000' '0000' '0000' '0000' '0000' '0000' '0001').bits;

      test('(No Carry', () {
        final result = evaluator.rotateRightShift(Uint32(i), 2);
        expect(
          result,
          Uint32(o),
          reason: ''
              '${Uint32(i).toBinaryPadded()} (Input) ROR 2\n'
              '${Uint32(o).toBinaryPadded()} (Expected) !=\n'
              '${result.toBinaryPadded()} (Actual)',
        );
        expect(cpu.cpsr.isCarry, isFalse);
      });

      test('(Carry)', () {
        final result = evaluator.rotateRightShift(Uint32(i), 2, setFlags: true);
        expect(
          result,
          Uint32(o),
          reason: ''
              '${Uint32(i).toBinaryPadded()} (Input) ROR 2\n'
              '${Uint32(o).toBinaryPadded()} (Expected) !=\n'
              '${result.toBinaryPadded()} (Actual)',
        );
        expect(cpu.cpsr.isCarry, isTrue);
      });
    });

    group('should special case ROR 0 as RRX', () {
      final i = ('1000' '0000' '0000' '0000' '0000' '0000' '0000' '0001').bits;
      final o = ('0100' '0000' '0000' '0000' '0000' '0000' '0000' '0000').bits;

      test('(No Carry)', () {
        final result = evaluator.rotateRightShift(Uint32(i), 0);
        expect(
          result,
          Uint32(o),
          reason: ''
              '${Uint32(i).toBinaryPadded()} (Input) RRX\n'
              '${Uint32(o).toBinaryPadded()} (Expected) !=\n'
              '${result.toBinaryPadded()} (Actual)',
        );
        expect(cpu.cpsr.isCarry, isFalse);
      });
      test('(Carry)', () {
        final result = evaluator.rotateRightShift(Uint32(i), 0, setFlags: true);
        expect(
          result,
          Uint32(o),
          reason: ''
              '${Uint32(i).toBinaryPadded()} (Input) RRX\n'
              '${Uint32(o).toBinaryPadded()} (Expected) !=\n'
              '${result.toBinaryPadded()} (Actual)',
        );
        expect(cpu.cpsr.isCarry, isTrue);
      });
    });

    test('should special case ROR 0 as RRX, move oldCarry -> MSB', () {
      // Initialize carry = 1.
      cpu.cpsr = cpu.cpsr.update(isCarry: true);

      final i = ('1000' '0000' '0000' '0000' '0000' '0000' '0000' '0000').bits;
      final o = ('1100' '0000' '0000' '0000' '0000' '0000' '0000' '0000').bits;
      final result = evaluator.rotateRightShift(Uint32(i), 0, setFlags: true);

      expect(
        result,
        Uint32(o),
        reason: ''
            '${Uint32(i).toBinaryPadded()} (Input) RRX\n'
            '${Uint32(o).toBinaryPadded()} (Expected) !=\n'
            '${result.toBinaryPadded()} (Actual)',
      );
      expect(cpu.cpsr.isCarry, isFalse);
    });
  });
}
