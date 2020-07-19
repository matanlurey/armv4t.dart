@TestOn('vm')
import 'dart:io';
import 'dart:typed_data';

import 'package:armv4t/decode.dart';
import 'package:binary/binary.dart';
import 'package:path/path.dart' as path;
import 'package:test/test.dart';

void main() {
  Uint8List program;

  String disassemble(Uint32 bits) {
    final format = const ArmFormatDecoder().convert(bits);
    final decode = format.accept(const ArmInstructionDecoder());
    return decode.accept(const ArmInstructionPrinter());
  }

  // Uses branches for conditional logic only.
  group('gcd.branches.asm', () {
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
        opcodes.map((v) => Uint32(v)).map(disassemble).join('\n'),
        [
          'cmp r0, r1',
          'beq 4',
          'blt 1',
          'sub r0, r0, r1',
          'b -6',
          'sub r1, r1, r0',
          'b -8',
        ].join('\n'),
      );
    });
  });

  // USes conditional execution.
  group('gcd.conditional.asm', () {
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
        opcodes.map((v) => Uint32(v)).map(disassemble).join('\n'),
        [
          'cmp r0, r1',
          'subgt r0, r0, r1',
          'sublt r1, r1, r0',
          'bne -5',
        ].join('\n'),
      );
    });
  });
}
