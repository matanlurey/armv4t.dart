import 'package:armv4t/src/emulator/stack.dart';
import 'package:binary/binary.dart';
import 'package:test/test.dart';

void main() {
  group('RegisterStack', () {
    Uint32 base;

    setUp(() {
      base = Uint32(0x200);
    });

    RegisterStack stack;

    test('.incrementAfter', () {
      stack = RegisterStack.incrementAfter(base, 4);
      expect(
        List.generate(3, (_) => stack.next()),
        [
          Uint32(0x200),
          Uint32(0x200 + 4),
          Uint32(0x200 + 8),
        ],
      );
    });

    test('.incrementBefore', () {
      stack = RegisterStack.incrementBefore(base, 4);
      expect(
        List.generate(3, (_) => stack.next()),
        [
          Uint32(0x200 + 4),
          Uint32(0x200 + 8),
          Uint32(0x200 + 12),
        ],
      );
    });

    test('.decrementAfter', () {
      stack = RegisterStack.decrementAfter(base, 4);
      expect(
        List.generate(3, (_) => stack.next()),
        [
          Uint32(0x200),
          Uint32(0x200 - 4),
          Uint32(0x200 - 8),
        ],
      );
    });

    test('.decrementBefore', () {
      stack = RegisterStack.decrementBefore(base, 4);
      expect(
        List.generate(3, (_) => stack.next()),
        [
          Uint32(0x200 - 4),
          Uint32(0x200 - 8),
          Uint32(0x200 - 12),
        ],
      );
    });
  });
}
