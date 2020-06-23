part of '../format.dart';

/// Decoded object from [ThumbInstructionSet.$19$longBranchWithLink].
class LongBranchWithLink extends ThumbInstructionSet {
  static final decoder = ThumbInstructionSetDecoder._(
    ThumbInstructionSet.$19$longBranchWithLink,
    (decoded) => LongBranchWithLink(
      h: decoded[0],
      offset: decoded[1],
    ),
  );

  /// `H` (1-bit).
  final int h;

  /// Offset (11-bits).
  final int offset;

  /// Creates a [LongBranchWithLink] from the provided variables.
  ///
  /// > **NOTE**: Bits are **not** checked for correctness or size!
  LongBranchWithLink({
    @required this.h,
    @required this.offset,
  })  : assert(h != null),
        assert(offset != null),
        super._(decoder._format);

  @override
  R accept<R, C>(ThumbSetVisitor<R, C> visitor, [C context]) {
    return visitor.visitLongBranchWithLink(this, context);
  }

  @override
  Map<String, Object> toJson() {
    return {
      'H': h,
      'Offset': offset,
    };
  }
}
