part of '../../instruction.dart';

/// `STR{cond}{B}{T} Rd,<Address>`.
///
/// ## Execution
///
/// `[Rn +/- <Offst>] = Rd`
///
/// ## Cycles
///
/// `2N`.
class STRArmInstruction extends SingleDataTransferArmInstruction {
  STRArmInstruction({
    @required Condition condition,
    @required bool addOffsetBeforeTransfer,
    @required bool addOffsetToBase,
    @required bool writeAddressIntoBaseOrForceNonPrivilegedAccess,
    @required bool transferByte,
    @required RegisterAny base,
    @required RegisterAny source,
    @required
        Or2<Immediate<Uint12>, ShiftedRegister<Immediate<Uint4>, RegisterNotPC>>
            offset,
  }) : super._(
          condition: condition,
          addOffsetBeforeTransfer: addOffsetBeforeTransfer,
          addOffsetToBase: addOffsetToBase,
          writeAddressIntoBaseOrForceNonPrivilegedAccess:
              writeAddressIntoBaseOrForceNonPrivilegedAccess,
          transferByte: transferByte,
          base: base,
          sourceOrDestination: source,
          offset: offset,
        );

  @override
  R accept<R, C>(ArmInstructionVisitor<R, C> visitor, [C context]) {
    return visitor.visitSTR(this, context);
  }

  /// Source register.
  RegisterAny get source => sourceOrDestination;
}
