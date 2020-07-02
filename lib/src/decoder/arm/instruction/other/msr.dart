part of '../../instruction.dart';

@immutable
@sealed
class MSR extends PsrTransfer {
  /// `F`: Write to flags field (aka `_flg`).
  final bool writeToFlagsField;

  /// `S`: Write to status field (reserved, don't change).
  final bool writeToStatusField;

  /// `X`: Write to extension field (reserved, don't change).
  final bool writeToExtensionField;

  /// `C`: Write to control field (aka `_ctl`).
  final bool writeToControlField;

  /// Either the source register or an unsigend 8-bit shifted immediate.
  final Or2<RegisterAny, ShiftedImmediate<Uint8>> sourceOrImmediate;

  MSR._({
    @required Condition condition,
    @required bool useSPSR,
    @required this.writeToFlagsField,
    @required this.writeToStatusField,
    @required this.writeToExtensionField,
    @required this.writeToControlField,
    @required this.sourceOrImmediate,
  }) : super._(
          condition: condition,
          useSPSR: useSPSR,
        );
}
