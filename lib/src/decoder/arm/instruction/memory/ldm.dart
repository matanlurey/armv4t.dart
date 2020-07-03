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
class LDM extends BlockDataTransferArmInstruction {
  LDM({
    @required Condition condition,
    @required bool addOffsetBeforeTransfer,
    @required bool addOffsetToBase,
    @required bool writeAddressIntoBase,
    @required RegisterAny base,
    @required RegisterList<RegisterAny> registerList,
  }) : super._(
          condition: condition,
          addOffsetBeforeTransfer: addOffsetBeforeTransfer,
          addOffsetToBase: addOffsetToBase,
          writeAddressIntoBase: writeAddressIntoBase,
          base: base,
          registerList: registerList,
        );

  @override
  R accept<R, C>(ArmInstructionVisitor<R, C> visitor, [C context]) {
    return visitor.visitLDM(this, context);
  }
}
