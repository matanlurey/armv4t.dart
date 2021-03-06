part of '../../instruction.dart';

/// `LDR{cond}SH Rd,<Address>`.
///
/// ## Execution
///
/// Load signed halfword.
///
/// ## Cycles
///
/// `1S+1N+1I+y`.
class LDRSHArmInstruction extends HalfwordDataTransferArmInstruction {
  LDRSHArmInstruction({
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
    return visitor.visitLDRSH(this, context);
  }

  /// Destination register.
  RegisterAny get destination => sourceOrDestination;
}
