part of '../../instruction.dart';

/// Single Data Transfer (`LDR`, `STR`) instruction.
///
/// This instruction is only executed if the [condition] is true.
abstract class LDR$STR extends ArmInstruction {
  /// Whether [offset] is an _immediate_ value (`0`) or not (`1`).
  final int i;

  /// Pre/Post indexing bit.
  final int p;

  /// Up/Down bit.
  final int u;

  /// Byte/Word bit.
  final int b;

  /// Write-back bit.
  final int w;

  /// `Rn`.
  final int baseRegister;

  /// `Rd`.
  final int sourceOrDestinationRegister;

  /// Either an unsigned 12-bit immediate offset or an offset register.
  ///
  /// - If [i] is `0`, an unsigned 12-bit immediate offset.
  /// - If [i] is `1`:
  ///
  /// ```
  ///           Offset register.
  ///           vvvv
  /// SSSS SSSS MMMM
  /// ^^^^ ^^^^
  /// Shift applied to M.
  /// ```
  final int offset;

  const LDR$STR._({
    @required int condition,
    @required this.i,
    @required this.p,
    @required this.u,
    @required this.b,
    @required this.w,
    @required this.baseRegister,
    @required this.sourceOrDestinationRegister,
    @required this.offset,
  }) : super._(condition);

  @override
  R accept<R, C>(
    ArmInstructionVisitor<R, C> visitor, [
    C context,
  ]) =>
      throw UnimplementedError();
}

/// A sub-type of [LDR$STR] specifically for instruction `LDR`.
class LDR extends LDR$STR {
  const LDR({
    @required int condition,
    @required int i,
    @required int p,
    @required int u,
    @required int b,
    @required int w,
    @required int baseRegister,
    @required int sourceOrDestinationRegister,
    @required int offset,
  }) : super._(
          condition: condition,
          i: i,
          p: p,
          u: u,
          b: b,
          w: w,
          baseRegister: baseRegister,
          sourceOrDestinationRegister: sourceOrDestinationRegister,
          offset: offset,
        );
}
