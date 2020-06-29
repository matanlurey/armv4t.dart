import 'package:armv4t/src/decode/arm/condition.dart';
import 'package:binary/binary.dart';
import 'package:test/test.dart';

void main() {
  Condition.values.forEach((condition) {
    test('$condition', () {
      expect(
        const ArmConditionDecoder().decodeBits(condition.index),
        condition,
        reason: 'Expected ${condition.index.toBinaryPadded(4)} == $condition',
      );
    });
  });
}
