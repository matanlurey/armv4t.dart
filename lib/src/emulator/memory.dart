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

  /// Loads a 16-bit (word) data from [address].
  Uint16 loadWord(Uint32 address);

  /// Stores a [word] into [address].
  void storeWord(Uint32 address, Uint16 word);
}

/// A simple implementation of memory in order to complete the interpreter.
class _Memory implements Memory {
  final Uint8List _data;

  const _Memory(this._data);

  @override
  Uint8 loadByte(Uint32 address) => Uint8(_data[address.value]);

  @override
  void storeByte(Uint32 address, Uint8 byte) {
    _data[address.value] = byte.value;
  }

  @override
  Uint16 loadWord(Uint32 address) {
    final hiByte = _data[address.value];
    final loByte = _data[address.value + 1];
    return Uint16(hiByte << 8 | loByte);
  }

  @override
  void storeWord(Uint32 address, Uint16 word) {
    _data.setRange(
      address.value,
      address.value + 1,
      [
        word.bitRange(16, 8).value,
        word.bitRange(7, 0).value,
      ],
    );
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
  Uint16 loadWord(Uint32 address) => _throw();

  @override
  void storeByte(Uint32 address, Uint8 byte) => _throw();

  @override
  void storeWord(Uint32 address, Uint16 word) => _throw();
}
