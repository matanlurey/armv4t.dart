@TestOn('vm')
import 'dart:io';

import 'package:armv4t/src/decode/arm/format.dart';
import 'package:armv4t/src/decode/arm/instruction.dart';
import 'package:armv4t/src/decode/arm/printer.dart';
import 'package:armv4t/src/decode/program/flat.dart';
import 'package:goldenrod/goldenrod.dart';
import 'package:path/path.dart' as path;
import 'package:test/test.dart';

void main() {
  FlatBinaryProgram program;

  setUpAll(() async {
    program = FlatBinaryProgram.fromBytes(await File(path.join(
      'test',
      '_data',
      'InstructionFormatsARM.bin',
    )).readAsBytes());
  });

  /// Decodes an `ARM`-encoded 32-bit instruction.
  ArmInstruction decodeARM(int bits) {
    final pattern = ArmInstructionSet.allFormats.match(bits);
    final format = ArmInstructionSet.mapDecoders[pattern];
    return format.decodeBits(bits).accept(const ArmDecoder());
  }

  test('should match the golden output once disassembled', () async {
    final buffer = StringBuffer();
    final printer = ArmInstructionPrinter();
    while (program.position < program.length - 4) {
      final position = program.position.toRadixString(16).padLeft(8, '0');
      final bytes = program.read32();
      String text;
      try {
        text = decodeARM(bytes).accept(printer).padRight(40, ' ');
      } catch (e) {
        final pattern = ArmInstructionSet.allFormats.match(bytes);
        final format = ArmInstructionSet.mapDecoders[pattern];
        final runtime = format.runtimeType.toString();
        final parsed = runtime.substring(
          runtime.indexOf('<', 1) + 1,
          runtime.indexOf('>'),
        );
        text = '<!CRASH!: ${parsed}>'.padRight(40, ' ');
      }
      final debug = bytes.toRadixString(16).padLeft(8, '0');
      buffer.writeln('$position: $text ;$debug');
    }
    expect(
      buffer.toString(),
      await matchesGoldenText(
        file: path.join(
          'test',
          'decode',
          'program',
          'instruction_formats_arm_test.out',
        ),
      ),
    );
  });
}
