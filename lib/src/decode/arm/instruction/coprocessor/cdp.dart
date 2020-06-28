part of '../../instruction.dart';

/// Coprocessor Data Operation.
///
/// This instruction is only executed if the [condition] is true.
///
/// This class of instruction is used to tell a coprocessor to perform some
/// internal operation. No result is communicated back to the ARM processor,
/// and it will not wait for the operation to complete. The coprocessor could
/// contain a queue of such instructions awaiting execution, and their execution
/// can overlap other activity, allowing the coprocessor and ARM processor to
/// perform independent tasks in parallel.
class CDP extends ArmInstruction {
  final int coprocessorOpCode;
  final int coprocessorOperandRegister1;
  final int coprocessorDestinationRegister;
  final int coprocessorNumber;
  final int coprocessorInformation;
  final int coprocessorOperandRegister2;

  const CDP({
    @required int condition,
    @required this.coprocessorOpCode,
    @required this.coprocessorOperandRegister1,
    @required this.coprocessorDestinationRegister,
    @required this.coprocessorNumber,
    @required this.coprocessorInformation,
    @required this.coprocessorOperandRegister2,
  }) : super._(condition);

  @override
  R accept<R, C>(
    ArmInstructionVisitor<R, C> visitor, [
    C context,
  ]) =>
      visitor.visitCDP(this, context);
}
