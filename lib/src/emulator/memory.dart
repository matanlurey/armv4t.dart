import 'dart:typed_data';

import 'package:binary/binary.dart';
import 'package:meta/meta.dart';

/// Represents a mutable block of continious memory available to a VM.
@immutable
@sealed
abstract class Memory {
  /// Creates an initialized memory block by copying [bytes].
  factory Memory.from(List<int> bytes) {
    final copy = Uint8List(bytes.length);
    for (var i = 0; i < bytes.length; i++) {
      copy[i] = bytes[i];
    }
    return _Memory(copy);
  }

  /// Creates an empty (`0x0` initialized) continous block of [bytes] size.
  factory Memory.empty(int bytes) => _Memory(Uint8List(bytes));

  /// Creates a delegating memory implementation to [delegate].
  ///
  /// May define [readOnly] ranges, otherwise the entire memory is read-only.
  ///
  /// **NOTE**: This constructor is considered _provisional_, and should not
  /// be used if possible. An actual well-behaved VM should handle reading and
  /// writing into protected memory with a specific contract - this constructor
  /// is mostly for testing/debugging.
  @experimental
  factory Memory.protected(
    Memory delegate, {
    Map<int, int> readOnly,
  }) {
    if (readOnly == null) {
      return _ReadOnlyMemory(delegate);
    } else {
      return _ProtectedMemory(delegate, readOnly.entries.toList());
    }
  }

  /// Creates a null memory implemenation that throws on reads and writes.
  const factory Memory.none() = _NullMemory;

  /// Length of memory, in bytes.
  int get length;

  /// Loads an 8-bit (byte) data from [address].
  Uint8 loadByte(Uint32 address);

  /// Stores a [byte] into [address].
  void storeByte(Uint32 address, Uint8 byte);

  /// Loads a 16-bit (half-word) data from [address].
  Uint16 loadHalfWord(Uint32 address);

  /// Stores a [halfWord] into [address].
  void storeHalfWord(Uint32 address, Uint16 halfWord);

  /// Loads a 32-bit (word) data from [address].
  Uint32 loadWord(Uint32 address);

  /// Stores a [word] into [address].
  void storeWord(Uint32 address, Uint32 word);
}

class _ReadOnlyMemory implements Memory {
  final Memory _delegate;

  const _ReadOnlyMemory(this._delegate);

  @override
  int get length => _delegate.length;

  @override
  Uint8 loadByte(Uint32 address) => _delegate.loadByte(address);

  @override
  Uint16 loadHalfWord(Uint32 address) => _delegate.loadHalfWord(address);

  @override
  Uint32 loadWord(Uint32 address) => _delegate.loadWord(address);

  @alwaysThrows
  // ignore: prefer_void_to_null
  Null _protected(Uint32 address) {
    throw UnsupportedError(
      'Writes not permitted to 0x${address.value.toRadixString(16)}',
    );
  }

  @override
  void storeByte(Uint32 address, Uint8 byte) => _protected(address);

  @override
  void storeHalfWord(Uint32 address, Uint16 halfWord) => _protected(address);

  @override
  void storeWord(Uint32 address, Uint32 word) => _protected(address);
}

class _ProtectedMemory extends _ReadOnlyMemory {
  final List<MapEntry<int, int>> _ranges;

  _ProtectedMemory(Memory delegate, this._ranges) : super(delegate);

  bool _isProtected(Uint32 address) {
    final value = address.value;
    for (final range in _ranges) {
      if (value >= range.key && value <= range.value) {
        return true;
      }
    }
    return false;
  }

  @override
  void storeByte(Uint32 address, Uint8 byte) {
    if (_isProtected(address)) {
      return super.storeByte(address, byte);
    } else {
      return _delegate.storeByte(address, byte);
    }
  }

  @override
  void storeHalfWord(Uint32 address, Uint16 halfWord) {
    if (_isProtected(address)) {
      return super.storeHalfWord(address, halfWord);
    } else {
      return _delegate.storeHalfWord(address, halfWord);
    }
  }

  @override
  void storeWord(Uint32 address, Uint32 word) {
    if (_isProtected(address)) {
      return super.storeWord(address, word);
    } else {
      return _delegate.storeWord(address, word);
    }
  }
}

/// A simple implementation of memory in order to complete the interpreter.
class _Memory implements Memory {
  final Uint8List _bytes;
  final Uint16List _halfWords;
  final Uint32List _words;

  _Memory(this._bytes)
      : _halfWords = Uint16List.view(_bytes.buffer),
        _words = Uint32List.view(_bytes.buffer);

  @override
  int get length => _bytes.length;

  @override
  Uint8 loadByte(Uint32 address) => Uint8(_bytes[address.value]);

  @override
  void storeByte(Uint32 address, Uint8 byte) {
    _bytes[address.value] = byte.value;
  }

  /// Maps an address defined in terms of bytes ([byteIndex]) to half-words.
  ///
  /// For example:
  /// ```txt
  /// BYTES:
  /// 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7
  ///                 ^
  ///                 byte=4
  /// HALF-WORDS:
  /// 0    | 1     | 2     | 3
  ///                ^
  ///                half-word=2
  /// ```
  static int _halfWordAligned(int byteIndex) {
    // Address must be half-word aligned (divisible by 2).
    if (byteIndex.isOdd) {
      throw ArgumentError('Address not half-word aligned: $byteIndex');
    } else {
      return byteIndex ~/ 2;
    }
  }

  @override
  Uint16 loadHalfWord(Uint32 address) {
    return Uint16(_halfWords[_halfWordAligned(address.value)]);
  }

  @override
  void storeHalfWord(Uint32 address, Uint16 word) {
    _halfWords[_halfWordAligned(address.value)] = word.value;
  }

  /// Maps an address defined in terms of bytes ([byteIndex]) to words.
  ///
  /// For example:
  /// ```txt
  /// BYTES:
  /// 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7
  ///                 ^
  ///                 byte=4
  /// HALF-WORDS:
  /// 0            | 1
  ///                ^
  ///                word=1
  /// ```
  static int _wordAligned(int byteIndex) {
    // Address must be word aligned (divisible by 4).
    if (byteIndex % 4 != 0) {
      throw ArgumentError('Address not word aligned: $byteIndex');
    } else {
      return byteIndex ~/ 4;
    }
  }

  @override
  Uint32 loadWord(Uint32 address) {
    return Uint32(_words[_wordAligned(address.value)]);
  }

  @override
  void storeWord(Uint32 address, Uint32 word) {
    _words[_wordAligned(address.value)] = word.value;
  }
}

class _NullMemory implements Memory {
  const _NullMemory();

  @alwaysThrows
  // ignore: prefer_void_to_null
  static Null _throw() => throw UnsupportedError('Cannot access null memory');

  @override
  int get length => 0;

  @override
  Uint8 loadByte(Uint32 address) => _throw();

  @override
  Uint16 loadHalfWord(Uint32 address) => _throw();

  @override
  Uint32 loadWord(Uint32 address) => _throw();

  @override
  void storeByte(Uint32 address, Uint8 byte) => _throw();

  @override
  void storeHalfWord(Uint32 address, Uint16 halfWord) => _throw();

  @override
  void storeWord(Uint32 address, Uint32 word) => _throw();
}
