part of '../../instruction.dart';

/// Branch.
///
/// The [BX] instruction is used to branch to a [targetAddress] stored in a
/// register, based on an optional [condition]. If bit `0` of the register is
/// set to `1`, then the processor will switch to `THUMB` execution (bit `0` is
/// forced to `0` in before the branch address is stored in the program counter
/// - `PC`).
///
/// ## Syntax
/// `B{<cond>} <target_address>`
///
/// ## RTL
/// ```
/// if (cond)
///   T flag <- Rm[0]
///   PC <- Rm & 0xFFFFFFFE
/// ```
class BX extends ArmInstruction {
  final int targetAddress;

  const BX({
    @required int condition,
    @required this.targetAddress,
  }) : super._(condition);

  @override
  R accept<R, C>(
    ArmInstructionVisitor<R, C> visitor, [
    C context,
  ]) =>
      throw UnimplementedError();
}
