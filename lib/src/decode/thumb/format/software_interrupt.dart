part of '../format.dart';

/// Decoded object from [ThumbInstructionSet.$17$softwareInterrupt].
class SoftwareInterrupt extends ThumbInstructionSet {
  static final decoder = ThumbInstructionSetDecoder._(
    ThumbInstructionSet.$17$softwareInterrupt,
    (decoded) => SoftwareInterrupt(
      value8: decoded[0],
    ),
  );

  /// Value (8-bits).
  final int value8;

  /// Creates a [SoftwareInterrupt] from the provided variables.
  ///
  /// > **NOTE**: Bits are **not** checked for correctness or size!
  SoftwareInterrupt({
    @required this.value8,
  })  : assert(value8 != null),
        super._(decoder._format);

  @override
  R accept<R, C>(ThumbInstructionSetVisitor<R, C> visitor, [C context]) {
    return visitor.visitSoftwareInterrupt(this, context);
  }

  @override
  Map<String, Object> toJson() {
    return {
      'Value8': value8,
    };
  }
}
