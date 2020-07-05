import 'package:armv4t/src/common/assert.dart';
import 'package:test/test.dart';

void main() {
  test('assertionsEnabled', () {
    var enabled = false;
    assert(enabled = true);
    if (enabled) {
      expect(assertionsEnabled, isTrue);
    } else {
      expect(assertionsEnabled, isFalse);
    }
  });
}
