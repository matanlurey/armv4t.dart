@TestOn('vm')
import 'dart:io';
import 'dart:typed_data';

import 'package:armv4t/armv4t.dart';
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
    final program = await _TestProgram.load('arm0');
    final results = program.run();

    expect(results[0x100], 5);
    expect(results[0x104], 5);
    expect(results[0x108], 5);
  }, solo: true);
}

class _TestProgram {
  static Future<_TestProgram> load(String name) async {
    final bytes = await File(path.join(
      'test',
      'e2e',
      'data',
      '$name.bin',
    )).readAsBytes();
    return _TestProgram(Memory.from(bytes));
  }

  final Memory _memory;

  const _TestProgram(this._memory);

  Uint8List run({Arm7Processor cpu}) {
    final vm = ArmVM(memory: _memory, cpu: cpu);
    while (true) {
      final next = vm.peek();

      try {
        if (!vm.step()) {
          break;
        }
        print(_disassemble(next));
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
