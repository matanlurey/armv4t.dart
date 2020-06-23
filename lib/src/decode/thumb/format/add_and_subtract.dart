part of '../format.dart';

/// Decoded object from [ThumbInstructionSet.$02$addAndSubtract].
class AddAndSubtract extends ThumbInstructionSet {
  static final decoder = ThumbInstructionSetDecoder._(
    ThumbInstructionSet.$02$addAndSubtract,
    (decoded) => AddAndSubtract(
      i: decoded[0],
      opcode: decoded[1],
      registerNOrOffset3: decoded[2],
      registerS: decoded[3],
      registerD: decoded[4],
    ),
  );

  /// OpCode (1-bit).
  final int opcode;

  /// `I` (1-bit).
  final int i;

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
    @required this.i,
    @required this.registerNOrOffset3,
    @required this.registerS,
    @required this.registerD,
  })  : assert(opcode != null),
        assert(registerNOrOffset3 != null),
        assert(registerS != null),
        assert(registerD != null),
        super._(decoder._format);

  @override
  R accept<R, C>(ThumbSetVisitor<R, C> visitor, [C context]) {
    return visitor.visitAddAndSubtract(this, context);
  }

  @override
  Map<String, Object> toJson() {
    return {
      'Op': opcode,
      'I': i,
      'Rn/Offset3': registerNOrOffset3,
      'Rs': registerS,
      'Rd': registerD,
    };
  }
}
