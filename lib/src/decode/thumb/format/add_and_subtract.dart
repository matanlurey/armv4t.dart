part of '../format.dart';

/// Decoded object from [ThumbInstructionSet.$02$addAndSubtract].
class AddAndSubtract extends ThumbInstructionSet {
  static final decoder = ThumbInstructionSetDecoder._(
    ThumbInstructionSet.$02$addAndSubtract,
    (decoded) => AddAndSubtract(
      opcode: decoded[0],
      registerNOrOffset3: decoded[1],
      registerS: decoded[2],
      registerD: decoded[3],
    ),
  );

  /// OpCode (2-bits).
  final int opcode;

  /// Register `N` or Offset (3-bits).
  final int registerNOrOffset3;

  /// Register `S`.
  final int registerS;

  /// Register `D`.
  final int registerD;

  /// Creates a [AddAndSubtract] from the provided variables.
  ///
  /// > **NOTE**: Bits are **not** checked for correctness or size!
  AddAndSubtract({
    @required this.opcode,
    @required this.registerNOrOffset3,
    @required this.registerS,
    @required this.registerD,
  })  : assert(opcode != null),
        assert(registerNOrOffset3 != null),
        assert(registerS != null),
        assert(registerD != null),
        super._(decoder._format);

  @override
  R accept<R, C>(ThumbInstructionSetVisitor<R, C> visitor, [C context]) {
    return visitor.visitAddAndSubtract(this, context);
  }

  @override
  Map<String, Object> toJson() {
    return {
      'Op': opcode,
      'Rn/Offset3': registerNOrOffset3,
      'Rs': registerS,
      'Rd': registerD,
    };
  }
}
