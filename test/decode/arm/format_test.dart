import 'package:armv4t/src/decode/arm/format.dart';
import 'package:binary/binary.dart';
import 'package:test/test.dart';

void main() {
  test('should decode 01:DATA_PROCESSING_OR_PSR_TRANSFER', () {
    //               CCCC   00IP   PPPS   NNNN   DDDD   OOOO   OOOO   OOOO
    final string = ('0000' '0010' '1010' '1010' '1010' '1010' '1010' '1010');
    final input = string.parseBits();
    final format = ArmInstructionSet.$01$dataProcessingOrPsrTransfer;
    final coded = Map.fromIterables(format.names, format.capture(input));
    expect(coded, {
      'C': '0000'.parseBits(),
      'I': '1'.parseBits(),
      'P': '0101'.parseBits(),
      'S': '0'.parseBits(),
      'N': '1010'.parseBits(),
      'D': '1010'.parseBits(),
      'O': '1010' '1010' '1010'.parseBits(),
    });
    expect(ArmInstructionSet.allFormats.match(input), format);
    expect(
      DataProcessingOrPSRTransfer.decoder.decodeBits(input),
      DataProcessingOrPSRTransfer(
        condition: coded['C'],
        i: coded['I'],
        opcode: coded['P'],
        s: coded['S'],
        registerN: coded['N'],
        registerD: coded['D'],
        operand2: coded['O'],
      ),
    );
    expect(
      ArmInstructionSet.mapDecoders[format],
      DataProcessingOrPSRTransfer.decoder,
    );
  });
}
