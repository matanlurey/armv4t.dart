import 'package:armv4t/src/emulator/number.dart';
import 'package:test/test.dart';

void main() {
  group('+', () {
    test('0 + 0', () {
      final a = Num64(0);
      final b = Num64(0);
      final c = a + b;

      expect(c, Num64(0));
      expect(c.isZero, isTrue);
    });

    test('0 + 1', () {
      final a = Num64(0);
      final b = Num64(1);
      final c = a + b;

      expect(c, Num64(1));
    });

    test('1:0 + 1:0', () {
      final a = Num64.fromHiLo(1, 0);
      final b = Num64.fromHiLo(1, 0);
      final c = a + b;

      expect(c, Num64.fromHiLo(2, 0));
    });

    test('1:0 + 0:1', () {
      final a = Num64.fromHiLo(1, 0);
      final b = Num64.fromHiLo(0, 1);
      final c = a + b;

      expect(c, Num64.fromHiLo(1, 1));
    });

    test('0:MAX + 0:1', () {
      final a = Num64.max32Bits;
      final b = Num64(1);
      final c = a + b;

      expect(c, Num64.fromHiLo(1, 0));
    });

    test('0:MAX + 0:MAX', () {
      final a = Num64.max32Bits;
      final b = Num64.max32Bits;
      final c = a + b;

      expect(c, Num64.fromHiLo(1, 0xffffffff - 1));
    });
  });

  group('-', () {
    test('1 - 1', () {
      final a = Num64(1);
      final b = Num64(1);
      final c = a - b;

      expect(c, Num64(0));
      expect(c.isZero, isTrue);
    });

    test('0 - 1', () {
      final a = Num64(0);
      final b = Num64(1);
      final c = a - b;

      expect(c, Num64.max32Bits);
    });

    test('1:0 - 0:1', () {
      final a = Num64.fromHiLo(1, 0);
      final b = Num64.fromHiLo(0, 1);
      final c = a - b;

      expect(c, Num64.max32Bits);
    });

    test('1:0xf, - 0:1', () {
      final a = Num64.fromHiLo(1, 0xf);
      final b = Num64.fromHiLo(0, 1);
      final c = a - b;

      expect(c, Num64.fromHiLo(1, 0xe));
    });

    test('1:0xf - 0:0xf000000', () {
      final a = Num64.fromHiLo(1, 0xf);
      final b = Num64.fromHiLo(0, 0xf0000000);
      final c = a - b;

      expect(c, Num64.fromHiLo(0, 0x1000000f));
    });

    test('0:0 - 0xf:0', () {
      final a = Num64.fromHiLo(0, 0);
      final b = Num64.fromHiLo(0xf, 0);
      final c = a - b;

      expect(c, Num64.fromHiLo(0x100000000 - 0xf, 0));
    });

    test('0xe:0 - 0xf:0xf0000000', () {
      final a = Num64.fromHiLo(0xe, 0);
      final b = Num64.fromHiLo(0xf, 0xf0000000);
      final c = a - b;

      expect(c, Num64.fromHiLo(0xfffffffe, 0x10000000));
    });
  });
}
