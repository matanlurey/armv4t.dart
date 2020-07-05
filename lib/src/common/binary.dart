/// Extensions to `package:binary` that are not generally applicable/useful.
library armv4t.src.common.binary;

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
      return _builder.toString().parseBits().asUint32();
    }
  }
}
