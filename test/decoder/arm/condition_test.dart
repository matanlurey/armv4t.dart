import 'package:armv4t/src/decoder/arm/condition.dart';
import 'package:test/test.dart';

void main() {
  for (var i = 0; i < 16; i++) {
    test('Condition.parse(0x${i.toRadixString(16)})', () {
      final condition = Condition.parse(i);
      expect(condition.value, i);
    });
  }
}
