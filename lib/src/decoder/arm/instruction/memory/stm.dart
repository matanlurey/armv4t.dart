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
class STM extends BlockDataTransfer {
  STM({
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

  @override
  R accept<R, C>(ArmInstructionVisitor<R, C> visitor, [C context]) {
    return visitor.visitSTM(this, context);
  }
}
