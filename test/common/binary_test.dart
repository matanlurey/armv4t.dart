import 'dart:math' as math;
import 'package:armv4t/src/common/assert.dart';
import 'package:armv4t/src/common/binary.dart';
import 'package:test/test.dart';

void main() {
  group('Uint2', () {
    test('should have a name', () {
      if (assertionsEnabled) {
        expect(Uint2.zero.toString(), contains('Uint2 {0}'));
      } else {
        expect(Uint2.zero.toString(), isNot(contains('Uint2 {0}')));
      }
    });

    test('should check ranges', () {
      final outOfRange = math.pow(2, 2) as int;
      expect(() => Uint2.checkRange(outOfRange), throwsRangeError);
      if (assertionsEnabled) {
        expect(() => Uint2.assertRange(outOfRange), throwsRangeError);
      }
    });

    test('should wrap values', () {
      expect(Uint2(1) & Uint2(2), Uint2(1 & 2));
    });
  });

  group('Uint12', () {
    test('should have a name', () {
      if (assertionsEnabled) {
        expect(Uint12.zero.toString(), contains('Uint12 {0}'));
      } else {
        expect(Uint12.zero.toString(), isNot(contains('Uint12 {0}')));
      }
    });

    test('should check ranges', () {
      final outOfRange = math.pow(2, 12) as int;
      expect(() => Uint12.checkRange(outOfRange), throwsRangeError);
      if (assertionsEnabled) {
        expect(() => Uint12.assertRange(outOfRange), throwsRangeError);
      }
    });

    test('should wrap values', () {
      expect(Uint12(1) & Uint12(2), Uint12(1 & 2));
    });
  });

  group('Uint24', () {
    test('should have a name', () {
      if (assertionsEnabled) {
        expect(Uint24.zero.toString(), contains('Uint24 {0}'));
      } else {
        expect(Uint24.zero.toString(), isNot(contains('Uint24 {0}')));
      }
    });

    test('should check ranges', () {
      final outOfRange = math.pow(2, 24) as int;
      expect(() => Uint24.checkRange(outOfRange), throwsRangeError);
      if (assertionsEnabled) {
        expect(() => Uint24.assertRange(outOfRange), throwsRangeError);
      }
    });

    test('should wrap values', () {
      expect(Uint24(1) & Uint24(2), Uint24(1 & 2));
    });
  });

  group('Int24', () {
    test('should have a name', () {
      if (assertionsEnabled) {
        expect(Int24.zero.toString(), contains('Int24 {0}'));
      } else {
        expect(Int24.zero.toString(), isNot(contains('Int24 {0}')));
      }
    });

    test('should check ranges', () {
      final outOfRange = math.pow(2, 23) as int;
      expect(() => Int24.checkRange(outOfRange), throwsRangeError);
      if (assertionsEnabled) {
        expect(() => Int24.assertRange(outOfRange), throwsRangeError);
      }
    });

    test('should wrap values', () {
      expect(Int24(1) & Int24(2), Int24(1 & 2));
    });
  });
}
