part of '../format.dart';

/// Decoded object from [ThumbInstructionSet.$06$pcRelativeLoad].
class PCRelativeLoad extends ThumbInstructionSet {
  static final decoder = ThumbInstructionSetDecoder._(
    ThumbInstructionSet.$06$pcRelativeLoad,
    (decoded) => PCRelativeLoad(
      registerD: decoded[0],
      word8: decoded[1],
    ),
  );

  /// Register `D` (3-bits).
  final int registerD;

  /// Word (8-bits).
  final int word8;

  /// Creates a [PCRelativeLoad] from the provided variables.
  ///
  /// > **NOTE**: Bits are **not** checked for correctness or size!
  PCRelativeLoad({
    @required this.registerD,
    @required this.word8,
  })  : assert(registerD != null),
        assert(word8 != null),
        super._(decoder._format);

  @override
  R accept<R, C>(ThumbSetVisitor<R, C> visitor, [C context]) {
    return visitor.visitPCRelativeLoad(this, context);
  }

  @override
  Map<String, Object> toJson() {
    return {
      'Rd': registerD,
      'Word8': word8,
    };
  }
}
