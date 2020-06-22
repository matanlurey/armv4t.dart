part of '../format.dart';

/// Decoded object from [ThumbInstructionSet.$15$multipleLoadAndStore].
class MultipleLoadAndStore extends ThumbInstructionSet {
  static final decoder = ThumbInstructionSetDecoder._(
    ThumbInstructionSet.$15$multipleLoadAndStore,
    (decoded) => MultipleLoadAndStore(
      l: decoded[0],
      registerB: decoded[1],
      registerList: decoded[2],
    ),
  );

  /// `L` (1-bit).
  final int l;

  /// Register `B` (3-bits).
  final int registerB;

  /// Register list (8-bits).
  final int registerList;

  /// Creates a [MultipleLoadAndStore] from the provided variables.
  ///
  /// > **NOTE**: Bits are **not** checked for correctness or size!
  MultipleLoadAndStore({
    @required this.l,
    @required this.registerB,
    @required this.registerList,
  })  : assert(l != null),
        assert(registerB != null),
        assert(registerList != null),
        super._(decoder._format);

  @override
  R accept<R, C>(ThumbInstructionSetVisitor<R, C> visitor, [C context]) {
    return visitor.visitMultipleLoadAndStore(this, context);
  }

  @override
  Map<String, Object> toJson() {
    return {
      'L': l,
      'Rb': registerB,
      'Rlist': registerList,
    };
  }
}
