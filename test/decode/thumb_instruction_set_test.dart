import 'package:armv4t/src/decode/thumb.dart';
import 'package:binary/binary.dart';
import 'package:test/test.dart';

void main() {
  test('should decode 01:MOVE_SHIFTED_REGISTER', () {
    //             000P    POOO   OOSS   SDDD
    final input = ('0001' '0101' '0110' '1010').parseBits();
    final format = ThumbInstructionSet.$01$moveShiftedRegister;
    final coded = Map.fromIterables(format.names, format.capture(input));
    expect(coded, {
      'P': '10'.parseBits(),
      'O': '10101'.parseBits(),
      'S': '101'.parseBits(),
      'D': '010'.parseBits(),
    });
    expect(ThumbInstructionSet.allFormats.match(input), format);
    expect(
      MoveShiftedRegister.decoder.decodeBits(input),
      MoveShiftedRegister(
        opcode: coded['P'],
        offset: coded['O'],
        registerS: coded['S'],
        registerD: coded['D'],
      ),
    );
    expect(
      ThumbInstructionSet.mapDecoders[format],
      MoveShiftedRegister.decoder,
    );
  });

  test('should decode 02:ADD_AND_SUBTRACT', () {
    //              0001   11PN   NNSS   SDDD
    final input = ('0001' '1101' '0110' '1010').parseBits();
    final format = ThumbInstructionSet.$02$addAndSubtract;
    final coded = Map.fromIterables(format.names, format.capture(input));
    expect(coded, {
      'P': '0'.parseBits(),
      'N': '101'.parseBits(),
      'S': '101'.parseBits(),
      'D': '010'.parseBits(),
    });
    expect(ThumbInstructionSet.allFormats.match(input), format);
    expect(
      AddAndSubtract.decoder.decodeBits(input),
      AddAndSubtract(
        opcode: coded['P'],
        registerNOrOffset3: coded['N'],
        registerS: coded['S'],
        registerD: coded['D'],
      ),
    );
    expect(
      ThumbInstructionSet.mapDecoders[format],
      AddAndSubtract.decoder,
    );
  });

  test('should decode 03:MOVE_COMPARE_ADD_AND_SUBTRACT_IMMEDIATE', () {
    //              001P   PDDD   OOOO   OOOO
    final input = ('0011' '1101' '0110' '1010').parseBits();
    final format = ThumbInstructionSet.$03$moveCompareAddAndSubtractImmediate;
    final coded = Map.fromIterables(format.names, format.capture(input));
    expect(coded, {
      'P': '11'.parseBits(),
      'D': '101'.parseBits(),
      'O': '01101010'.parseBits(),
    });
    expect(ThumbInstructionSet.allFormats.match(input), format);
    expect(
      MoveCompareAddAndSubtractImmediate.decoder.decodeBits(input),
      MoveCompareAddAndSubtractImmediate(
        opcode: coded['P'],
        registerD: coded['D'],
        offset: coded['O'],
      ),
    );
    expect(
      ThumbInstructionSet.mapDecoders[format],
      MoveCompareAddAndSubtractImmediate.decoder,
    );
  });

  test('should decode 04:ALU_OPERATION', () {
    //              0100   00PP   PPSS   SDDD
    final input = ('0100' '0001' '0110' '1010').parseBits();
    final format = ThumbInstructionSet.$04$aluOperation;
    final coded = Map.fromIterables(format.names, format.capture(input));
    expect(coded, {
      'P': '0101'.parseBits(),
      'S': '101'.parseBits(),
      'D': '010'.parseBits(),
    });
    expect(ThumbInstructionSet.allFormats.match(input), format);
    expect(
      ALUOperation.decoder.decodeBits(input),
      ALUOperation(
        opcode: coded['P'],
        registerS: coded['S'],
        registerD: coded['D'],
      ),
    );
    expect(
      ThumbInstructionSet.mapDecoders[format],
      ALUOperation.decoder,
    );
  });

  test('should decode 05:HIGH_REGISTER_OPERATIONS_AND_BRANCH_EXCHANGE', () {
    //              0100   01PP   HJSS   SDDD
    final input = ('0100' '0101' '0110' '1010').parseBits();
    final format = ThumbInstructionSet.$05$highRegisterOperationsAndBranch;
    final coded = Map.fromIterables(format.names, format.capture(input));
    expect(coded, {
      'P': '01'.parseBits(),
      'H': 0,
      'J': 1,
      'S': '101'.parseBits(),
      'D': '010'.parseBits(),
    });
    expect(ThumbInstructionSet.allFormats.match(input), format);
    expect(
      HighRegisterOperationsAndBranchExchange.decoder.decodeBits(input),
      HighRegisterOperationsAndBranchExchange(
        opcode: coded['P'],
        h1: coded['H'],
        h2: coded['J'],
        registerSOrHS: coded['S'],
        registerDOrHD: coded['D'],
      ),
    );
    expect(
      ThumbInstructionSet.mapDecoders[format],
      HighRegisterOperationsAndBranchExchange.decoder,
    );
  });

  test('should decode 06:PC_RELATIVE_LOAD', () {
    //              0100   1DDD   WWWW   WWWW
    final input = ('0100' '1101' '0110' '1010').parseBits();
    final format = ThumbInstructionSet.$06$pcRelativeLoad;
    final coded = Map.fromIterables(format.names, format.capture(input));
    expect(coded, {
      'D': '101'.parseBits(),
      'W': '01101010'.parseBits(),
    });
    expect(ThumbInstructionSet.allFormats.match(input), format);
    expect(
      PCRelativeLoad.decoder.decodeBits(input),
      PCRelativeLoad(
        registerD: coded['D'],
        word8: coded['W'],
      ),
    );
    expect(
      ThumbInstructionSet.mapDecoders[format],
      PCRelativeLoad.decoder,
    );
  });

  test('should decode 07:LOAD_AND_STORE_WITH_RELATIVE_OFFSET', () {
    //              0101   LB0O   OONN   NDDD
    final input = ('0101' '1101' '0110' '1010').parseBits();
    final format = ThumbInstructionSet.$07$loadAndStoreWithRelativeOffset;
    final coded = Map.fromIterables(format.names, format.capture(input));
    expect(coded, {
      'L': 1,
      'B': 1,
      'O': '101'.parseBits(),
      'N': '101'.parseBits(),
      'D': '010'.parseBits(),
    });
    expect(ThumbInstructionSet.allFormats.match(input), format);
    expect(
      LoadAndStoreWithRelativeOffset.decoder.decodeBits(input),
      LoadAndStoreWithRelativeOffset(
        l: coded['L'],
        b: coded['B'],
        registerO: coded['O'],
        registerB: coded['N'],
        registerD: coded['D'],
      ),
    );
    expect(
      ThumbInstructionSet.mapDecoders[format],
      LoadAndStoreWithRelativeOffset.decoder,
    );
  });

  test('should decode 08:LOAD_AND_STORE_SIGN_EXTENDED_BYTE_AND_HALFWORD', () {
    //              0101   HS1O   OOBB   BDDD
    final input = ('0101' '1110' '0110' '1010').parseBits();
    final format = ThumbInstructionSet.$08$loadAndStoreSignExtended;
    final coded = Map.fromIterables(format.names, format.capture(input));
    expect(coded, {
      'H': 1,
      'S': 1,
      'O': '001'.parseBits(),
      'B': '101'.parseBits(),
      'D': '010'.parseBits(),
    });
    expect(ThumbInstructionSet.allFormats.match(input), format);
    expect(
      LoadAndStoreSignExtendedByteAndHalfWord.decoder.decodeBits(input),
      LoadAndStoreSignExtendedByteAndHalfWord(
        h: coded['H'],
        s: coded['S'],
        registerO: coded['O'],
        registerB: coded['B'],
        registerD: coded['D'],
      ),
    );
    expect(
      ThumbInstructionSet.mapDecoders[format],
      LoadAndStoreSignExtendedByteAndHalfWord.decoder,
    );
  });

  test('should decode 09:LOAD_AND_STORE_WITH_IMMEDIATE_OFFSET', () {
    //              011B   LOOO   OONN   NDDD
    final input = ('0110' '1101' '0110' '1010').parseBits();
    final format = ThumbInstructionSet.$09$loadAndStoreWithImmediateOffset;
    final coded = Map.fromIterables(format.names, format.capture(input));
    expect(coded, {
      'B': 0,
      'L': 1,
      'O': '10101'.parseBits(),
      'N': '101'.parseBits(),
      'D': '010'.parseBits(),
    });
    expect(ThumbInstructionSet.allFormats.match(input), format);
    expect(
      LoadAndStoreWithImmediateOffset.decoder.decodeBits(input),
      LoadAndStoreWithImmediateOffset(
        b: coded['B'],
        l: coded['L'],
        offset5: coded['O'],
        registerB: coded['N'],
        registerD: coded['D'],
      ),
    );
    expect(
      ThumbInstructionSet.mapDecoders[format],
      LoadAndStoreWithImmediateOffset.decoder,
    );
  });

  test('should decode 10:LOAD_AND_STORE_HALFWORD', () {
    //              1000   LOOO   OOBB   BDDD
    final input = ('1000' '1101' '0110' '1010').parseBits();
    final format = ThumbInstructionSet.$10$loadAndStoreHalfword;
    final coded = Map.fromIterables(format.names, format.capture(input));
    expect(coded, {
      'L': 1,
      'O': '10101'.parseBits(),
      'B': '101'.parseBits(),
      'D': '010'.parseBits(),
    });
    expect(ThumbInstructionSet.allFormats.match(input), format);
    expect(
      LoadAndStoreHalfWord.decoder.decodeBits(input),
      LoadAndStoreHalfWord(
        l: coded['L'],
        offset5: coded['O'],
        registerB: coded['B'],
        registerD: coded['D'],
      ),
    );
    expect(
      ThumbInstructionSet.mapDecoders[format],
      LoadAndStoreHalfWord.decoder,
    );
  });

  test('should decode 11:SP_RELATIVE_LOAD_AND_STORE', () {
    //              1001   LDDD   WWWW   WWWW
    final input = ('1001' '1101' '0110' '1010').parseBits();
    final format = ThumbInstructionSet.$11$spRelativeLoadAndStore;
    final coded = Map.fromIterables(format.names, format.capture(input));
    expect(coded, {
      'L': 1,
      'D': '101'.parseBits(),
      'W': '01101010'.parseBits(),
    });
    expect(ThumbInstructionSet.allFormats.match(input), format);
    expect(
      SPRelativeLoadAndStore.decoder.decodeBits(input),
      SPRelativeLoadAndStore(
        l: coded['L'],
        registerD: coded['D'],
        word8: coded['W'],
      ),
    );
    expect(
      ThumbInstructionSet.mapDecoders[format],
      SPRelativeLoadAndStore.decoder,
    );
  });

  test('should decode 12:LOAD_ADDRESS', () {
    //              1010   SDDD   WWWW   WWWW
    final input = ('1010' '1101' '0110' '1010').parseBits();
    final format = ThumbInstructionSet.$12$loadAddress;
    final coded = Map.fromIterables(format.names, format.capture(input));
    expect(coded, {
      'S': 1,
      'D': '101'.parseBits(),
      'W': '01101010'.parseBits(),
    });
    expect(ThumbInstructionSet.allFormats.match(input), format);
    expect(
      LoadAddress.decoder.decodeBits(input),
      LoadAddress(
        sp: coded['S'],
        registerD: coded['D'],
        word8: coded['W'],
      ),
    );
    expect(
      ThumbInstructionSet.mapDecoders[format],
      LoadAddress.decoder,
    );
  });

  test('should decode 13:ADD_OFFSET_TO_STACK_POINTER', () {
    //              1011   0000   SWWW   WWWW
    final input = ('1011' '0000' '0110' '1010').parseBits();
    final format = ThumbInstructionSet.$13$addOffsetToStackPointer;
    final coded = Map.fromIterables(format.names, format.capture(input));
    expect(coded, {
      'S': 0,
      'W': '1101010'.parseBits(),
    });
    expect(ThumbInstructionSet.allFormats.match(input), format);
    expect(
      AddOffsetToStackPointer.decoder.decodeBits(input),
      AddOffsetToStackPointer(
        s: coded['S'],
        sWord7: coded['W'],
      ),
    );
    expect(
      ThumbInstructionSet.mapDecoders[format],
      AddOffsetToStackPointer.decoder,
    );
  });

  test('should decode 14:PUSH_AND_POP_REGISTERS', () {
    //              1011   L10R   TTTT   TTTT
    final input = ('1011' '1101' '0110' '1010').parseBits();
    final format = ThumbInstructionSet.$14$pushAndPopRegisters;
    final coded = Map.fromIterables(format.names, format.capture(input));
    expect(coded, {
      'L': 1,
      'R': 1,
      'T': '01101010'.parseBits(),
    });
    expect(ThumbInstructionSet.allFormats.match(input), format);
    expect(
      PushAndPopRegisters.decoder.decodeBits(input),
      PushAndPopRegisters(
        l: coded['L'],
        r: coded['R'],
        registerList: coded['T'],
      ),
    );
    expect(
      ThumbInstructionSet.mapDecoders[format],
      PushAndPopRegisters.decoder,
    );
  });

  test('should decode 15:MULTIPLE_LOAD_AND_STORE', () {
    //              1100   LBBB   TTTT   TTTT
    final input = ('1100' '1101' '0110' '1010').parseBits();
    final format = ThumbInstructionSet.$15$multipleLoadAndStore;
    final coded = Map.fromIterables(format.names, format.capture(input));
    expect(coded, {
      'L': 1,
      'B': '101'.parseBits(),
      'T': '01101010'.parseBits(),
    });
    expect(ThumbInstructionSet.allFormats.match(input), format);
    expect(
      MultipleLoadAndStore.decoder.decodeBits(input),
      MultipleLoadAndStore(
        l: coded['L'],
        registerB: coded['B'],
        registerList: coded['T'],
      ),
    );
    expect(
      ThumbInstructionSet.mapDecoders[format],
      MultipleLoadAndStore.decoder,
    );
  });

  test('should decode 16:CONDITIONAL_BRANCH', () {
    //              1101   CCCC   SSSS   SSSS
    final input = ('1101' '1101' '0110' '1010').parseBits();
    final format = ThumbInstructionSet.$16$conditionalBranch;
    final coded = Map.fromIterables(format.names, format.capture(input));
    expect(coded, {
      'C': '1101'.parseBits(),
      'S': '01101010'.parseBits(),
    });
    expect(ThumbInstructionSet.allFormats.match(input), format);
    expect(
      ConditionalBranch.decoder.decodeBits(input),
      ConditionalBranch(
        condition: coded['C'],
        softSet8: coded['S'],
      ),
    );
    expect(
      ThumbInstructionSet.mapDecoders[format],
      ConditionalBranch.decoder,
    );
  });

  test('should decode 17:SOFTWARE_INTERRUPT', () {
    //              1101   1111   VVVV   VVVV
    final input = ('1101' '1111' '0110' '1010').parseBits();
    final format = ThumbInstructionSet.$17$softwareInterrupt;
    final coded = Map.fromIterables(format.names, format.capture(input));
    expect(coded, {
      'V': '01101010'.parseBits(),
    });
    expect(ThumbInstructionSet.allFormats.match(input), format);
    expect(
      SoftwareInterrupt.decoder.decodeBits(input),
      SoftwareInterrupt(
        value8: coded['V'],
      ),
    );
    expect(
      ThumbInstructionSet.mapDecoders[format],
      SoftwareInterrupt.decoder,
    );
  });

  test('should decode 18:UNCONDITIONAL_BRANCH', () {
    //              1110   0OOO   OOOO   OOOO
    final input = ('1110' '0101' '0110' '1010').parseBits();
    final format = ThumbInstructionSet.$18$unconditionalBranch;
    final coded = Map.fromIterables(format.names, format.capture(input));
    expect(coded, {
      'O': '10101101010'.parseBits(),
    });
    expect(ThumbInstructionSet.allFormats.match(input), format);
    expect(
      UnconditionalBranch.decoder.decodeBits(input),
      UnconditionalBranch(
        offset11: coded['O'],
      ),
    );
    expect(
      ThumbInstructionSet.mapDecoders[format],
      UnconditionalBranch.decoder,
    );
  });

  test('should decode 19:LONG_BRANCH_WITH_LINK', () {
    //              1111   HOOO   OOOO   OOOO
    final input = ('1111' '1101' '0110' '1010').parseBits();
    final format = ThumbInstructionSet.$19$longBranchWithLink;
    final coded = Map.fromIterables(format.names, format.capture(input));
    expect(coded, {
      'H': 1,
      'O': '10101101010'.parseBits(),
    });
    expect(ThumbInstructionSet.allFormats.match(input), format);
    expect(
      LongBranchWithLink.decoder.decodeBits(input),
      LongBranchWithLink(
        h: coded['H'],
        offset: coded['O'],
      ),
    );
    expect(
      ThumbInstructionSet.mapDecoders[format],
      LongBranchWithLink.decoder,
    );
  });
}
