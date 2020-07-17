part of '../../instruction.dart';

/// `MSR{cond} Psr{_field},Op`.
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
  /// Whether to disallow bits 31-24 (flags) to be changed as a result.
  final bool protectFlagBits;

  /// Whether to disallow bits 7-0 (control) to be changed as a result.
  final bool protectControlBits;

  /// Either the source register or an unsigend 8-bit shifted immediate.
  final Or2<RegisterAny, ShiftedImmediate<Uint8>> sourceOrImmediate;

  MSRArmInstruction({
    @required Condition condition,
    @required bool useSPSR,
    @required this.protectFlagBits,
    @required this.protectControlBits,
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
      protectFlagBits,
      protectControlBits,
      sourceOrImmediate,
    ];
  }
}
