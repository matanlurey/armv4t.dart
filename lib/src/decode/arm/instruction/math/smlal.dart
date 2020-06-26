part of '../../instruction.dart';

/// A sub-type of [MULL$MLAL$UMULL$SMULL$UMLAL$SMLAL] specifically for `SMLAL`.
class SMLAL extends MULL$MLAL$UMULL$SMULL$UMLAL$SMLAL {
  const SMLAL({
    @required int condition,
    @required int s,
    @required int sourceOrDestinationRegisterHi,
    @required int sourceOrDestinationRegisterLo,
    @required int operandRegister1,
    @required int operandRegister2,
  }) : super._(
          condition: condition,
          s: s,
          sourceOrDestinationRegisterHi: sourceOrDestinationRegisterHi,
          sourceOrDestinationRegisterLo: sourceOrDestinationRegisterLo,
          operandRegister1: operandRegister1,
          operandRegister2: operandRegister2,
        );
}
