/// Extensions to `package:binary` that are not generally applicable/useful.
library armv4t.src.common.binary;

import 'dart:typed_data';

import 'package:binary/binary.dart';
import 'package:meta/meta.dart';

import 'assert.dart';

/// Encapsulates an unsigned 2-bit aggregation.
@sealed
class Uint2 extends Integral<Uint2> {
  /// Returns [value] if in range, otherwise throws [RangeError].
  static int checkRange(int value) => Uint2(value).value;

  /// Returns [value].
  ///
  /// When assertions are enabled, throws a [RangeError].
  static int assertRange(int value) {
    return assertionsEnabled ? checkRange(value) : value;
  }

  static const _name = 'Uint2';
  static const _size = 2;
  static const _signed = false;

  /// A pre-computed instance of `Uint2(0)`.
  static const zero = Uint2._(0);

  /// Wraps a [value] that is otherwise a valid 24-bit unsigned integer.
  Uint2(int value)
      : super.checked(
          value: value,
          signed: _signed,
          size: _size,
        );

  const Uint2._(int value)
      : super.unchecked(
          value: value,
          signed: _signed,
          size: _size,
        );

  @override
  Uint2 wrapSafeValue(int value) => Uint2(value);

  @override
  String toDebugString() => '$_name {$value}';
}

/// Encapsulates an unsigned 3-bit aggregation.
@sealed
class Uint3 extends Integral<Uint3> {
  /// Returns [value] if in range, otherwise throws [RangeError].
  static int checkRange(int value) => Uint3(value).value;

  /// Returns [value].
  ///
  /// When assertions are enabled, throws a [RangeError].
  static int assertRange(int value) {
    return assertionsEnabled ? checkRange(value) : value;
  }

  static const _name = 'Uint3';
  static const _size = 3;
  static const _signed = false;

  /// A pre-computed instance of `Uint3(0)`.
  static const zero = Uint3._(0);

  /// Wraps a [value] that is otherwise a valid 3-bit unsigned integer.
  Uint3(int value)
      : super.checked(
          value: value,
          signed: _signed,
          size: _size,
        );

  const Uint3._(int value)
      : super.unchecked(
          value: value,
          signed: _signed,
          size: _size,
        );

  @override
  Uint3 wrapSafeValue(int value) => Uint3(value);

  @override
  String toDebugString() => '$_name {$value}';
}

/// Encapsulates an unsigned 5-bit aggregation.
@sealed
class Uint5 extends Integral<Uint5> {
  /// Returns [value] if in range, otherwise throws [RangeError].
  static int checkRange(int value) => Uint5(value).value;

  /// Returns [value].
  ///
  /// When assertions are enabled, throws a [RangeError].
  static int assertRange(int value) {
    return assertionsEnabled ? checkRange(value) : value;
  }

  static const _name = 'Uint5';
  static const _size = 5;
  static const _signed = false;

  /// A pre-computed instance of `Uint5(0)`.
  static const zero = Uint5._(0);

  /// Wraps a [value] that is otherwise a valid 5-bit unsigned integer.
  Uint5(int value)
      : super.checked(
          value: value,
          signed: _signed,
          size: _size,
        );

  const Uint5._(int value)
      : super.unchecked(
          value: value,
          signed: _signed,
          size: _size,
        );

  @override
  Uint5 wrapSafeValue(int value) => Uint5(value);

  @override
  String toDebugString() => '$_name {$value}';
}

/// Encapsulates an unsigned 7-bit aggregation.
@sealed
class Uint7 extends Integral<Uint7> {
  /// Returns [value] if in range, otherwise throws [RangeError].
  static int checkRange(int value) => Uint7(value).value;

  /// Returns [value].
  ///
  /// When assertions are enabled, throws a [RangeError].
  static int assertRange(int value) {
    return assertionsEnabled ? checkRange(value) : value;
  }

  static const _name = 'Uint7';
  static const _size = 7;
  static const _signed = false;

  /// A pre-computed instance of `Uint7(0)`.
  static const zero = Uint7._(0);

  /// Wraps a [value] that is otherwise a valid 7-bit unsigned integer.
  Uint7(int value)
      : super.checked(
          value: value,
          signed: _signed,
          size: _size,
        );

  const Uint7._(int value)
      : super.unchecked(
          value: value,
          signed: _signed,
          size: _size,
        );

  @override
  Uint7 wrapSafeValue(int value) => Uint7(value);

  @override
  String toDebugString() => '$_name {$value}';
}

/// Encapsulates an unsigned 10-bit aggregation.
@sealed
class Uint10 extends Integral<Uint10> {
  /// Returns [value] if in range, otherwise throws [RangeError].
  static int checkRange(int value) => Uint10(value).value;

  /// Returns [value].
  ///
  /// When assertions are enabled, throws a [RangeError].
  static int assertRange(int value) {
    return assertionsEnabled ? checkRange(value) : value;
  }

  static const _name = 'Uint10';
  static const _size = 10;
  static const _signed = false;

  /// A pre-computed instance of `Uint10(0)`.
  static const zero = Uint10._(0);

  /// Wraps a [value] that is otherwise a valid 10-bit unsigned integer.
  Uint10(int value)
      : super.checked(
          value: value,
          signed: _signed,
          size: _size,
        );

  const Uint10._(int value)
      : super.unchecked(
          value: value,
          signed: _signed,
          size: _size,
        );

  @override
  Uint10 wrapSafeValue(int value) => Uint10(value);

  @override
  String toDebugString() => '$_name {$value}';
}

/// Encapsulates an unsigned 11-bit aggregation.
@sealed
class Uint11 extends Integral<Uint11> {
  /// Returns [value] if in range, otherwise throws [RangeError].
  static int checkRange(int value) => Uint11(value).value;

  /// Returns [value].
  ///
  /// When assertions are enabled, throws a [RangeError].
  static int assertRange(int value) {
    return assertionsEnabled ? checkRange(value) : value;
  }

  static const _name = 'Uint11';
  static const _size = 11;
  static const _signed = false;

  /// A pre-computed instance of `Uint11(0)`.
  static const zero = Uint11._(0);

  /// Wraps a [value] that is otherwise a valid 11-bit unsigned integer.
  Uint11(int value)
      : super.checked(
          value: value,
          signed: _signed,
          size: _size,
        );

  const Uint11._(int value)
      : super.unchecked(
          value: value,
          signed: _signed,
          size: _size,
        );

  @override
  Uint11 wrapSafeValue(int value) => Uint11(value);

  @override
  String toDebugString() => '$_name {$value}';
}

/// Encapsulates an unsigned 12-bit aggregation.
@sealed
class Uint12 extends Integral<Uint12> {
  /// Returns [value] if in range, otherwise throws [RangeError].
  static int checkRange(int value) => Uint12(value).value;

  /// Returns [value].
  ///
  /// When assertions are enabled, throws a [RangeError].
  static int assertRange(int value) {
    return assertionsEnabled ? checkRange(value) : value;
  }

  static const _name = 'Uint12';
  static const _size = 12;
  static const _signed = false;

  /// A pre-computed instance of `Uint12(0)`.
  static const zero = Uint12._(0);

  /// Wraps a [value] that is otherwise a valid 24-bit unsigned integer.
  Uint12(int value)
      : super.checked(
          value: value,
          signed: _signed,
          size: _size,
        );

  const Uint12._(int value)
      : super.unchecked(
          value: value,
          signed: _signed,
          size: _size,
        );

  @override
  Uint12 wrapSafeValue(int value) => Uint12(value);

  @override
  String toDebugString() => '$_name {$value}';
}

/// Encapsulates an unsigned 24-bit aggregation.
@sealed
class Uint24 extends Integral<Uint24> {
  /// Returns [value] if in range, otherwise throws [RangeError].
  static int checkRange(int value) => Uint24(value).value;

  /// Returns [value].
  ///
  /// When assertions are enabled, throws a [RangeError].
  static int assertRange(int value) {
    return assertionsEnabled ? checkRange(value) : value;
  }

  static const _name = 'Uint24';
  static const _size = 24;
  static const _signed = false;

  /// A pre-computed instance of `Uint24(0)`.
  static const zero = Uint24._(0);

  /// Wraps a [value] that is otherwise a valid 24-bit unsigned integer.
  Uint24(int value)
      : super.checked(
          value: value,
          signed: _signed,
          size: _size,
        );

  const Uint24._(int value)
      : super.unchecked(
          value: value,
          signed: _signed,
          size: _size,
        );

  @override
  Uint24 wrapSafeValue(int value) => Uint24(value);

  @override
  String toDebugString() => '$_name {$value}';
}

extension Uint24X on Uint24 {
  Int24 toSigned() => Int24(value.toSigned(24));
}

/// Encapsulates an signed 24-bit aggregation.
@sealed
class Int24 extends Integral<Int24> {
  /// Returns [value] if in range, otherwise throws [RangeError].
  static int checkRange(int value) => Int24(value).value;

  /// Returns [value].
  ///
  /// When assertions are enabled, throws a [RangeError].
  static int assertRange(int value) {
    return assertionsEnabled ? checkRange(value) : value;
  }

  static const _name = 'Int24';
  static const _size = 24;
  static const _signed = true;

  /// A pre-computed instance of `Int24(0)`.
  static const zero = Int24._(0);

  /// Wraps a [value] that is otherwise a valid 24-bit unsigned integer.
  Int24(int value)
      : super.checked(
          value: value,
          signed: _signed,
          size: _size,
        );

  const Int24._(int value)
      : super.unchecked(
          value: value,
          signed: _signed,
          size: _size,
        );

  @override
  Int24 wrapSafeValue(int value) => Int24(value);

  @override
  String toDebugString() => '$_name {$value}';
}

/// Allows incrementally building a [Uint16] from most to least significant.
class Uint16Builder {
  final _builder = StringBuffer();

  /// Write a string-encoded binary number.
  void write(String v) => _builder.write(v);

  /// Write a bool-encoded bit.
  void writeBool(bool v) => write(v ? '1' : '0');

  /// Write a partial integer.
  void writeInt(Integral<void> v) => write(v.toBinaryPadded());

  /// Returns as a [Uint16].
  Uint16 build() {
    if (_builder.length != 16) {
      throw RangeError.value(_builder.length);
    } else {
      return Uint16(_builder.toString().bits);
    }
  }
}

/// Allows incrementally building a [Uint32] from most to least significant.
class Uint32Builder {
  final _builder = StringBuffer();

  /// Write a string-encoded binary number.
  void write(String v) => _builder.write(v);

  /// Write a bool-encoded bit.
  void writeBool(bool v) => write(v ? '1' : '0');

  /// Write a partial integer.
  void writeInt(Integral<void> v) => write(v.toBinaryPadded());

  /// Returns as a [Uint32].
  Uint32 build() {
    if (_builder.length != 32) {
      throw RangeError.value(_builder.length);
    } else {
      return Uint32(_builder.toString().bits);
    }
  }
}

/// Additional extensions for [Uint32List] for this package specifically.
extension BinaryUint64HiLoX on Uint32List {
  static Uint32List _new(int hi, int lo) => Uint32List(2)
    ..hi = hi
    ..lo = lo;

  /// Returns whether the operands that creates this int that overflow occured.
  bool hadOverflow(bool aSigned, bool bSigned) {
    return aSigned == bSigned && aSigned != isSigned;
  }

  /// Whether the MSB of [lo] was discarded (shifted into [hi]).
  bool get isCarry => hi != 0 ? msb(1) : false;

  /// Whether this value represents `0`.
  bool get isZero => hi == 0 && lo == 0;

  /// Whether the most significant bit is `1`.
  bool get isSigned => msb(hi == 0 ? 1 : 0);

  /// Adds `this` to [other] and returns a new [BinaryUint64HiLo].
  Uint32List add64(Uint32List other) {
    final a = this;
    final b = other;

    final loBitSum = (a.lo + b.lo).hiLo();
    final overflow = loBitSum.hi;
    final loBitVal = loBitSum.lo;
    final hiBitSum = (a.hi + b.hi + overflow).hiLo();
    final hiBitVal = hiBitSum.lo;

    return _new(hiBitVal, loBitVal);
  }

  /// Subtracts [other] from `this` and returns a new [BinaryUint64HiLo].
  Uint32List sub64(Uint32List other) {
    final aHi = hi;
    final aLo = lo;
    final bHi = other.hi;
    final bLo = other.lo;
    if (aHi == bHi) {
      return _new(0, aLo - bLo);
    }

    var cHi = aHi - bHi;
    var cLo = aLo - bLo;
    if (cLo < 0) {
      cHi -= 1;
      cLo += 0x100000000;
    }

    if (aHi > bHi && aHi < 0) {
      cHi += 0x100000000;
    }

    return _new(cHi, cLo);
  }

  /// Multiples [other] and `this` and returns a new [BinaryUint64HiLo].
  Uint32List mul64(
    Uint32List other, {
    int overflow = 0,
  }) {
    final aHi = hi;
    final aLo = lo;
    final bHi = other.hi;
    final bLo = other.lo;

    var result = aLo * bLo + overflow;

    final tHi = (aLo * bHi + aHi * bLo).hiLo();
    result += tHi.hi;

    final rHl = result.hiLo();

    overflow = tHi.hi + rHl.hi;
    result = rHl.lo;
    overflow += aHi * bHi;

    return _new(overflow, result);
  }

  /// Returns truncated purely as a [Uint32] ([lo]).
  Uint32 toUint32() => Uint32(lo);

  /// Returns as a [Int32List].
  Int32List asSigned() => Int32List.view(buffer);
}

/// Additional extensions for [Int32List] for this package specifically.
extension BinaryInt64HiLoX on Int32List {
  static Int32List _new(int hi, int lo) => Int32List(2)
    ..hi = hi
    ..lo = lo;

  /// Adds `this` to [other] and returns a new [Int32List].
  Int32List add64(Int32List other) {
    final a = this;
    final b = other;

    final loBitSum = (a.lo + b.lo).hiLo().asSigned();
    final overflow = loBitSum.hi;
    final loBitVal = loBitSum.lo;
    final hiBitSum = (a.hi + b.hi + overflow).hiLo().asSigned();
    final hiBitVal = hiBitSum.lo;

    return _new(hiBitVal, loBitVal);
  }

  /// Multiples [other] and `this` and returns a new [Int32List].
  Int32List mul64(
    Int32List other, {
    int overflow = 0,
  }) {
    final aHi = hi;
    final aLo = lo;
    final bHi = other.hi;
    final bLo = other.lo;

    var result = aLo * bLo + overflow;

    final tHi = (aLo * bHi + aHi * bLo).hiLo().asSigned();
    result += tHi.hi;

    final rHl = result.hiLo().asSigned();

    overflow = tHi.hi + rHl.hi;
    result = rHl.lo;
    overflow += aHi * bHi;

    return _new(overflow, result);
  }

  int get hi => this[0];
  set hi(int hi) => this[0] = hi;

  int get lo => this[1];
  set lo(int lo) => this[1] = lo;

  /// Returns as a [Uint32List].
  Uint32List asUnsigned() => Uint32List.view(buffer);
}

/// Additional extensions for [Uint32] for this package specifically.
extension BinaryUint64FromUint32 on Uint32 {
  static Uint32List _new(int hi, int lo) => Uint32List(2)
    ..hi = hi
    ..lo = lo;

  /// Adds `this` to [other] and returns a [BinaryUint64HiLo].
  Uint32List operator +(Uint32 other) => hiLo().add64(other.hiLo());

  /// Subtracts [other] from `this` and returns a [BinaryUint64HiLo].
  Uint32List operator -(Uint32 other) => hiLo().sub64(other.hiLo());

  /// Multiples `this` and [other] and returns a [BinaryUint64HiLo].
  Uint32List operator *(Uint32 other) => hiLo().mul64(other.hiLo());

  /// Similar to `BinaryInt.hiLo` but guarantees just low bits.
  Uint32List hiLo() => _new(0, value);

  /// Returns as a signed [Int32].
  Int32 toSigned() => Int32(value.toSigned(32));
}

/// Additional extensions for [Int32] for this package specifically.
extension BinaryInt64FromUint32 on Int32 {
  static Int32List _new(int hi, int lo) => Int32List(2)
    ..hi = hi
    ..lo = lo;

  /// Multiples `this` and [other] and returns a [BinaryUint64HiLo].
  Int32List operator *(Int32 other) => hiLo().mul64(other.hiLo());

  /// Similar to `BinaryInt.hiLo` but guarantees just low bits.
  Int32List hiLo() => _new(0, value);

  /// Returns as an unsigned [Uint32].
  Uint32 toUnsigned() => Uint32(value.toUnsigned(32));
}
