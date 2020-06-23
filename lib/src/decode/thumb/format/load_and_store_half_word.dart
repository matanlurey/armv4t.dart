part of '../format.dart';

/// Decoded object from [ThumbInstructionSet.$10$loadAndStoreHalfword].
class LoadAndStoreHalfWord extends ThumbInstructionSet {
  static final decoder = ThumbInstructionSetDecoder._(
    ThumbInstructionSet.$10$loadAndStoreHalfword,
    (decoded) => LoadAndStoreHalfWord(
      l: decoded[0],
      offset5: decoded[1],
      registerB: decoded[2],
      registerD: decoded[3],
    ),
  );

  /// `L` (1-bit).
  final int l;

  /// Offset (5-bits).
  final int offset5;

  /// Register `B` (3-bits).
  final int registerB;

  /// Register `D` (3-bits).
  final int registerD;

  /// Creates a [LoadAndStoreHalfWord] from the provided variables.
  ///
  /// > **NOTE**: Bits are **not** checked for correctness or size!
  LoadAndStoreHalfWord({
    @required this.l,
    @required this.offset5,
    @required this.registerB,
    @required this.registerD,
  })  : assert(l != null),
        assert(offset5 != null),
        assert(registerB != null),
        assert(registerD != null),
        super._(decoder._format);

  @override
  R accept<R, C>(ThumbSetVisitor<R, C> visitor, [C context]) {
    return visitor.visitLoadAndStoreHalfWord(this, context);
  }

  @override
  Map<String, Object> toJson() {
    return {
      'L': l,
      'Offset5': offset5,
      'Rb': registerB,
      'Rd': registerD,
    };
  }
}
