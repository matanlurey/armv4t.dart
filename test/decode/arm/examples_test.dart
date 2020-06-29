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
            p.toRadixString(16).toUpperCase() +
            ': ' +
            decode(p).accept(ArmInstructionPrinter()))
        .toList();
  }

  // https://onlinedisassembler.com/odaweb/strcpy_arm
  test('strcpy_arm', () {
    final program = [
      0xE2402001,
      0xE0612002,
    ];

    expect(decodeAll(program), [
      '0xE2402001: SUB R2, R0, #1',
      '0xE0612002: RSB R2, R1, R2',
    ]);
  });
}
