// ignore_for_file: avoid_print

@TestOn('vm')
import 'dart:io';
import 'dart:typed_data';

import 'package:armv4t/armv4t.dart';
import 'package:armv4t/decode.dart';
import 'package:binary/binary.dart';
import 'package:path/path.dart' as path;
import 'package:test/test.dart';

void main() {
  ArmVM vm;

  /// Reference implementation of greatest-common-denominator (gcd).
  int gcd(int a, int b) {
    while (a != b) {
      if (a > b) {
        a -= b;
      } else {
        b -= a;
      }
    }
    return a;
  }

  Arm7Processor cpu;

  void start(int a, int b, Uint8List program) {
    cpu = Arm7Processor()
      ..[0] = Uint32(a)
      ..[1] = Uint32(b);

    // TODO(https://github.com/matanlurey/armv4t.dart/issues/33): Remove.
    final pc = 'pc'.padRight(16, ' ');
    final r0 = 'r0'.padRight(16, ' ');
    final r1 = 'r1'.padRight(16, ' ');
    print('$pc$r0$r1' 'Instruction');
    print(''.padRight(16 * 5, '-'));

    vm = ArmVM(
      cpu: cpu,
      memory: Memory.from(program),
    );
  }

  int count = 0;

  setUp(() {
    count = 0;
  });

  void execute() {
    String disassemble(ArmInstruction instruction) {
      return instruction.accept(const ArmInstructionPrinter());
    }

    final c = cpu.programCounter.value;
    final p = ('0x' + c.toString()).padRight(16, ' ');
    final a = cpu[0].value.toString().padRight(16, ' ');
    final b = cpu[1].value.toString().padRight(16, ' ');
    final i = vm.peek();
    print('$p$a$b' '${disassemble(i)}');

    if (count++ > 100) {
      fail('Program may never complete. There might be a bug or error');
    }

    if (vm.step()) {
      execute();
    }
  }

  // Uses branches for conditional logic only.
  group('gcd.branches.asm', () {
    Uint8List program;

    setUpAll(() async {
      program = await File(
        path.join(
          'test',
          'e2e',
          'gcd.branches.bin',
        ),
      ).readAsBytes();
    });

    test('gcd(54, 24)', () {
      final expected = 6;
      expect(expected, gcd(54, 24), reason: 'Verify reference implementation');
      start(54, 24, program);
      execute();

      expect(cpu[0], Uint32(expected), reason: 'Found GCD');
    });
  });

  // Uses conditional execution.
  group('gcd.conditional.asm', () {
    Uint8List program;

    setUpAll(() async {
      program = await File(
        path.join(
          'test',
          'e2e',
          'gcd.conditional.bin',
        ),
      ).readAsBytes();
    });

    test('gcd(54, 24)', () {
      final expected = 6;
      expect(expected, gcd(54, 24), reason: 'Verify reference implementation');
      start(54, 24, program);
      execute();

      expect(cpu[0], Uint32(expected), reason: 'Found GCD');
    });
  });

  group('gcd.thumb.asm', () {
    Uint8List program;

    setUpAll(() async {
      program = await File(
        path.join(
          'test',
          'e2e',
          'gcd.thumb.bin',
        ),
      ).readAsBytes();
    });

    test('gcd(54, 24)', () {
      final expected = 6;
      expect(expected, gcd(54, 24), reason: 'Verify reference implementation');
      start(54, 24, program);
      execute();

      expect(cpu[0], Uint32(expected), reason: 'Found GCD');
    });
  });
}
