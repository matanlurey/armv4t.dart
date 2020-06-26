part of '../../instruction.dart';

/// Transfer Register contents to PSR.
abstract class MSR extends ArmInstruction {
  /// Destination `PSR` (`0` = `CPSR`, `1` = `SPSR_{currentMode}`).
  final int destinationPSR;

  const MSR._({
    @required int condition,
    @required this.destinationPSR,
  }) : super._(condition);

  @override
  R accept<R, C>(
    ArmInstructionVisitor<R, C> visitor, [
    C context,
  ]) =>
      throw UnimplementedError();
}

class MSR$SourceRegister extends MSR {
  /// Source register.
  final int sourceRegister;

  const MSR$SourceRegister({
    @required this.sourceRegister,
    @required int destinationPSR,
    @required int condition,
  }) : super._(
          destinationPSR: destinationPSR,
          condition: condition,
        );
}

class MSR$SourceRegisterOrImmediateValue extends MSR {
  /// `0` = [sourceOperand] is a _register_.
  final int immediateOperand;

  /// Source register _or_ immediate value.
  ///
  /// If [immediateOperand] is `0`, this value is a register:
  /// ```
  /// 0000 0000 MMMM
  ///           ^^^^
  ///           Source register.
  /// ```
  ///
  /// If [immediateOperand] is `1`, this value is an unsigned 8-bit immediate:
  /// ```
  ///      Unsigned 8-bit immediate value.
  ///      vvvv vvvv
  /// RRRR MMMM MMMM
  /// ^^^^
  /// Shift applied to M.
  /// ```
  final int sourceOperand;

  const MSR$SourceRegisterOrImmediateValue({
    @required this.immediateOperand,
    @required this.sourceOperand,
    @required int destinationPSR,
    @required int condition,
  }) : super._(
          destinationPSR: destinationPSR,
          condition: condition,
        );
}
