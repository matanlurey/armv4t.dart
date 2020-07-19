import 'dart:typed_data';

import 'package:binary/binary.dart';
import 'package:meta/meta.dart';

@immutable
@sealed
abstract class Memory {
  /// Creates memory of the provided [size] \(in bytes).
  ///
  /// Optionally may provide existing [data] to import.
  factory Memory(int size, {List<int> data}) {
    if (size % 4 != 0) {
      throw ArgumentError.value(size, 'size', 'Must be divisible by 4');
    }
    final data = Uint8List(size);
    if (data != null) {
      final Object upcast = data;
      Uint8List view;
      if (upcast is TypedData) {
        view = Uint8List.view(upcast.buffer);
      } else {
        view = Uint8List.fromList(data);
      }
      data.setRange(0, view.length, view);
    }
    return _Memory(data);
  }

  /// Creates a null memory implemenation that throws on reads and writes.
  const factory Memory.none() = _NullMemory;

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

/// A simple implementation of memory in order to complete the interpreter.
class _Memory implements Memory {
  final Uint8List _bytes;
  final Uint16List _halfWords;
  final Uint32List _words;

  _Memory(this._bytes)
      : _halfWords = Uint16List.view(_bytes.buffer),
        _words = Uint32List.view(_bytes.buffer);

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
  Uint32 loadWord(Uint32 address) =>
      Uint32(_words[_wordAligned(address.value)]);

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
