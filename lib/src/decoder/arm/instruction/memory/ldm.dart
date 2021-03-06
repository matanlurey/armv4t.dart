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
class LDMArmInstruction extends BlockDataTransferArmInstruction {
  LDMArmInstruction({
    @required Condition condition,
    @required bool addOffsetBeforeTransfer,
    @required bool addOffsetToBase,
    @required bool writeAddressIntoBase,
    @required bool loadPsr,
    @required RegisterAny base,
    @required RegisterList<RegisterAny> registerList,
  }) : super._(
          condition: condition,
          addOffsetBeforeTransfer: addOffsetBeforeTransfer,
          addOffsetToBase: addOffsetToBase,
          writeAddressIntoBase: writeAddressIntoBase,
          loadPsrOrForceUserMode: loadPsr,
          base: base,
          registerList: registerList,
        );

  @override
  R accept<R, C>(ArmInstructionVisitor<R, C> visitor, [C context]) {
    return visitor.visitLDM(this, context);
  }
}
