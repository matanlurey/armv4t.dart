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
class LDRH extends HalfwordDataTransfer {
  LDRH({
    @required Condition condition,
    @required bool addOffsetBeforeTransfer,
    @required bool addOffsetToBase,
    @required bool writeAddressIntoBase,
    @required RegisterAny base,
    @required RegisterAny source,
    @required Or2<RegisterNotPC, Immediate<Uint8>> offset,
  }) : super._(
          condition: condition,
          addOffsetBeforeTransfer: addOffsetBeforeTransfer,
          addOffsetToBase: addOffsetToBase,
          writeAddressIntoBase: writeAddressIntoBase,
          base: base,
          sourceOrDestination: source,
          offset: offset,
        );

  @override
  R accept<R, C>(ArmInstructionVisitor<R, C> visitor, [C context]) {
    return visitor.visitLDRH(this, context);
  }

  /// Source register.
  RegisterAny get source => sourceOrDestination;
}
