import 'package:binary/binary.dart';
import 'package:meta/meta.dart';

extension on Uint32 {
  Uint32 operator +(int amount) => Uint32(value + amount);
  Uint32 operator -(int amount) => Uint32(value - amount);
}

/// A helper for executing multiple register data transfer/stack operations.
///
/// Given an instruction like `LDMxx r10, {r0, r1, r4}`:
///
/// ```
///                             IA   IB   DA   DB
///                             __   r4   __   __
///                             r4   r1   __   __      ^
///                             r1   r0   __   __      ^  Increasing
/// Base Register (r10):        r0   __   r4   __      ^   Addresses
///                             __   __   r1   r4      ^
///                             __   __   r0   r1
///                             __   __   __   r0
/// ```
abstract class RegisterStack {
  factory RegisterStack.incrementAfter(
    Uint32 base,
    int offset, {
    @required int size,
  }) = _IncrementAfter;

  factory RegisterStack.incrementBefore(
    Uint32 base,
    int offset, {
    @required int size,
  }) = _IncrementBefore;

  factory RegisterStack.decrementAfter(
    Uint32 base,
    int offset, {
    @required int size,
  }) = _DecrementAfter;

  factory RegisterStack.decrementBefore(
    Uint32 base,
    int offset, {
    @required int size,
  }) = _DecrementBefore;

  /// Original base address (unmodified).
  final Uint32 base;

  /// Offset address.
  final int _offset;

  /// Size of the stack (e.g. number of registers).
  final int _size;

  /// What the next result of [next] will be.
  Uint32 _next;

  RegisterStack._(this.base, this._offset, this._size) {
    if (_size < 1) {
      throw RangeError.value(_size, 'registers');
    }
  }

  /// Returns the next memory location based on the addressing mode.
  ///
  /// This is guaranteed to return the _lowest_ address first, moving upwards.
  @nonVirtual
  Uint32 next() {
    final result = _next;
    _next = _next + _offset;
    return result;
  }

  /// The address that would be written back, if enabled.
  Uint32 get writeBack;
}

class _IncrementAfter extends RegisterStack {
  _IncrementAfter(
    Uint32 base,
    int offset, {
    @required int size,
  }) : super._(base, offset, size) {
    _next = base;
  }

  @override
  Uint32 get writeBack => base + _size * _offset;
}

class _IncrementBefore extends RegisterStack {
  _IncrementBefore(
    Uint32 base,
    int offset, {
    @required int size,
  }) : super._(base, offset, size) {
    _next = base + _offset;
  }

  @override
  Uint32 get writeBack => base + _size * _offset;
}

class _DecrementAfter extends RegisterStack {
  _DecrementAfter(
    Uint32 base,
    int offset, {
    @required int size,
  }) : super._(base, offset, size) {
    _next = base - ((size - 1) * offset);
  }

  @override
  Uint32 get writeBack => base - _size * _offset;
}

class _DecrementBefore extends RegisterStack {
  _DecrementBefore(
    Uint32 base,
    int offset, {
    @required int size,
  }) : super._(base, offset, size) {
    _next = base - (size * offset);
  }

  @override
  Uint32 get writeBack => base - _size * _offset;
}
