part of '../format.dart';

/// Decoded object from [ThumbInstructionSet.$14$pushAndPopRegisters].
class PushAndPopRegisters extends ThumbInstructionSet {
  static final decoder = ThumbInstructionSetDecoder._(
    ThumbInstructionSet.$14$pushAndPopRegisters,
    (decoded) => PushAndPopRegisters(
      l: decoded[0],
      r: decoded[1],
      registerList: decoded[2],
    ),
  );

  /// `L` (1-bit).
  final int l;

  /// `R` (1-bit).
  final int r;

  /// Register list (8-bits).
  final int registerList;

  /// Creates a [PushAndPopRegisters] from the provided variables.
  ///
  /// > **NOTE**: Bits are **not** checked for correctness or size!
  PushAndPopRegisters({
    @required this.l,
    @required this.r,
    @required this.registerList,
  })  : assert(l != null),
        assert(r != null),
        assert(registerList != null),
        super._(decoder._format);

  @override
  R accept<R, C>(ThumbSetVisitor<R, C> visitor, [C context]) {
    return visitor.visitPushAndPopRegisters(this, context);
  }

  @override
  Map<String, Object> toJson() {
    return {
      'L': l,
      'R': r,
      'Rlist': registerList,
    };
  }
}
