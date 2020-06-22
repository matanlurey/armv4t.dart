part of '../format.dart';

/// Decoded object from [ThumbInstructionSet.$08$loadAndStoreSignExtended].
class LoadAndStoreSignExtendedByteAndHalfWord extends ThumbInstructionSet {
  static final decoder = ThumbInstructionSetDecoder._(
    ThumbInstructionSet.$08$loadAndStoreSignExtended,
    (decoded) => LoadAndStoreSignExtendedByteAndHalfWord(
      h: decoded[0],
      s: decoded[1],
      registerO: decoded[2],
      registerB: decoded[3],
      registerD: decoded[4],
    ),
  );

  /// `H` (1-bit).
  final int h;

  /// `S` (1-bit).
  final int s;

  /// Register `O` (3-bits).
  final int registerO;

  /// Register `B` (3-bits).
  final int registerB;

  /// Register `D` (3-bits).
  final int registerD;

  /// Creates a [LoadAndStoreSignExtendedByteAndHalfWord] from the provided variables.
  ///
  /// > **NOTE**: Bits are **not** checked for correctness or size!
  LoadAndStoreSignExtendedByteAndHalfWord({
    @required this.h,
    @required this.s,
    @required this.registerO,
    @required this.registerB,
    @required this.registerD,
  })  : assert(h != null),
        assert(s != null),
        assert(registerO != null),
        assert(registerB != null),
        assert(registerD != null),
        super._(decoder._format);

  @override
  R accept<R, C>(ThumbInstructionSetVisitor<R, C> visitor, [C context]) {
    return visitor.visitLoadAndStoreSignExtendedByteAndHalfWord(this, context);
  }

  @override
  Map<String, Object> toJson() {
    return {
      'H': h,
      'S': s,
      'Ro': registerO,
      'Rb': registerB,
      'Rd': registerD,
    };
  }
}
