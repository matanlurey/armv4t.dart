part of '../format.dart';

/// Decoded object from [ThumbInstructionSet.$13$addOffsetToStackPointer].
class AddOffsetToStackPointer extends ThumbInstructionSet {
  static final decoder = ThumbInstructionSetDecoder._(
    ThumbInstructionSet.$13$addOffsetToStackPointer,
    (decoded) => AddOffsetToStackPointer(
      s: decoded[0],
      sWord7: decoded[1],
    ),
  );

  /// `S` (1-bit).
  final int s;

  /// S-Word (7-bits).
  final int sWord7;

  /// Creates a [AddOffsetToStackPointer] from the provided variables.
  ///
  /// > **NOTE**: Bits are **not** checked for correctness or size!
  AddOffsetToStackPointer({
    @required this.s,
    @required this.sWord7,
  })  : assert(s != null),
        assert(sWord7 != null),
        super._(decoder._format);

  @override
  R accept<R, C>(ThumbInstructionSetVisitor<R, C> visitor, [C context]) {
    return visitor.visitAddOffsetToStackPointer(this, context);
  }

  @override
  Map<String, Object> toJson() {
    return {
      'S': s,
      'SWord7': sWord7,
    };
  }
}
