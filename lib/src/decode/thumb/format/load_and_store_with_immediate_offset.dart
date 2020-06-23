part of '../format.dart';

/// Decoded object from [ThumbInstructionSet.$09$loadAndStoreWithImmediateOffset].
class LoadAndStoreWithImmediateOffset extends ThumbInstructionSet {
  static final decoder = ThumbInstructionSetDecoder._(
    ThumbInstructionSet.$09$loadAndStoreWithImmediateOffset,
    (decoded) => LoadAndStoreWithImmediateOffset(
      b: decoded[0],
      l: decoded[1],
      offset5: decoded[2],
      registerB: decoded[3],
      registerD: decoded[4],
    ),
  );

  /// `B` (1-bit).
  final int b;

  /// `L` (1-bit).
  final int l;

  /// Offset (5-bits).
  final int offset5;

  /// Register `B` (3-bits).
  final int registerB;

  /// Register `D` (3-bits).
  final int registerD;

  /// Creates a [LoadAndStoreWithImmediateOffset] from the provided variables.
  ///
  /// > **NOTE**: Bits are **not** checked for correctness or size!
  LoadAndStoreWithImmediateOffset({
    @required this.b,
    @required this.l,
    @required this.offset5,
    @required this.registerB,
    @required this.registerD,
  })  : assert(b != null),
        assert(l != null),
        assert(offset5 != null),
        assert(registerB != null),
        assert(registerD != null),
        super._(decoder._format);

  @override
  R accept<R, C>(ThumbSetVisitor<R, C> visitor, [C context]) {
    return visitor.visitLoadAndStoreWithImmediateOffset(this, context);
  }

  @override
  Map<String, Object> toJson() {
    return {
      'B': b,
      'L': l,
      'Offset5': offset5,
      'Rb': registerB,
      'Rd': registerD,
    };
  }
}
