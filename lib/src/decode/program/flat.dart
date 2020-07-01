import 'dart:typed_data';

class FlatBinaryProgram {
  final Uint8List _bytes;

  FlatBinaryProgram.fromBytes(this._bytes);

  var _position = 0;

  /// Current position in the program.
  int get position => _position;
  set position(int position) {
    RangeError.checkValidIndex(position, _bytes);
    _position = position;
  }

  /// Length (in bytes) of the program.
  int get length => _bytes.length;

  /// Reads 4 bytes (32-bits).
  int read32() {
    final result = Uint32List.sublistView(_bytes, position, position + 4)[0];
    position += 4;
    return result;
  }

  /// Reads 2 bytes (16-bits).
  int read16() {
    final result = Uint16List.sublistView(_bytes, position, position + 2)[0];
    position += 2;
    return result;
  }
}
