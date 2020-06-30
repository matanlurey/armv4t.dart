@TestOn('vm')
import 'dart:io';
import 'dart:typed_data';

import 'package:armv4t/src/decode/arm/format.dart';
import 'package:armv4t/src/decode/arm/instruction.dart';
import 'package:armv4t/src/decode/arm/printer.dart';
import 'package:path/path.dart' as path;
import 'package:goldenrod/goldenrod.dart';
import 'package:test/test.dart';

// For every `.bin` file in this directory, we decode (dissasemble) the file
// into a .d.asm file. This test verifies that the ouput .d.asm files match what
// would be output (a sort of golden-file).
void main() async {
  final asmDir = Directory(path.join('test', 'decode', 'e2e', 'asm'));
  if (!await asmDir.exists()) {
    fail('Could not find ${asmDir.path}.');
  }

  await for (final file in asmDir.list()) {
    if (file is File && file.path.endsWith('.bin')) {
      await _testBin(file);
    }
  }
}

Future<void> _testBin(File file) async {
  /// Decodes an `ARM`-encoded 32-bit instruction.
  ArmInstruction decode(int bits) {
    final pattern = ArmInstructionSet.allFormats.match(bits);
    final format = ArmInstructionSet.mapDecoders[pattern];
    return format.decodeBits(bits).accept(const ArmDecoder());
  }

  test('${file.path}', () async {
    final bytes = await file.readAsBytes();
    final encoded = Uint32List.view(bytes.buffer);
    final printer = ArmInstructionPrinter();
    final output = '; Automatically generated\n\n' +
        encoded.map((e) {
          String s;
          try {
            final i = decode(e);
            s = i.accept(printer);
          } catch (e) {
            s = '???? <${e.runtimeType}>';
          }
          return '$s'.padRight(32) + '; 0x${e.toRadixString(16)}';
        }).join('\n');
    final outputPath = path.withoutExtension(file.path) + '.out';
    expect(output, await matchesGoldenText(file: outputPath));
  });
}
