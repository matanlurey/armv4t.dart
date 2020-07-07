part of '../instruction.dart';

@immutable
@sealed
abstract class PsrTransferArmInstruction extends ArmInstruction {
  /// Whether to use the `SPSR_<current mode>` (`1`) otherwise the `CPSR` (`0`).
  final bool useSPSR;

  PsrTransferArmInstruction._({
    @required Condition condition,
    @required this.useSPSR,
  }) : super._(condition: condition);
}
