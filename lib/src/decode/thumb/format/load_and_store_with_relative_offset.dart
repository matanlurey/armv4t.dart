part of '../format.dart';

/// Decoded object from [ThumbInstructionSet.$07$loadAndStoreWithRelativeOffset].
class LoadAndStoreWithRelativeOffset extends ThumbInstructionSet {
  static final decoder = ThumbInstructionSetDecoder._(
    ThumbInstructionSet.$07$loadAndStoreWithRelativeOffset,
    (decoded) => LoadAndStoreWithRelativeOffset(
      l: decoded[0],
      b: decoded[1],
      registerO: decoded[2],
      registerB: decoded[3],
      registerD: decoded[4],
    ),
  );

  /// `L` (1-bit).
  final int l;

  /// `B` (1-bit).
  final int b;

  /// Register `O` (3-bits).
  final int registerO;

  /// Register `B` (3-bits).
  final int registerB;

  /// Register `D` (3-bits).
  final int registerD;

  /// Creates a [LoadAndStoreWithRelativeOffset] from the provided variables.
  ///
  /// > **NOTE**: Bits are **not** checked for correctness or size!
  LoadAndStoreWithRelativeOffset({
    @required this.l,
    @required this.b,
    @required this.registerO,
    @required this.registerB,
    @required this.registerD,
  })  : assert(l != null),
        assert(b != null),
        assert(registerO != null),
        assert(registerB != null),
        assert(registerD != null),
        super._(decoder._format);

  @override
  R accept<R, C>(ThumbSetVisitor<R, C> visitor, [C context]) {
    return visitor.visitLoadAndStoreWithRelativeOffset(this, context);
  }

  @override
  Map<String, Object> toJson() {
    return {
      'l': l,
      'b': b,
      'Ro': registerO,
      'Rb': registerB,
      'Rd': registerD,
    };
  }
}
