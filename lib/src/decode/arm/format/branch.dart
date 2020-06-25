part of '../format.dart';

/// Decoded object from [ArmInstructionSet.$11$branch].
class Branch extends ArmInstructionSet {
  static final decoder = ArmInstructionSetDecoder._(
    ArmInstructionSet.$11$branch,
    (decoded) => Branch(
      condition: decoded[0],
      l: decoded[1],
      offset: decoded[2],
    ),
  );

  /// Link bit (`0` = Branch, `1` = Branch with Link).
  final int l;

  /// 24-bit offset.
  final int offset;

  /// Creates a [Branch] from the provided variables.
  ///
  /// > **NOTE**: Bits are **not** checked for correctness or size!
  Branch({
    @required int condition,
    @required this.l,
    @required this.offset,
  }) : super._(condition, decoder._format);

  @override
  R accept<R, C>(ArmSetVisitor<R, C> visitor, [C context]) {
    throw UnimplementedError();
  }

  @override
  Map<String, Object> toJson() {
    return {
      'Cond': condition,
      'L': l,
      'Offset': offset,
    };
  }
}
