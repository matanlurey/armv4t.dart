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
  /// Which field, if any, to write to - may be `null`.
  final MSRWriteField writeToField;

  /// Either the source register or an unsigend 8-bit shifted immediate.
  final Or2<RegisterAny, ShiftedImmediate<Uint8>> sourceOrImmediate;

  MSRArmInstruction({
    @required Condition condition,
    @required bool useSPSR,
    @required this.writeToField,
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
      writeToField,
      sourceOrImmediate,
    ];
  }
}

enum MSRWriteField {
  /// Bit 19: `F` (bits 31-24, aka `_flg`).
  flag,

  /// Bit 18: `S`` (bits 23-16, reserved, do not change).
  status,

  /// Bit 17: `X` (bits 15-8, reserved, do not change).
  extension,

  /// Bit 16: `C` (bits 7-0, aka `_ctl`)
  control,
}
