import 'package:armv4t/src/decode/arm/format.dart';
import 'package:armv4t/src/decode/arm/instruction.dart';
import 'package:armv4t/src/decode/arm/printer.dart';
import 'package:test/test.dart';

// Example programs from https://onlinedisassembler.com/odaweb.
void main() {
  /// Decodes an `ARM`-encoded 32-bit instruction.
  ArmInstruction decode(int bits) {
    final pattern = ArmInstructionSet.allFormats.match(bits);
    final format = ArmInstructionSet.mapDecoders[pattern];
    return format.decodeBits(bits).accept(const ArmDecoder());
  }

  List<String> decodeAll(List<int> program) {
    return program
        .map((p) =>
            '0x' +
            p.toRadixString(16).toLowerCase().padLeft(8, '0') +
            ': ' +
            decode(p).accept(ArmInstructionPrinter()))
        .toList();
  }

  // https://onlinedisassembler.com/odaweb/strcpy_arm
  test('strcpy_arm', () {
    final program = [
      0xE2402001,
      0xE0612002,
      0xE4D13001,
      0xE3530000,
      0xE7C13002,
      0x1AFFFFFB,
      0xE12FFF1E,
    ];

    expect(decodeAll(program), [
      '0xe2402001: sub r2, r0, 1',
      '0xe0612002: rsb r2, r1, r2',
      '0xe4d13001: ldrb r3, [r1], +1',
      '0xe3530000: cmp r3, 0',
      '0xe7c13002: strb r3, [r1, +r2]',
      '0x1afffffb: bne 16777211',
      '0xe12fff1e: bx lr',
    ]);
  });
}
