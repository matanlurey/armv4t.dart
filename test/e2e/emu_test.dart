@TestOn('vm')
import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:armv4t/armv4t.dart';
import 'package:armv4t/debug.dart';
import 'package:armv4t/decode.dart';
import 'package:path/path.dart' as path;
import 'package:test/test.dart';

void main() {
  Uint32List results;

  int read(int address) => results[address ~/ 4];

  test('arm0.asm', () async {
    final program = await _TestProgram.load('arm0');
    results = program.run();

    expect(read(0x100), 5);
    expect(read(0x104), 0);
  });

  test('arm1.asm', () async {
    final program = await _TestProgram.load('arm1');
    results = program.run();

    expect(read(0x100), 5);
    expect(read(0x104), 5);
    expect(read(0x108), 5);
  });

  test('arm2.asm', () async {
    final program = await _TestProgram.load('arm2');
    results = program.run();

    expect(read(0x100), 6);
    expect(read(0x104), 0x200000e1);
    expect(read(0x108), 0xe100001c);
  });

  test('arm3.asm', () async {
    final program = await _TestProgram.load('arm3');
    results = program.run();

    expect(read(0x100), 64);
  });

  test('arm4.asm', () async {
    final program = await _TestProgram.load('arm4');
    results = program.run();

    expect(read(0x100), 6);
    expect(read(0x104), 0x200000e1);
    expect(read(0x108), 0xe100001c);
    expect(read(0x10c), 6);
    expect(read(0x110), 6 * 0x100);
  });

  test('arm5.asm', () async {
    final program = await _TestProgram.load('arm5');
    results = program.run();

    expect(read(0x100), 0xf000);
    expect(read(0x104), 0xfff0);
    expect(read(0x108), 0x104);
  });

  test('arm6.asm', () async {
    final program = await _TestProgram.load('arm6');
    results = program.run();

    expect(read(0x1f4), 0xa);
    expect(read(0x1f8), 0xc);
    expect(read(0x1fc), 0x10);
    expect(read(0x200), 6);
    expect(read(0x204), 0x200);
  }, skip: 'Currently fails: Might need to support reading half-word address');

  test('arm7.asm', () async {
    final program = await _TestProgram.load('arm7');
    results = program.run();

    expect(read(0x1fc), 1);
    expect(read(0x200), 1);
    expect(read(0x204), 0x200);
  }, skip: 'Currently fails: Unknown reasons, likely bugs in STM');

  test('arm8.asm', () async {
    final program = await _TestProgram.load('arm8');
    results = program.run();

    expect(read(0x200), 10);
    expect(read(0x204), 83);
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

    // Create 1024 bytes, and add the program to the first N bytes.
    final space = Uint8List(1024)..setRange(0, bytes.length, bytes);

    // Make the program itself memory protected.
    var memory = Memory.from(space);
    memory = Memory.protected(memory, readOnly: {0: bytes.length});
    return _TestProgram(memory, bytes.length);
  }

  final Memory _memory;
  final int _programSize;

  const _TestProgram(this._memory, this._programSize);

  Uint32List run({Arm7Processor cpu}) {
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
    return _memory.copyBytes().buffer.asUint32List();
  }
}

String _disassemble(ArmInstruction instruction) {
  return instruction.accept(const ArmInstructionPrinter());
}
