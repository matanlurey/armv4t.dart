part of '../../instruction.dart';

/// Move.
///
/// [MOV] performs a move to a regsiter from another register or immediate
/// value. If the [s]-bit is set and the destination is R15 (the program counter
/// - `PC`), the `SPSR` is also copied to the `CPSR`.
///
/// ## Syntax
/// `MOV{<cond>}{S} <Rd>, <shifter_operand>`
///
/// ## RTL
/// ```
/// if (cond)
///   Rd <- shifter_operand
///   if (S == 1 and Rd == 15)
///     CPSR <- SPSR
/// ```
///
/// ## Flags updated if [s] is used and [destinationRegister] is not `R15`:
/// `N`, `Z`, `C`
class MOV extends ArmInstruction {
  /// Whether [shifterOperand] is an immediate value (not a register).
  final int i;

  /// Whether to set flags on the CPSR.
  final int s;

  /// `Rd`.
  final int destinationRegister;

  /// 12-bit.
  final int shifterOperand;

  const MOV({
    @required int condition,
    @required this.i,
    @required this.s,
    @required this.destinationRegister,
    @required this.shifterOperand,
  }) : super._(condition);

  @override
  R accept<R, C>(
    ArmInstructionVisitor<R, C> visitor, [
    C context,
  ]) =>
      throw UnimplementedError();
}
