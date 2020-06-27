part of '../../instruction.dart';

/// Load a subset of a coprocessor's registers directly to memory.
///
/// This instruction is only executed if the [condition] is true.
class LDC extends ArmInstruction {
  final int p;
  final int u;
  final int n;
  final int w;
  final int baseRegister;
  final int coprocessorSourceOrDestinationRegister;
  final int coprocessorNumber;
  final int unsigned8BitImmediateOffset;

  const LDC({
    @required int condition,
    @required this.p,
    @required this.u,
    @required this.n,
    @required this.w,
    @required this.baseRegister,
    @required this.coprocessorSourceOrDestinationRegister,
    @required this.coprocessorNumber,
    @required this.unsigned8BitImmediateOffset,
  }) : super._(condition);

  @override
  R accept<R, C>(
    ArmInstructionVisitor<R, C> visitor, [
    C context,
  ]) =>
      visitor.visitLDC(this, context);
}
