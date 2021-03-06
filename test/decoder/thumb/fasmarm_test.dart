@TestOn('vm')
library armv4t.test.decoder.thumb.fasmarm_test;

import 'dart:io';
import 'dart:typed_data';

import 'package:armv4t/src/decoder/arm/printer.dart';
import 'package:armv4t/src/decoder/thumb/converter.dart';
import 'package:binary/binary.dart';
import 'package:goldenrod/goldenrod.dart';
import 'package:path/path.dart' as path;
import 'package:test/test.dart';

void main() {
  String disassemble(Uint16 bits) {
    final decode = const ThumbToArmDecoder().convert(bits);
    return decode.accept(const ArmInstructionPrinter());
  }

  test('bin (asm) -> golden.asm', () async {
    final bytes = await File(path.join(
      'test',
      'decoder',
      'thumb',
      'fasmarm_test.bin',
    )).readAsBytes();

    final input = Uint16List.view(bytes.buffer);
    final output = input.map((b) => Uint16(b)).map((i) {
      final out = ''
          '${disassemble(i).padRight(32, ' ')} '
          ';0x${i.value.toRadixString(16).padLeft(4, '0')}';
      if (out.startsWith('swi')) {
        return '$out\n';
      } else {
        return out;
      }
    }).join('\n');
    final golden = path.join(
      'test',
      'decoder',
      'thumb',
      'fasmarm_test.golden.asm',
    );
    expect(output, await matchesGoldenText(file: golden));
  });
}
