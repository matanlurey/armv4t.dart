part of '../format.dart';

/// Decoded object from [ThumbInstructionSet.$01$moveShiftedRegister].
class MoveShiftedRegister extends ThumbInstructionSet {
  static final decoder = ThumbInstructionSetDecoder._(
    ThumbInstructionSet.$01$moveShiftedRegister,
    (decoded) => MoveShiftedRegister(
      opcode: decoded[0],
      offset: decoded[1],
      registerS: decoded[2],
      registerD: decoded[3],
    ),
  );

  /// OpCode (2-bits).
  final int opcode;

  /// Offset (5-bits).
  final int offset;

  /// Register `S` (3-bits).
  final int registerS;

  /// Register `D` (3-bits).
  final int registerD;

  /// Creates a [MoveShiftedRegister] from the provided variables.
  ///
  /// > **NOTE**: Bits are **not** checked for correctness or size!
  MoveShiftedRegister({
    @required this.opcode,
    @required this.offset,
    @required this.registerS,
    @required this.registerD,
  })  : assert(opcode != null),
        assert(offset != null),
        assert(registerS != null),
        assert(registerD != null),
        super._(decoder._format);

  @override
  R accept<R, C>(ThumbInstructionSetVisitor<R, C> visitor, [C context]) {
    return visitor.visitMoveShiftedRegister(this, context);
  }

  @override
  Map<String, Object> toJson() {
    return {
      'Op': opcode,
      'Offset5': offset,
      'Rs': registerS,
      'Rd': registerD,
    };
  }
}
