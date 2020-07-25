// ignore_for_file: avoid_print

@TestOn('vm')
import 'dart:io';
import 'dart:typed_data';

import 'package:armv4t/armv4t.dart';
import 'package:armv4t/src/emulator/debugger.dart';
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
  ArmDebugger debugger;

  void start(int a, int b, Uint8List program) {
    cpu = Arm7Processor()
      ..[0] = Uint32(a)
      ..[1] = Uint32(b);

    debugger = ArmDebugger(cpu);
    vm = ArmVM(
      cpu: cpu,
      memory: Memory.from(program),
      debugHooks: debugger,
    );
  }

  int count = 0;

  setUp(() {
    count = 0;
  });

  void execute() {
    // TODO(https://github.com/matanlurey/armv4t.dart/issues/61).
    if (count++ > 100) {
      fail('Program may never complete. There might be a bug or error');
    }

    if (vm.step()) {
      print(debugger.events.join('\n'));
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
