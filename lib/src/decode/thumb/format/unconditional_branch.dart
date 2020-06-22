part of '../format.dart';

/// Decoded object from [ThumbInstructionSet.$18$unconditionalBranch].
class UnconditionalBranch extends ThumbInstructionSet {
  static final decoder = ThumbInstructionSetDecoder._(
    ThumbInstructionSet.$18$unconditionalBranch,
    (decoded) => UnconditionalBranch(
      offset11: decoded[0],
    ),
  );

  /// Offset (11-bits).
  final int offset11;

  /// Creates a [UnconditionalBranch] from the provided variables.
  ///
  /// > **NOTE**: Bits are **not** checked for correctness or size!
  UnconditionalBranch({
    @required this.offset11,
  })  : assert(offset11 != null),
        super._(decoder._format);

  @override
  R accept<R, C>(ThumbInstructionSetVisitor<R, C> visitor, [C context]) {
    return visitor.visitUnconditionalBranch(this, context);
  }

  @override
  Map<String, Object> toJson() {
    return {
      'Offset11': offset11,
    };
  }
}
