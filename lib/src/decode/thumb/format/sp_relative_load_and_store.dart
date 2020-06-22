part of '../format.dart';

/// Decoded object from [ThumbInstructionSet.$11$spRelativeLoadAndStore].
class SPRelativeLoadAndStore extends ThumbInstructionSet {
  static final decoder = ThumbInstructionSetDecoder._(
    ThumbInstructionSet.$11$spRelativeLoadAndStore,
    (decoded) => SPRelativeLoadAndStore(
      l: decoded[0],
      registerD: decoded[1],
      word8: decoded[2],
    ),
  );

  /// `L` (1-bit).
  final int l;

  /// Register `D` (3-bits).
  final int registerD;

  /// Word (8-bits).
  final int word8;

  /// Creates a [SPRelativeLoadAndStore] from the provided variables.
  ///
  /// > **NOTE**: Bits are **not** checked for correctness or size!
  SPRelativeLoadAndStore({
    @required this.l,
    @required this.registerD,
    @required this.word8,
  })  : assert(l != null),
        assert(registerD != null),
        assert(word8 != null),
        super._(decoder._format);

  @override
  R accept<R, C>(ThumbInstructionSetVisitor<R, C> visitor, [C context]) {
    return visitor.visitSPRelativeLoadAndStore(this, context);
  }

  @override
  Map<String, Object> toJson() {
    return {
      'L': l,
      'Rd': registerD,
      'Word8': word8,
    };
  }
}
