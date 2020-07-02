part of '../../instruction.dart';

class LDRSH extends HalfwordDataTransfer {
  LDRSH({
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

  /// Source register.
  RegisterAny get source => sourceOrDestination;
}
