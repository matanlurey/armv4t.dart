part of '../../instruction.dart';

/// `LDR{cond}H Rd,<Address>`.
///
/// ## Execution
///
/// Load unsigned halfword.
///
/// ## Cycles
///
/// `1S+1N+1I+y`.
class LDRHArmInstruction extends HalfwordDataTransferArmInstruction {
  LDRHArmInstruction({
    @required Condition condition,
    @required bool addOffsetBeforeTransfer,
    @required bool addOffsetToBase,
    @required bool writeAddressIntoBase,
    @required RegisterAny base,
    @required RegisterAny destination,
    @required Or2<RegisterNotPC, Immediate<Uint8>> offset,
  }) : super._(
          condition: condition,
          addOffsetBeforeTransfer: addOffsetBeforeTransfer,
          addOffsetToBase: addOffsetToBase,
          writeAddressIntoBase: writeAddressIntoBase,
          base: base,
          sourceOrDestination: destination,
          offset: offset,
        );

  @override
  R accept<R, C>(ArmInstructionVisitor<R, C> visitor, [C context]) {
    return visitor.visitLDRH(this, context);
  }

  /// Destination register.
  RegisterAny get destination => sourceOrDestination;
}
