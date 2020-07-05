part of '../../instruction.dart';

/// `STM{cond}{amod} Rn{!}, <Rlist>{^}`.
///
/// ## Execution
///
/// Store Multiple.
///
/// ## Cycles
///
/// `(n-1)S+2N`.
class STM extends BlockDataTransferArmInstruction {
  STM({
    @required Condition condition,
    @required bool addOffsetBeforeTransfer,
    @required bool addOffsetToBase,
    @required bool writeAddressIntoBase,
    @required bool loadPsrOrForceUserMode,
    @required RegisterAny base,
    @required RegisterList<RegisterAny> registerList,
  }) : super._(
          condition: condition,
          addOffsetBeforeTransfer: addOffsetBeforeTransfer,
          addOffsetToBase: addOffsetToBase,
          writeAddressIntoBase: writeAddressIntoBase,
          loadPsrOrForceUserMode: loadPsrOrForceUserMode,
          base: base,
          registerList: registerList,
        );

  @override
  R accept<R, C>(ArmInstructionVisitor<R, C> visitor, [C context]) {
    return visitor.visitSTM(this, context);
  }
}
