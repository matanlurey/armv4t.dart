part of '../format.dart';

/// Decoded object from [ThumbInstructionSet.$16$conditionalBranch].
class ConditionalBranch extends ThumbInstructionSet {
  static final decoder = ThumbInstructionSetDecoder._(
    ThumbInstructionSet.$16$conditionalBranch,
    (decoded) => ConditionalBranch(
      condition: decoded[0],
      softSet8: decoded[1],
    ),
  );

  /// Condition (4-bits).
  final int condition;

  /// Softset (8-bits).
  final int softSet8;

  /// Creates a [ConditionalBranch] from the provided variables.
  ///
  /// > **NOTE**: Bits are **not** checked for correctness or size!
  ConditionalBranch({
    @required this.condition,
    @required this.softSet8,
  })  : assert(condition != null),
        assert(softSet8 != null),
        super._(decoder._format);

  @override
  R accept<R, C>(ThumbInstructionSetVisitor<R, C> visitor, [C context]) {
    return visitor.visitConditionalBranch(this, context);
  }

  @override
  Map<String, Object> toJson() {
    return {
      'Cond': condition,
      'Softset8': softSet8,
    };
  }
}
