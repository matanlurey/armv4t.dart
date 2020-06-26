part of '../../instruction.dart';

/// Branch or Branch with Link.
///
/// This instruction only executes if the [condition] is true.
///
/// Branch instructions contain a signed 2's complement 24-bit offset. This is
/// shifted left 2-bits, sign extended to 32-bits, and added to the program
/// counter (`PC`). The instruction can therefore specify a branch of +/-
/// 32Mbytes. The branch offset must take account of the prefetch operation,
/// which causes the program counter (`PC`) to be 2 words (8 bytes) ahead of the
/// current instruction.
///
/// Branches beyond +/- 32Mbytes must use an offset or absolute destination
/// which has been previously loaded into a register. In this case, the program
/// counter (`PC`) must be manually saved in `R14` is a _Branch with Link_-type
/// operation is required.
abstract class B$BL extends ArmInstruction {
  /// 24-bit offset.
  final int offset;

  const B$BL._({
    @required int condition,
    @required this.offset,
  }) : super._(condition);

  @override
  R accept<R, C>(
    ArmInstructionVisitor<R, C> visitor, [
    C context,
  ]) =>
      throw UnimplementedError();
}

/// A sub-type of the [B$BL] instruction specifically for `B`.
class B extends B$BL {
  const B({
    @required int condition,
    @required int offset,
  }) : super._(
          condition: condition,
          offset: offset,
        );
}
