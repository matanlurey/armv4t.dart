@TestOn('vm')
library armv4t.test.decoder.thumb.fasmarm_test;

import 'dart:io';
import 'dart:typed_data';

import 'package:armv4t/src/decoder/arm/format.dart';
import 'package:armv4t/src/decoder/arm/instruction.dart';
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
    final output = input
        .map((b) => Uint16(b))
        .map((i) => ''
            '${disassemble(i).padRight(32, ' ')} '
            ';${i.value.toRadixString(16)}')
        .join('\n');
    final golden = path.join(
      'test',
      'decoder',
      'arm',
      'thumb',
      'fasmarm_test.golden.asm',
    );
    expect(output, await matchesGoldenText(file: golden));
  });
}
