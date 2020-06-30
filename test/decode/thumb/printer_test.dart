import 'package:armv4t/src/decode/common.dart';
import 'package:binary/binary.dart';
import 'package:test/test.dart';

class _TestPrinter with InstructionPrintHelper {}

/// Additional tests not otherwise covered in `instruction_test.dart`.
void main() {
  final testPrinter = _TestPrinter();

  group('describeRegisterList', () {
    test('<None>>', () {
      expect(
        testPrinter.describeRegisterList(
          ('0000' '0000').parseBits(),
          length: 8,
        ),
        isEmpty,
      );
    });

    test('R0', () {
      expect(
        testPrinter.describeRegisterList(
          ('0000' '0001').parseBits(),
          length: 8,
        ),
        'R0',
      );
    });

    test('R4', () {
      expect(
        testPrinter.describeRegisterList(
          ('0001' '0000').parseBits(),
          length: 8,
        ),
        'R4',
      );
    });

    test('R7', () {
      expect(
        testPrinter.describeRegisterList(
          ('1000' '0000').parseBits(),
          length: 8,
        ),
        'R7',
      );
    });

    test('R0->R1', () {
      expect(
        testPrinter.describeRegisterList(
          ('0000' '0011').parseBits(),
          length: 8,
        ),
        'R0-R1',
      );
    });

    test('R6->R7', () {
      expect(
        testPrinter.describeRegisterList(
          ('1100' '0000').parseBits(),
          length: 8,
        ),
        'R6-R7',
      );
    });

    test('R0->R7', () {
      expect(
        testPrinter.describeRegisterList(
          ('1111' '1111').parseBits(),
          length: 8,
        ),
        'R0-R7',
      );
    });

    test('R0->R1, R6->R7', () {
      expect(
        testPrinter.describeRegisterList(
          ('1100' '0011').parseBits(),
          length: 8,
        ),
        'R0-R1,R6-R7',
      );
    });
  });
}
