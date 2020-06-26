part of '../../instruction.dart';

/// A sub-type of [LDR$STR] specifically for instruction `STR`.
class STR extends LDR$STR {
  const STR({
    @required int condition,
    @required int i,
    @required int p,
    @required int u,
    @required int b,
    @required int w,
    @required int baseRegister,
    @required int sourceOrDestinationRegister,
    @required int offset,
  }) : super._(
          condition: condition,
          i: i,
          p: p,
          u: u,
          b: b,
          w: w,
          baseRegister: baseRegister,
          sourceOrDestinationRegister: sourceOrDestinationRegister,
          offset: offset,
        );
}
