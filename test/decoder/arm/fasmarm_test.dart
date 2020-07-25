@TestOn('vm')
library armv4t.test.decoder.arm.fasmarm_test;

import 'dart:io';
import 'dart:typed_data';

import 'package:armv4t/src/decoder/arm/format.dart';
import 'package:armv4t/src/decoder/arm/instruction.dart';
import 'package:armv4t/src/decoder/arm/printer.dart';
import 'package:binary/binary.dart';
import 'package:goldenrod/goldenrod.dart';
import 'package:path/path.dart' as path;
import 'package:test/test.dart';

void main() {
  String disassemble(Uint32 bits) {
    final format = const ArmFormatDecoder().convert(bits);
    final decode = format.accept(const ArmInstructionDecoder());
    return decode.accept(const ArmInstructionPrinter());
  }

  [
    'arithmetic',
    'conditions',
    'logical',
    'memory',
    'multiply',
    'others',
  ].forEach((key) {
    test('$key.bin ($key.asm) -> $key.golden.asm', () async {
      final bytes = await File(path.join(
        'test',
        'decoder',
        'arm',
        'fasmarm',
        '$key.bin',
      )).readAsBytes();

      final input = Uint32List.view(bytes.buffer);
      final output = input
          .map((b) => Uint32(b))
          .map((i) => ''
              '${disassemble(i).padRight(32, ' ')} '
              ';${i.value.toRadixString(16)}')
          .join('\n');
      final golden = path.join(
        'test',
        'decoder',
        'arm',
        'fasmarm',
        '$key.golden.asm',
      );
      expect(output, await matchesGoldenText(file: golden));
    });
  });
}
