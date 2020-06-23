part of '../format.dart';

/// Decoded object from [ThumbInstructionSet.$04$aluOperation].
class ALUOperation extends ThumbInstructionSet {
  static final decoder = ThumbInstructionSetDecoder._(
    ThumbInstructionSet.$04$aluOperation,
    (decoded) => ALUOperation(
      opcode: decoded[0],
      registerS: decoded[1],
      registerD: decoded[2],
    ),
  );

  /// OpCode (4-bits).
  final int opcode;

  /// Register `S` (3-bits).
  final int registerS;

  /// Register `D` (3-bits).
  final int registerD;

  /// Creates a [ALUOperation] from the provided variables.
  ///
  /// > **NOTE**: Bits are **not** checked for correctness or size!
  ALUOperation({
    @required this.opcode,
    @required this.registerS,
    @required this.registerD,
  })  : assert(opcode != null),
        assert(registerS != null),
        assert(registerD != null),
        super._(decoder._format);

  @override
  R accept<R, C>(ThumbSetVisitor<R, C> visitor, [C context]) {
    return visitor.visitALUOperation(this, context);
  }

  @override
  Map<String, Object> toJson() {
    return {
      'Op': opcode,
      'Rs': registerS,
      'Rd': registerD,
    };
  }
}
