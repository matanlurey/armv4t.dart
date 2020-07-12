import 'package:armv4t/src/common/assert.dart';
import 'package:binary/binary.dart';
import 'package:meta/meta.dart';

/// Represents a 64-bit number either before or after operations.
@sealed
abstract class Num64 {
  /// The maximum 32-bit value, or [loBits] = `0xffffffff`.
  static const Num64 max32Bits = _ResultNum64(0x00000000, 0xffffffff);

  /// The maximum 64-bit value, or [loBits] and [hiBits] = `0xffffffff`.
  static const Num64 max64Bits = _ResultNum64(0xffffffff, 0xffffffff);

  /// Creates a [Num64] from a guaranteed [loBits] only value, [immediate].
  factory Num64.fromUint32(Uint32 immediate) = _Uint32Num64;

  /// Creates a [Num64] from a pair of both [hiBits] and [loBits].
  factory Num64.fromHiLo(int hiBits, int loBits) {
    Uint32.checkRange(hiBits);
    Uint32.checkRange(loBits);
    return _ResultNum64(hiBits, loBits);
  }

  /// Creates a [Num64] from just [loBits].
  factory Num64(int loBits) {
    return _ResultNum64(0, Uint32.checkRange(loBits));
  }

  /// Hi (upper 32-bits), if any.
  final int hiBits;

  /// Lo (lower 32-bits).
  final int loBits;

  const Num64._(this.hiBits, this.loBits);

  @override
  @nonVirtual
  bool operator ==(Object o) {
    return o is Num64 && hiBits == o.hiBits && loBits == o.loBits;
  }

  @override
  @nonVirtual
  int get hashCode => hiBits.hashCode ^ loBits.hashCode;

  /// Whether this value represents `0`.
  @nonVirtual
  bool get isZero => hiBits == 0 && loBits == 0;

  /// Adds two numbers together, returning a resulting number.
  @nonVirtual
  Num64 operator +(Num64 other) {
    final loBitSum = loBits + other.loBits;
    final overflow = loBitSum.bitRange(64, 32);
    final loBitVal = loBitSum.bitRange(31, 0);
    final hiBitSum = hiBits + other.hiBits + overflow;
    final hiBitVal = hiBitSum.bitRange(31, 0);
    return _ResultNum64(hiBitVal.toUnsigned(32), loBitVal.toUnsigned(32));
  }

  /// Subtracts two numbers, returning a resulting number.
  @nonVirtual
  Num64 operator -(Num64 other) {
    if (hiBits > other.hiBits) {
      var hi = hiBits - other.hiBits;
      var lo = loBits - other.loBits;
      if (lo < 0) {
        hi -= 1;
        lo += 0x100000000;
      }
      return _ResultNum64(hi.toUnsigned(32), lo.toUnsigned(32));
    } else if (hiBits < other.hiBits) {
      var hi = hiBits - other.hiBits;
      var lo = loBits - other.loBits;
      if (hi < 0) {
        hi += 0x100000000;
      }
      if (lo < 0) {
        lo += 0x100000000;
        hi -= 1;
      }
      return _ResultNum64(hi.toUnsigned(32), lo.toUnsigned(32));
    } else {
      return _ResultNum64(0, (loBits - other.loBits).toUnsigned(32));
    }
  }

  @override
  String toString() {
    if (assertionsEnabled) {
      return ''
          'Num64 { '
          'hi = 0x${hiBits.toRadixString(16).padLeft(8, '0')}, '
          'lo = 0x${loBits.toRadixString(16).padLeft(8, '0')}';
    } else {
      return super.toString();
    }
  }
}

/// An immediate result [Num64] that is created from an [Uint32] instance.
class _Uint32Num64 extends Num64 {
  _Uint32Num64(Uint32 value) : super._(0, value.value);
}

/// A computed result [Num64] that is created from a mathematical operation.
class _ResultNum64 extends Num64 {
  const _ResultNum64(
    int hiBits,
    int loBits,
  ) : super._(hiBits, loBits);
}
