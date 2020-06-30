import 'package:binary/binary.dart';
import 'package:test/test.dart';

import '_common.dart';

void main() {
  // CCCC_101L_OOOO_OOOO_OOOO_OOOO_OOOO_OOOO
  test('B', () {
    final instruction = encode([
      '1010',
      32.toBinaryPadded(32 - 8),
    ]);
    expect(decode(instruction), matchesASM('b 32'));
  });

  // CCCC_101L_OOOO_OOOO_OOOO_OOOO_OOOO_OOOO
  test('BL', () {
    final instruction = encode([
      '1011',
      32.toBinaryPadded(32 - 8),
    ]);
    expect(decode(instruction), matchesASM('bl 32'));
  });

  // CCCC_0001_0010_1111_1111_1111_0001_NNNN
  test('BX', () {
    final instruction = encode([
      '0001',
      '0010',
      '1111',
      '1111',
      '1111',
      '0001',
      12.toBinaryPadded(4),
    ]);
    expect(decode(instruction), matchesASM('bx r12'));
  });
}
