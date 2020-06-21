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
  });

  test(
    'should decode 08:LOAD_AND_STORE_SIGN_EXTENDED_BYTE_AND_HALFWORD',
    () {
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
    },
  );

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
  });

  test('should decode 13:ADD_OFFSET_TO_STACK_POINTER', () {
    //              1010   SDDD   WWWW   WWWW
    final input = ('1010' '1101' '0110' '1010').parseBits();
    final format = ThumbInstructionSet.$13$addOffsetToStackPointer;
    final coded = Map.fromIterables(format.names, format.capture(input));
    expect(coded, {
      'S': 1,
      'D': '101'.parseBits(),
      'W': '01101010'.parseBits(),
    });
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
  });

  test('should decode 17:SOFTWARE_INTERRUPT', () {
    //              1101   1111   VVVV   VVVV
    final input = ('1101' '1111' '0110' '1010').parseBits();
    final format = ThumbInstructionSet.$17$softwareInterrupt;
    final coded = Map.fromIterables(format.names, format.capture(input));
    expect(coded, {
      'V': '01101010'.parseBits(),
    });
  });

  test('should decode 18:UNCONDITIONAL_BRANCH', () {
    //              1110   0OOO   OOOO   OOOO
    final input = ('1110' '0101' '0110' '1010').parseBits();
    final format = ThumbInstructionSet.$18$unconditionalBranch;
    final coded = Map.fromIterables(format.names, format.capture(input));
    expect(coded, {
      'O': '10101101010'.parseBits(),
    });
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
  });
}
