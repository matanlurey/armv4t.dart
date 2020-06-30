import 'package:binary/binary.dart';
import 'package:test/test.dart';

import '_common.dart';

void main() {
  _testSoftwareInterrupt();
}

void _testSoftwareInterrupt() {
  // CCCC_1111_XXXX_XXXX_XXXX_XXXX_XXXX_XXXX
  int build(int x) {
    return encode([
      '1111',
      x.toBinaryPadded(32 - 8),
    ]);
  }

  test('SWI', () {
    expect(decode(build(8)), matchesASM('swi 8'));
  });
}
