part of '../../instruction.dart';

/// Branch and Exchange.
///
/// This instruction only executes if the [condition] is true.
///
/// This instruction performs a branch by copying the contents of a general
/// register ([operandRegister]), into the program counter (`PC`). The branch
/// causes a pipeline flush and refill from the address specified by
/// [operandRegister]. This instruction also permits the instruction set to be
/// exchanged. When the instruction is executed, the value of
/// `operandRegister[0]` determines whether the instruction stream will be
/// decoded as `ARM` or `THUMB` instructions.
class BX extends ArmInstruction {
  /// Operand register.
  ///
  /// If bit `0` is `1`, subsequent instructions are decoded as `THUMB`.
  /// If bit `0` is `0`, subsequent instructions are decoded as `ARM`.
  final int operandRegister;

  const BX({
    @required int condition,
    @required this.operandRegister,
  }) : super._(condition);

  @override
  R accept<R, C>(
    ArmInstructionVisitor<R, C> visitor, [
    C context,
  ]) =>
      throw UnimplementedError();
}
