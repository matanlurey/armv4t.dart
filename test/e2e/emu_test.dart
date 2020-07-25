@TestOn('vm')
import 'dart:io';
import 'dart:typed_data';

import 'package:armv4t/armv4t.dart';
import 'package:armv4t/debug.dart';
import 'package:armv4t/decode.dart';
import 'package:path/path.dart' as path;
import 'package:test/test.dart';

void main() {
  test('arm0.asm', () async {
    final program = await _TestProgram.load('arm0');
    final results = program.run();

    expect(results[0x100], 5);
    expect(results[0x104], 0);
  });

  test('arm1.asm', () async {
    final program = await _TestProgram.load('arm1');
    final results = program.run();

    expect(results[0x100], 5);
    expect(results[0x104], 5);
    expect(results[0x108], 5);
  });
}

class _TestProgram {
  static Future<_TestProgram> load(String name) async {
    final bytes = File(path.join(
      'test',
      'e2e',
      'data',
      '$name.bin',
    )).readAsBytesSync();

    // Create 512 bytes, and add the program to the first N bytes.
    final space = Uint8List(512)..setRange(0, bytes.length, bytes);

    // Make the program itself memory protected.
    var memory = Memory.from(space);
    memory = Memory.protected(memory, readOnly: {0: bytes.length});
    return _TestProgram(memory, bytes.length);
  }

  final Memory _memory;
  final int _programSize;

  const _TestProgram(this._memory, this._programSize);
  Uint8List run({Arm7Processor cpu}) {
    cpu ??= Arm7Processor();
    final debugger = ArmDebugger(cpu);
    final vm = ArmVM(
      memory: _memory,
      cpu: cpu,
      debugHooks: debugger,
    );

    bool reachedEndOfProgram() => cpu.programCounter.value >= _programSize;

    while (true) {
      final next = vm.peek();

      try {
        if (reachedEndOfProgram() || !vm.step()) {
          break;
        }
        // ignore: avoid_print
        print(debugger.events.join('\n'));
      } catch (_) {
        // ignore: avoid_print
        print('Failed executing "${_disassemble(next)}"');
        rethrow;
      }
    }
    return _memory.copyBytes();
  }
}

String _disassemble(ArmInstruction instruction) {
  return instruction.accept(const ArmInstructionPrinter());
}
