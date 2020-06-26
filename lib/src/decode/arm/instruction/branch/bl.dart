part of '../../instruction.dart';

/// A sub-type of the [B$BL] instruction specifically for `BL`.
class BL extends B$BL {
  const BL({
    @required int condition,
    @required int offset,
  }) : super._(
          condition: condition,
          offset: offset,
        );
}
