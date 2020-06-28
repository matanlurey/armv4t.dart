import 'package:armv4t/src/decode/arm/format.dart';
import 'package:binary/binary.dart';
import 'package:test/test.dart';

void main() {
  test('should decode 01:DATA_PROCESSING_OR_PSR_TRANSFER', () {
    //               CCCC   00IP   PPPS   NNNN   DDDD   OOOO   OOOO   OOOO
    final string = ('1101' '0010' '1010' '1010' '1010' '1010' '1010' '1010');
    final input = string.parseBits();
    final format = ArmInstructionSet.$01$dataProcessingOrPsrTransfer;
    final coded = Map.fromIterables(format.names, format.capture(input));
    expect(coded, {
      'C': '1101'.parseBits(),
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

  test('should decode 02:MULTIPLY', () {
    //               CCCC   0000   00AS   DDDD   NNNN   FFFF   1001   MMMM
    final string = ('0000' '0000' '0010' '1010' '1010' '1010' '1001' '1010');
    final input = string.parseBits();
    final format = ArmInstructionSet.$02$multiply;
    final coded = Map.fromIterables(format.names, format.capture(input));
    expect(coded, {
      'C': '0000'.parseBits(),
      'A': '1'.parseBits(),
      'S': '0'.parseBits(),
      'D': '1010'.parseBits(),
      'N': '1010'.parseBits(),
      'F': '1010'.parseBits(),
      'M': '1010'.parseBits(),
    });
    expect(ArmInstructionSet.allFormats.match(input), format);
    expect(
      MultiplyAndMutiplyAccumulate.decoder.decodeBits(input),
      MultiplyAndMutiplyAccumulate(
        condition: coded['C'],
        a: coded['A'],
        s: coded['S'],
        registerD: coded['D'],
        registerN: coded['N'],
        registerS: coded['F'],
        registerM: coded['M'],
      ),
    );
    expect(
      ArmInstructionSet.mapDecoders[format],
      MultiplyAndMutiplyAccumulate.decoder,
    );
  });

  test('should decode 03:MULTIPLY_LONG', () {
    //               CCCC   0000   1UAS   DDDD   FFFF   NNNN   1001   MMMM
    final string = ('0000' '0000' '1010' '1010' '1010' '1010' '1001' '1010');
    final input = string.parseBits();
    final format = ArmInstructionSet.$03$multiplyLong;
    final coded = Map.fromIterables(format.names, format.capture(input));
    expect(coded, {
      'C': '0000'.parseBits(),
      'U': '0'.parseBits(),
      'A': '1'.parseBits(),
      'S': '0'.parseBits(),
      'D': '1010'.parseBits(),
      'F': '1010'.parseBits(),
      'N': '1010'.parseBits(),
      'M': '1010'.parseBits(),
    });
    expect(ArmInstructionSet.allFormats.match(input), format);
    expect(
      MultiplyLongAndMutiplyAccumulateLong.decoder.decodeBits(input),
      MultiplyLongAndMutiplyAccumulateLong(
        condition: coded['C'],
        u: coded['U'],
        a: coded['A'],
        s: coded['S'],
        registerD: coded['D'],
        registerN: coded['N'],
        registerS: coded['F'],
        registerM: coded['M'],
      ),
    );
    expect(
      ArmInstructionSet.mapDecoders[format],
      MultiplyLongAndMutiplyAccumulateLong.decoder,
    );
  });

  test('should decode 05:BRANCH_AND_EXCHANGE', () {
    //               CCCC   0001   0010   1111   1111   1111   0001   NNNN
    final string = ('0000' '0001' '0010' '1111' '1111' '1111' '0001' '1010');
    final input = string.parseBits();
    final format = ArmInstructionSet.$05$branchAndExchange;
    final coded = Map.fromIterables(format.names, format.capture(input));
    expect(coded, {
      'C': '0000'.parseBits(),
      'N': '1010'.parseBits(),
    });
    expect(ArmInstructionSet.allFormats.match(input), format);
    expect(
      BranchAndExchange.decoder.decodeBits(input),
      BranchAndExchange(
        condition: coded['C'],
        registerN: coded['N'],
      ),
    );
    expect(
      ArmInstructionSet.mapDecoders[format],
      BranchAndExchange.decoder,
    );
  });

  test('should decode 06:HALF_WORD_DATA_TRANSFER_REGISTER_OFFSET', () {
    //               CCCC   000P   U0WL   NNNN   DDDD   0000   1SH1   MMMM
    final string = ('0000' '0001' '0010' '1111' '1111' '0000' '1001' '1010');
    final input = string.parseBits();
    final format = ArmInstructionSet.$06$halfWordDataTransferRegister;
    final coded = Map.fromIterables(format.names, format.capture(input));
    expect(coded, {
      'C': '0000'.parseBits(),
      'P': '1'.parseBits(),
      'U': '0'.parseBits(),
      'W': '1'.parseBits(),
      'L': '0'.parseBits(),
      'N': '1111'.parseBits(),
      'D': '1111'.parseBits(),
      'S': '0'.parseBits(),
      'H': '0'.parseBits(),
      'M': '1010'.parseBits(),
    });
    expect(ArmInstructionSet.allFormats.match(input), format);
    expect(
      HalfWordAndSignedDataTransferRegisterOffset.decoder.decodeBits(input),
      HalfWordAndSignedDataTransferRegisterOffset(
        condition: coded['C'],
        p: coded['P'],
        u: coded['U'],
        w: coded['W'],
        l: coded['L'],
        registerN: coded['N'],
        registerD: coded['D'],
        s: coded['S'],
        h: coded['H'],
        registerM: coded['M'],
      ),
    );
    expect(
      ArmInstructionSet.mapDecoders[format],
      HalfWordAndSignedDataTransferRegisterOffset.decoder,
    );
  });

  test('should decode 07:HALF_WORD_DATA_TRANSFER_IMMEDIATE_OFFSET', () {
    //               CCCC   000P   U1WL   NNNN   DDDD   OOOO   1SH1   KKKK
    final string = ('0000' '0001' '0110' '1111' '1111' '0000' '1001' '1010');
    final input = string.parseBits();
    final format = ArmInstructionSet.$07$halfWordDataTranseferImmediate;
    final coded = Map.fromIterables(format.names, format.capture(input));
    expect(coded, {
      'C': '0000'.parseBits(),
      'P': '1'.parseBits(),
      'U': '0'.parseBits(),
      'W': '1'.parseBits(),
      'L': '0'.parseBits(),
      'N': '1111'.parseBits(),
      'D': '1111'.parseBits(),
      'O': '0000'.parseBits(),
      'S': '0'.parseBits(),
      'H': '0'.parseBits(),
      'K': '1010'.parseBits(),
    });
    expect(ArmInstructionSet.allFormats.match(input), format);
    expect(
      HalfWordAndSignedDataTransferImmediateOffset.decoder.decodeBits(input),
      HalfWordAndSignedDataTransferImmediateOffset(
        condition: coded['C'],
        p: coded['P'],
        u: coded['U'],
        w: coded['W'],
        l: coded['L'],
        registerN: coded['N'],
        registerD: coded['D'],
        offsetHighNibble: coded['O'],
        s: coded['S'],
        h: coded['H'],
        offsetLowNibble: coded['K'],
      ),
    );
    expect(
      ArmInstructionSet.mapDecoders[format],
      HalfWordAndSignedDataTransferImmediateOffset.decoder,
    );
  });

  test('should decode 08:SINGLE_DATA_TRANSFER', () {
    //               CCCC   01IP   UBWL   NNNN   DDDD   OOOO   OOOO   OOOO
    final string = ('0000' '0101' '0110' '1111' '1111' '0000' '1001' '1010');
    final input = string.parseBits();
    final format = ArmInstructionSet.$08$singleDataTransfer;
    final coded = Map.fromIterables(format.names, format.capture(input));
    expect(coded, {
      'C': '0000'.parseBits(),
      'I': '0'.parseBits(),
      'P': '1'.parseBits(),
      'U': '0'.parseBits(),
      'B': '1'.parseBits(),
      'W': '1'.parseBits(),
      'L': '0'.parseBits(),
      'N': '1111'.parseBits(),
      'D': '1111'.parseBits(),
      'O': '0000' '1001' '1010'.parseBits(),
    });
    expect(ArmInstructionSet.allFormats.match(input), format);
    expect(
      SingleDataTransfer.decoder.decodeBits(input),
      SingleDataTransfer(
        condition: coded['C'],
        i: coded['I'],
        p: coded['P'],
        u: coded['U'],
        b: coded['B'],
        w: coded['W'],
        l: coded['L'],
        registerN: coded['N'],
        registerD: coded['D'],
        offset: coded['O'],
      ),
    );
    expect(
      ArmInstructionSet.mapDecoders[format],
      SingleDataTransfer.decoder,
    );
  });

  test('should decode 09:UNDEFINED', () {
    //               CCCC   011X   XXXX   XXXX   XXXX   XXXX   XXX1   ZZZZ
    final string = ('0000' '0111' '0110' '1111' '1111' '0000' '1001' '1010');
    final input = string.parseBits();
    final format = ArmInstructionSet.$09$undefined;
    final coded = Map.fromIterables(format.names, format.capture(input));
    expect(coded, containsPair('C', '0000'.parseBits()));
    expect(ArmInstructionSet.allFormats.match(input), format);
    expect(
      Undefined.decoder.decodeBits(input),
      Undefined(condition: coded['C']),
    );
    expect(
      ArmInstructionSet.mapDecoders[format],
      Undefined.decoder,
    );
  });

  test('should decode 10:BLOCK_DATA_TRANSFER', () {
    //               CCCC   100P   USWL   NNNN   RRRR   RRRR   RRRR   RRRR
    final string = ('0000' '1001' '0110' '1111' '1111' '0000' '1001' '1010');
    final input = string.parseBits();
    final format = ArmInstructionSet.$10$blockDataTransfer;
    final coded = Map.fromIterables(format.names, format.capture(input));
    expect(coded, {
      'C': '0000'.parseBits(),
      'P': '1'.parseBits(),
      'U': '0'.parseBits(),
      'S': '1'.parseBits(),
      'W': '1'.parseBits(),
      'L': '0'.parseBits(),
      'N': '1111'.parseBits(),
      'R': '1111' '0000' '1001' '1010'.parseBits(),
    });
    expect(ArmInstructionSet.allFormats.match(input), format);
    expect(
      BlockDataTransfer.decoder.decodeBits(input),
      BlockDataTransfer(
        condition: coded['C'],
        p: coded['P'],
        u: coded['U'],
        s: coded['S'],
        w: coded['W'],
        l: coded['L'],
        registerN: coded['N'],
        regsiterList: coded['R'],
      ),
    );
    expect(
      ArmInstructionSet.mapDecoders[format],
      BlockDataTransfer.decoder,
    );
  });

  test('should decode 11:BRANCH', () {
    //               CCCC   101L   OOOO   OOOO   OOOO   OOOO   OOOO   OOOO
    final string = ('0000' '1011' '0110' '1111' '1111' '0000' '1001' '1010');
    final input = string.parseBits();
    final format = ArmInstructionSet.$11$branch;
    final coded = Map.fromIterables(format.names, format.capture(input));
    expect(coded, {
      'C': '0000'.parseBits(),
      'L': '1'.parseBits(),
      'O': '0110' '1111' '1111' '0000' '1001' '1010'.parseBits(),
    });
    expect(ArmInstructionSet.allFormats.match(input), format);
    expect(
      Branch.decoder.decodeBits(input),
      Branch(
        condition: coded['C'],
        l: coded['L'],
        offset: coded['O'],
      ),
    );
    expect(
      ArmInstructionSet.mapDecoders[format],
      Branch.decoder,
    );
  });

  test('should decode 12:COPROCESSOR_DATA_TRANSFER', () {
    //               CCCC   110P   UNWL   MMMM   DDDD   KKKK   OOOO   OOOO
    final string = ('0000' '1101' '0110' '1111' '1111' '0000' '1001' '1010');
    final input = string.parseBits();
    final format = ArmInstructionSet.$12$coprocessorDataTransfer;
    final coded = Map.fromIterables(format.names, format.capture(input));
    expect(coded, {
      'C': '0000'.parseBits(),
      'P': '1'.parseBits(),
      'U': '0'.parseBits(),
      'N': '1'.parseBits(),
      'W': '1'.parseBits(),
      'L': '0'.parseBits(),
      'M': '1111'.parseBits(),
      'D': '1111'.parseBits(),
      'K': '0000'.parseBits(),
      'O': '1001' '1010'.parseBits(),
    });
    expect(ArmInstructionSet.allFormats.match(input), format);
    expect(
      CoprocessorDataTransfer.decoder.decodeBits(input),
      CoprocessorDataTransfer(
        condition: coded['C'],
        p: coded['P'],
        u: coded['U'],
        n: coded['N'],
        w: coded['W'],
        l: coded['L'],
        registerN: coded['M'],
        cpRegisterD: coded['D'],
        cpNumber: coded['K'],
        offset: coded['O'],
      ),
    );
    expect(
      ArmInstructionSet.mapDecoders[format],
      CoprocessorDataTransfer.decoder,
    );
  });

  test('should decode 13:COPROCESSOR_DATA_OPERATION', () {
    //               CCCC   1110   OOOO   NNNN   DDDD   PPPP   VVV0   MMMM
    final string = ('0000' '1110' '0110' '1111' '1111' '0000' '1000' '1010');
    final input = string.parseBits();
    final format = ArmInstructionSet.$13$coprocessorDataOperation;
    final coded = Map.fromIterables(format.names, format.capture(input));
    expect(coded, {
      'C': '0000'.parseBits(),
      'O': '0110'.parseBits(),
      'N': '1111'.parseBits(),
      'D': '1111'.parseBits(),
      'P': '0000'.parseBits(),
      'V': '100'.parseBits(),
      'M': '1010'.parseBits(),
    });
    expect(ArmInstructionSet.allFormats.match(input), format);
    expect(
      CoprocessorDataOperation.decoder.decodeBits(input),
      CoprocessorDataOperation(
        condition: coded['C'],
        cpOpCode: coded['O'],
        cpOperandRegister1: coded['N'],
        cpDestinationRegister: coded['D'],
        cpNumber: coded['P'],
        cpInformation: coded['V'],
        cpOperandRegister2: coded['M'],
      ),
    );
    expect(
      ArmInstructionSet.mapDecoders[format],
      CoprocessorDataOperation.decoder,
    );
  });

  test('should decode 14:COPROCESSOR_REGISTER_TRANSFER', () {
    //               CCCC   1110   OOOL   NNNN   DDDD   PPPP   VVV1   MMMM
    final string = ('0000' '1110' '0110' '1111' '1111' '0000' '1001' '1010');
    final input = string.parseBits();
    final format = ArmInstructionSet.$14$coprocessorRegisterTransfer;
    final coded = Map.fromIterables(format.names, format.capture(input));
    expect(coded, {
      'C': '0000'.parseBits(),
      'O': '011'.parseBits(),
      'L': '0'.parseBits(),
      'N': '1111'.parseBits(),
      'D': '1111'.parseBits(),
      'P': '0000'.parseBits(),
      'V': '100'.parseBits(),
      'M': '1010'.parseBits(),
    });
    expect(ArmInstructionSet.allFormats.match(input), format);
    expect(
      CoprocessorRegisterTransfer.decoder.decodeBits(input),
      CoprocessorRegisterTransfer(
        condition: coded['C'],
        cpOpCode: coded['O'],
        l: coded['L'],
        cpRegisterN: coded['N'],
        registerD: coded['D'],
        cpNumber: coded['P'],
        cpInformation: coded['V'],
        cpRegisterM: coded['M'],
      ),
    );
    expect(
      ArmInstructionSet.mapDecoders[format],
      CoprocessorRegisterTransfer.decoder,
    );
  });

  test('should decode 15:SOFTWARE_INTERRUPT', () {
    //               CCCC   1111   XXXX   XXXX   XXXX   XXXX   XXXX   XXXX
    final string = ('0000' '1111' '0110' '1111' '1111' '0000' '1001' '1010');
    final input = string.parseBits();
    final format = ArmInstructionSet.$15$softwareInterrupt;
    final coded = Map.fromIterables(format.names, format.capture(input));
    expect(coded, {
      'C': '0000'.parseBits(),
      'X': '0110' '1111' '1111' '0000' '1001' '1010'.parseBits(),
    });
    expect(ArmInstructionSet.allFormats.match(input), format);
    expect(
      SoftwareInterrupt.decoder.decodeBits(input),
      SoftwareInterrupt(
        condition: coded['C'],
        comment: coded['X'],
      ),
    );
    expect(
      ArmInstructionSet.mapDecoders[format],
      SoftwareInterrupt.decoder,
    );
  });
}
