part of '../../instruction.dart';

/// `LDR{cond}{B}{T} Rn,<Address>`.
///
/// ## Execution
///
/// `Rd = [Rn +/- <Offset>]`.
///
/// ## Cycles
///
/// `1S+1N+1I+y`.
class LDRArmInstruction extends SingleDataTransferArmInstruction {
  LDRArmInstruction({
    @required Condition condition,
    @required bool addOffsetBeforeTransfer,
    @required bool addOffsetToBase,
    @required bool writeAddressIntoBaseOrForceNonPrivilegedAccess,
    @required bool transferByte,
    @required RegisterAny base,
    @required RegisterAny destination,
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
          sourceOrDestination: destination,
          offset: offset,
        );

  @override
  R accept<R, C>(ArmInstructionVisitor<R, C> visitor, [C context]) {
    return visitor.visitLDR(this, context);
  }

  /// Destination register.
  RegisterAny get destination => sourceOrDestination;
}
