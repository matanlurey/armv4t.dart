part of '../../instruction.dart';

/// `LDM{cond}{amod} Rn{!}, <Rlist>{^}`.
///
/// ## Execution
///
/// Load Multiple.
///
/// ## Cycles
///
/// `nS+1N+1I+y`.
class LDM extends BlockDataTransfer {
  LDM({
    @required Condition condition,
    @required bool addOffsetBeforeTransfer,
    @required bool addOffsetToBase,
    @required bool writeAddressIntoBase,
    @required RegisterAny base,
    @required BlockDataAddressingMode addressingMode,
    @required RegisterList registerList,
  }) : super._(
          condition: condition,
          addOffsetBeforeTransfer: addOffsetBeforeTransfer,
          addOffsetToBase: addOffsetToBase,
          writeAddressIntoBase: writeAddressIntoBase,
          base: base,
          addressingMode: addressingMode,
          registerList: registerList,
        );
}
