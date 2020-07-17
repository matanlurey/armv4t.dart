part of '../../instruction.dart';

/// `MSR{cond} Psr{_field},Op`.
///
/// ## Restrictions
///
/// - In _user_ mode, the control bits of the `CPSR` are protected from change,
///   so only the condition code bits of the `CPSR` can be changed. In other
///   ("privileged") modes the entire `CPSR` can be changed.
///
///   > NOTE: Software must never change the state of `T` bit of the `CPSR`.
///
/// - The `SPSR` register which is accessed depend on the mode at the time,
///   i.e. only `SPSR_fiq` is accessible when the processir is in `FIQ` mode.
///
/// - Do not attempt to access [useSPSR] in user mode.
///
/// ## Execution
///
/// `Psr[field] = Op`
///
/// ## Flags
///
/// `(PSR)`
///
/// ## Cycles
///
/// `1S`.
@immutable
@sealed
class MSRArmInstruction extends PsrTransferArmInstruction {
  /// Whether to allow bits 31-24 (flags) to be changed as a result.
  final bool allowChangingFlags;

  /// Whether to allow bits 7-0 (control) to be changed as a result.
  final bool allowChangingControls;

  /// Either the source register or an unsigend 8-bit shifted immediate.
  final Or2<RegisterNotPC, ShiftedImmediate<Uint8>> sourceOrImmediate;

  MSRArmInstruction({
    @required Condition condition,
    @required bool useSPSR,
    @required this.allowChangingFlags,
    @required this.allowChangingControls,
    @required this.sourceOrImmediate,
  }) : super._(
          condition: condition,
          useSPSR: useSPSR,
        );

  @override
  R accept<R, C>(ArmInstructionVisitor<R, C> visitor, [C context]) {
    return visitor.visitMSR(this, context);
  }

  @override
  List<Object> _values() {
    return [
      condition,
      useSPSR,
      allowChangingFlags,
      allowChangingControls,
      sourceOrImmediate,
    ];
  }
}
