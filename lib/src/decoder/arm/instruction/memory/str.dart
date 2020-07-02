part of '../../instruction.dart';

class STR extends SingleDataTransfer {
  STR({
    @required Condition condition,
    @required bool addOffsetBeforeTransfer,
    @required bool addOffsetToBase,
    @required bool writeAddressIntoBaseOrForceNonPrivilegedAccess,
    @required bool transferByte,
    @required RegisterAny base,
    @required RegisterAny destination,
    @required Or2<Immediate<Uint12>, ShiftedRegister<Immediate<Uint4>>> offset,
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

  /// Destination register.
  RegisterAny get destination => sourceOrDestination;
}
