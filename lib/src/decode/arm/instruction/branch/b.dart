part of '../../instruction.dart';

/// Branch.
///
/// The B/BL instructions are used to branch to a [targetAddress], based on an
/// optional [condition].
///
/// ## Syntax
/// `B{<cond>} <target_address>`
///
/// ## RTL
/// ```
/// if (cond)
///   PC <- PC + (signed_immediate_24 << 2)
/// ```
class B extends ArmInstruction {
  final int targetAddress;

  const B({
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
