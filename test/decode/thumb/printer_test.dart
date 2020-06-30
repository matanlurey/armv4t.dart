import 'package:armv4t/src/decode/common.dart';
import 'package:binary/binary.dart';
import 'package:test/test.dart';

class _TestPrinter with InstructionPrintHelper {}

/// Additional tests not otherwise covered in `instruction_test.dart`.
void main() {
  final testPrinter = _TestPrinter();

  group('describeRegisterList', () {
    test('<None>', () {
      expect(
        testPrinter.describeRegisterList(
          ('0000' '0000').parseBits(),
          length: 8,
        ),
        isEmpty,
      );
    });

    test('r0', () {
      expect(
        testPrinter.describeRegisterList(
          ('0000' '0001').parseBits(),
          length: 8,
        ),
        'r0',
      );
    });

    test('r4', () {
      expect(
        testPrinter.describeRegisterList(
          ('0001' '0000').parseBits(),
          length: 8,
        ),
        'r4',
      );
    });

    test('r7', () {
      expect(
        testPrinter.describeRegisterList(
          ('1000' '0000').parseBits(),
          length: 8,
        ),
        'r7',
      );
    });

    test('r0->R1', () {
      expect(
        testPrinter.describeRegisterList(
          ('0000' '0011').parseBits(),
          length: 8,
        ),
        'r0-r1',
      );
    });

    test('r6->R7', () {
      expect(
        testPrinter.describeRegisterList(
          ('1100' '0000').parseBits(),
          length: 8,
        ),
        'r6-r7',
      );
    });

    test('r0->R7', () {
      expect(
        testPrinter.describeRegisterList(
          ('1111' '1111').parseBits(),
          length: 8,
        ),
        'r0-r7',
      );
    });

    test('r0->R1, R6->R7', () {
      expect(
        testPrinter.describeRegisterList(
          ('1100' '0011').parseBits(),
          length: 8,
        ),
        'r0-r1,r6-r7',
      );
    });
  });
}
