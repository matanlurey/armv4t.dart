part of '../../instruction.dart';

class LDR extends SingleDataTransfer {
  LDR({
    @required Condition condition,
    @required bool addOffsetBeforeTransfer,
    @required bool addOffsetToBase,
    @required bool writeAddressIntoBaseOrForceNonPrivilegedAccess,
    @required bool transferByte,
    @required RegisterAny base,
    @required RegisterAny source,
    @required Or2<Immediate<Uint12>, ShiftedRegister<Immediate<Uint4>>> offset,
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

  /// Source register.
  RegisterAny get source => sourceOrDestination;
}
