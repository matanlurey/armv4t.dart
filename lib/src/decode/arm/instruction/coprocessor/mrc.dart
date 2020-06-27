part of '../../instruction.dart';

/// Move from coprocessor to ARM register (`L = 1`).
class MRC extends ArmInstruction {
  final int coprocessorOperationCode;
  final int coprocessorSourceRegister;
  final int destinationRegister;
  final int coprocessorNumber;
  final int coprocessorInformation;
  final int coprocessorOperandRegister;

  const MRC({
    @required int condition,
    @required this.coprocessorOperationCode,
    @required this.coprocessorSourceRegister,
    @required this.destinationRegister,
    @required this.coprocessorNumber,
    @required this.coprocessorInformation,
    @required this.coprocessorOperandRegister,
  }) : super._(condition);

  @override
  R accept<R, C>(
    ArmInstructionVisitor<R, C> visitor, [
    C context,
  ]) =>
      visitor.visitMRC(this, context);
}
