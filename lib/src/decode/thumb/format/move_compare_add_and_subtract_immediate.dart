part of '../format.dart';

/// Decoded object from [ThumbInstructionSet.$03$moveCompareAddAndSubtractImmediate].
class MoveCompareAddAndSubtractImmediate extends ThumbInstructionSet {
  static final decoder = ThumbInstructionSetDecoder._(
    ThumbInstructionSet.$03$moveCompareAddAndSubtractImmediate,
    (decoded) => MoveCompareAddAndSubtractImmediate(
      opcode: decoded[0],
      registerD: decoded[1],
      offset: decoded[2],
    ),
  );

  /// OpCode (2-bits).
  final int opcode;

  /// Register `D` (3-bits).
  final int registerD;

  /// Offset (8-bits).
  final int offset;

  /// Creates a [MoveCompareAddAndSubtractImmediate] from the provided variables.
  ///
  /// > **NOTE**: Bits are **not** checked for correctness or size!
  MoveCompareAddAndSubtractImmediate({
    @required this.opcode,
    @required this.registerD,
    @required this.offset,
  })  : assert(opcode != null),
        assert(offset != null),
        assert(registerD != null),
        super._(decoder._format);

  @override
  R accept<R, C>(ThumbSetVisitor<R, C> visitor, [C context]) {
    return visitor.visitMoveCompareAddAndSubtractImmediate(this, context);
  }

  @override
  Map<String, Object> toJson() {
    return {
      'Op': opcode,
      'Rd': registerD,
      'Offset8': offset,
    };
  }
}
