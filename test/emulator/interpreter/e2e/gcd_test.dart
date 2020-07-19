// ignore_for_file: avoid_print

@TestOn('vm')
import 'dart:io';
import 'dart:typed_data';

import 'package:armv4t/armv4t.dart';
import 'package:armv4t/decode.dart';
import 'package:binary/binary.dart';
import 'package:path/path.dart' as path;
import 'package:test/test.dart';

// TODO: Refactor some of this code into a general purpose emulator class.
void main() {
  ArmInterpreter interpreter;
  Arm7Processor cpu;
  Memory memory;

  String disassemble(Uint32 bits) {
    final format = const ArmFormatDecoder().convert(bits);
    final decode = format.accept(const ArmInstructionDecoder());
    return decode.accept(const ArmInstructionPrinter());
  }

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

  void start(int a, int b, Uint8List program) {
    cpu = Arm7Processor();
    cpu[0] = Uint32(a);
    cpu[1] = Uint32(b);
    final pc = 'pc'.padRight(16, ' ');
    final r0 = 'r0'.padRight(16, ' ');
    final r1 = 'r1'.padRight(16, ' ');
    print('$pc$r0$r1' 'Instruction');
    print(''.padRight(16 * 5, '-'));

    interpreter = ArmInterpreter(cpu, memory = Memory(64, data: program));
  }

  int limit;

  setUp((() => limit = 20));

  void execute(int eof) {
    if (limit-- == 0) {
      throw StateError('Program executed more than 20 instructions');
    }

    final c = cpu.programCounter.value;
    final p = ('0x' + c.toString()).padRight(16, ' ');
    final a = cpu[0].value.toString().padRight(16, ' ');
    final b = cpu[1].value.toString().padRight(16, ' ');
    final i = memory.loadWord(cpu.programCounter);
    print('$p$a$b' '${disassemble(i)}');

    final f = const ArmFormatDecoder().convert(i);
    final d = f.accept(const ArmInstructionDecoder());
    interpreter.execute(d);

    if ((cpu.programCounter.value + 4) ~/ 4 >= eof) {
      print(''.padRight(16 * 5, '-'));
      print('EXIT @ ${cpu.programCounter.value}');
      return;
    } else {
      if (cpu.programCounter.value == c) {
        // TODO: This is a hack - we want to let branch instructions set the
        // program counter, but currently no other instruction attempts to
        // increment the program counter.
        //
        // Remove after https://github.com/matanlurey/armv4t.dart/issues/58.
        cpu.programCounter = Uint32(cpu.programCounter.value + 4);
      }
      execute(eof);
    }
  }

  // Uses branches for conditional logic only.
  group('gcd.branches.asm', () {
    Uint8List program;

    setUpAll(() async {
      program = await File(
        path.join(
          'test',
          'emulator',
          'interpreter',
          'e2e',
          'gcd.branches.bin',
        ),
      ).readAsBytes();
    });

    test('[disassembled]', () {
      final opcodes = Uint32List.view(program.buffer);
      expect(
        opcodes.map((v) => Uint32(v)).map(disassemble),
        [
          'cmp r0, r1',
          'beq 4',
          'blt 1',
          'sub r0, r0, r1',
          'b -6',
          'sub r1, r1, r0',
          'b -8',
        ],
      );
    });

    test('gcd(54, 24)', () {
      final expected = 6;
      expect(expected, gcd(54, 24), reason: 'Verify reference implementation');
      start(54, 24, program);
      execute(6);

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
          'emulator',
          'interpreter',
          'e2e',
          'gcd.conditional.bin',
        ),
      ).readAsBytes();
    });

    test('[disassembled]', () {
      final opcodes = Uint32List.view(program.buffer);
      expect(
        opcodes.map((v) => Uint32(v)).map(disassemble),
        [
          'cmp r0, r1',
          'subgt r0, r0, r1',
          'sublt r1, r1, r0',
          'bne -5',
        ],
      );
    });

    test('gcd(54, 24)', () {
      final expected = 6;
      expect(expected, gcd(54, 24), reason: 'Verify reference implementation');
      start(54, 24, program);
      execute(4);

      expect(cpu[0], Uint32(expected), reason: 'Found GCD');
    }, skip: 'Not yet working');
  });
}
