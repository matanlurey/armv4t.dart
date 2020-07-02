part of '../../instruction.dart';

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
}
