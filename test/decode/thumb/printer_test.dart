import 'package:armv4t/src/decode/thumb/printer.dart';
import 'package:binary/binary.dart';
import 'package:test/test.dart';

/// Additional tests not otherwise covered in `instruction_test.dart`.
void main() {
  group('describeRegisterList', () {
    test('<None>>', () {
      expect(
        ThumbInstructionPrinter.describeRegisterList(
          ('0000' '0000').parseBits(),
        ),
        isEmpty,
      );
    });

    test('R0', () {
      expect(
        ThumbInstructionPrinter.describeRegisterList(
          ('0000' '0001').parseBits(),
        ),
        'R0',
      );
    });

    test('R4', () {
      expect(
        ThumbInstructionPrinter.describeRegisterList(
          ('0001' '0000').parseBits(),
        ),
        'R4',
      );
    });

    test('R7', () {
      expect(
        ThumbInstructionPrinter.describeRegisterList(
          ('1000' '0000').parseBits(),
        ),
        'R7',
      );
    });

    test('R0->R1', () {
      expect(
        ThumbInstructionPrinter.describeRegisterList(
          ('0000' '0011').parseBits(),
        ),
        'R0-R1',
      );
    });

    test('R6->R7', () {
      expect(
        ThumbInstructionPrinter.describeRegisterList(
          ('1100' '0000').parseBits(),
        ),
        'R6-R7',
      );
    });

    test('R0->R7', () {
      expect(
        ThumbInstructionPrinter.describeRegisterList(
          ('1111' '1111').parseBits(),
        ),
        'R0-R7',
      );
    });

    test('R0->R1, R6->R7', () {
      expect(
        ThumbInstructionPrinter.describeRegisterList(
          ('1100' '0011').parseBits(),
        ),
        'R0-R1,R6-R7',
      );
    });
  });
}
