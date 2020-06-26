part of '../../instruction.dart';

/// Subtract with Carry.
///
/// The [SBC] instruction is used to implement efficient multiword subtraction.
/// For example if 64-bit numbers are stored in `R1:0` and `R3:2`, their
/// difference can be stored in `R5:4` as shown below:
/// ```
/// SUBS   R4, R2, R0      ; subtract least significant words
/// SUB    R5, R3, R1      ; subtract most significant words minus borrow
/// ```
///
/// ## Syntax
/// `SBC{<cond>}{S} <Rd>, <Rn>, <shifter_operand>`
///
/// ## RTL
/// ```
/// if (cond)
///   Rd <- Rn - shifter_operand - NOT C
/// ```
///
/// ## Flags updated if [s] is used:
/// `N`, `Z`, `V`, `C`
///
/// > NOTE: The carry flag (`C`) is the complement of the borrow flag. If a
/// > borrow is required by the operation, `C` will be set to `0`.
class SBC extends ArmInstruction {
  /// Whether to set flags on the CPSR.
  final int s;

  /// `Rn`.
  final int sourceRegister;

  /// `Rd`.
  final int destinationRegister;

  /// 12-bit.
  final int shifterOperand;

  const SBC({
    @required int condition,
    @required this.s,
    @required this.sourceRegister,
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
