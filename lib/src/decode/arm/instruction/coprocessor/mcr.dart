part of '../../instruction.dart';

/// Move from ARM register to coprocessor register (`L = 0`).
class MCR extends ArmInstruction {
  final int coprocessorOperationCode;
  final int coprocessorDestinationRegister;
  final int sourceRegister;
  final int coprocessorNumber;
  final int coprocessorInformation;
  final int coprocessorOperandRegister;

  const MCR({
    @required int condition,
    @required this.coprocessorOperationCode,
    @required this.coprocessorDestinationRegister,
    @required this.sourceRegister,
    @required this.coprocessorNumber,
    @required this.coprocessorInformation,
    @required this.coprocessorOperandRegister,
  }) : super._(condition);

  @override
  R accept<R, C>(
    ArmInstructionVisitor<R, C> visitor, [
    C context,
  ]) =>
      visitor.visitMCR(this, context);
}
