import 'package:armv4t/src/common/union.dart';
import 'package:test/test.dart';

void main() {
  group('Or2', () {
    Or2<int, String> or2;

    test('left', () {
      or2 = Or2.left(5);
      expect(
        or2.pick(
          expectAsync1((value) {
            expect(value, 5);
            return 'left';
          }),
          (_) => 'right',
        ),
        'left',
      );
    });

    test('right', () {
      or2 = Or2.right('Hello');
      expect(
        or2.pick(
          (_) => 'left',
          expectAsync1((value) {
            expect(value, 'Hello');
            return 'right';
          }),
        ),
        'right',
      );
    });
  });

  group('Or3', () {
    Or3<int, String, bool> or3;

    test('left', () {
      or3 = Or3.left(5);
      expect(
        or3.pick(
          expectAsync1((value) {
            expect(value, 5);
            return 'left';
          }),
          (_) => 'middle',
          (_) => 'right',
        ),
        'left',
      );
    });

    test('middle', () {
      or3 = Or3.middle('Hello');
      expect(
        or3.pick(
          (_) => 'left',
          expectAsync1((value) {
            expect(value, 'Hello');
            return 'middle';
          }),
          (_) => 'right',
        ),
        'middle',
      );
    });

    test('right', () {
      or3 = Or3.right(true);
      expect(
        or3.pick(
          (_) => 'left',
          (_) => 'middle',
          expectAsync1((value) {
            expect(value, isTrue);
            return 'right';
          }),
        ),
        'right',
      );
    });
  });
}
