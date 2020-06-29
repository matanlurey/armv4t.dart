import 'package:binary/binary.dart';
import 'package:meta/meta.dart';
import 'package:test/test.dart';

import '_common.dart';

void main() {
  // CCCC_110P_UNWL_MMMM_DDDD_KKKK_OOOO_OOOO
  group('COPROCESSOR_DATA_TRANSFER', () {
    int build({
      int p = 0,
      int u = 0,
      int n = 0,
      int w = 0,
      @required int l,
      int m = 2,
      int d = 4,
      int k = 6,
      int o = 8,
    }) {
      return encode([
        '110$p',
        '$u$n$w$l',
        m.toBinaryPadded(4),
        d.toBinaryPadded(4),
        k.toBinaryPadded(4),
        o.toBinaryPadded(8),
      ]);
    }

    group('LDC [L = 1]', () {
      test('<Default>', () {
        final instruction = build(l: 1);
        expect(decode(instruction), matchesASM('LDC P6, C4, [R2, #-8]'));
      });

      test('P = 1', () {
        final instruction = build(l: 1, p: 1);
        expect(decode(instruction), matchesASM('LDC P6, C4, [R2], #-8'));
      });

      test('U = 1', () {
        final instruction = build(l: 1, u: 1);
        expect(decode(instruction), matchesASM('LDC P6, C4, [R2, #+8]'));
      });

      test('N = 1', () {
        final instruction = build(l: 1, n: 1);
        expect(decode(instruction), matchesASM('LDCL P6, C4, [R2, #-8]'));
      });

      test('W = 1', () {
        final instruction = build(l: 1, w: 1);
        expect(decode(instruction), matchesASM('LDC P6, C4, [R2, #-8]!'));
      });
    });

    group('STC [L = 0]', () {
      test('<Default>', () {
        final instruction = build(l: 0);
        expect(decode(instruction), matchesASM('STC P6, C4, [R2, #-8]'));
      });

      test('P = 1', () {
        final instruction = build(l: 0, p: 1);
        expect(decode(instruction), matchesASM('STC P6, C4, [R2], #-8'));
      });

      test('U = 1', () {
        final instruction = build(l: 0, u: 1);
        expect(decode(instruction), matchesASM('STC P6, C4, [R2, #+8]'));
      });

      test('N = 1', () {
        final instruction = build(l: 0, n: 1);
        expect(decode(instruction), matchesASM('STCL P6, C4, [R2, #-8]'));
      });

      test('W = 1', () {
        final instruction = build(l: 0, w: 1);
        expect(decode(instruction), matchesASM('STC P6, C4, [R2, #-8]!'));
      });
    });
  });

  // CCCC_1110_OOOO_NNNN_DDDD_PPPP_VVV0_MMMM
  group('COPROCESSOR_DATA_OPERATION', () {
    int build(int o, int n, int d, int c, int p, int m) {
      return encode([
        '1110',
        o.toBinaryPadded(4),
        n.toBinaryPadded(4),
        d.toBinaryPadded(4),
        c.toBinaryPadded(4),
        p.toBinaryPadded(3),
        '0',
        m.toBinaryPadded(4)
      ]);
    }

    test('CDP', () {
      final instruction = build(1, 2, 3, 4, 5, 6);
      expect(decode(instruction), matchesASM(''));
    });
  });

  // CCCC_1110_OOOL_NNNN_DDDD_PPPP_VVV1_MMMM
  group('COPROCESSOR_REGISTER_TRANSFER', () {});
}
