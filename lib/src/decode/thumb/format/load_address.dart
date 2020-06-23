part of '../format.dart';

/// Decoded object from [ThumbInstructionSet.$12$loadAddress].
class LoadAddress extends ThumbInstructionSet {
  static final decoder = ThumbInstructionSetDecoder._(
    ThumbInstructionSet.$12$loadAddress,
    (decoded) => LoadAddress(
      sp: decoded[0],
      registerD: decoded[1],
      word8: decoded[2],
    ),
  );

  /// `SP` (1-bit).
  final int sp;

  /// Register `D` (3-bits).
  final int registerD;

  /// Word (8-bits).
  final int word8;

  /// Creates a [LoadAddress] from the provided variables.
  ///
  /// > **NOTE**: Bits are **not** checked for correctness or size!
  LoadAddress({
    @required this.sp,
    @required this.registerD,
    @required this.word8,
  })  : assert(sp != null),
        assert(registerD != null),
        assert(word8 != null),
        super._(decoder._format);

  @override
  R accept<R, C>(ThumbSetVisitor<R, C> visitor, [C context]) {
    return visitor.visitLoadAddress(this, context);
  }

  @override
  Map<String, Object> toJson() {
    return {
      'SP': sp,
      'Rd': registerD,
      'Word8': word8,
    };
  }
}
