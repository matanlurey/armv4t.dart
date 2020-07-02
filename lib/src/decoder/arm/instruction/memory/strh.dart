part of '../../instruction.dart';

/// `STR{cond}H Rd,<Address>`.
///
/// ## Execution
///
/// Store halfword.
///
/// ## Cycles
///
/// `2N`.
class STRH extends HalfwordDataTransfer {
  STRH({
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
    return visitor.visitSTRH(this, context);
  }

  /// Destination register.
  RegisterAny get destination => sourceOrDestination;
}
