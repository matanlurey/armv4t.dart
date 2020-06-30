import 'package:binary/binary.dart';
import 'package:test/test.dart';

import '_common.dart';

void main() {
  _testMultiply();
  _testMultiplyLong();
}

void _testMultiply() {
  // CCCC_0000_00AS_DDDD_NNNN_FFFF_1001_MMMM
  int build(int a, int s, int d, int n, int f, int m) {
    return encode([
      '0000',
      '00$a$s',
      d.toBinaryPadded(4),
      n.toBinaryPadded(4),
      f.toBinaryPadded(4),
      '1001',
      m.toBinaryPadded(4),
    ]);
  }

  test('MUL', () {
    expect(
      decode(build(0, 0, 2, 4, 6, 8)),
      matchesASM('mul r2, r4, r6'),
    );
  });

  test('MLA', () {
    expect(
      decode(build(1, 0, 2, 4, 6, 8)),
      matchesASM('mla r2, r6, r4, r8'),
    );
  });
}

void _testMultiplyLong() {
  // CCCC_0000_1UAS_DDDD_FFFF_NNNN_1001_MMMM
  int build(int u, int a, int s, int d, int f, int n, int m) {
    return encode([
      '0000',
      '1$u$a$s',
      d.toBinaryPadded(4),
      f.toBinaryPadded(4),
      n.toBinaryPadded(4),
      '1001',
      m.toBinaryPadded(4),
    ]);
  }

  test('SMULL', () {
    expect(
      decode(build(0, 0, 0, 2, 4, 6, 8)),
      matchesASM('smull r4, r2, r6, r8'),
    );
  });

  test('SMLAL', () {
    expect(
      decode(build(0, 1, 0, 2, 4, 6, 8)),
      matchesASM('smlal r4, r2, r6, r8'),
    );
  });

  test('UMULL', () {
    expect(
      decode(build(1, 0, 0, 2, 4, 6, 8)),
      matchesASM('umull r4, r2, r6, r8'),
    );
  });

  test('UMLAL', () {
    expect(
      decode(build(1, 1, 0, 2, 4, 6, 8)),
      matchesASM('umlal r4, r2, r6, r8'),
    );
  });
}
