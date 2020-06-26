part of '../../instruction.dart';

/// A sub-type of [MUL$MLA] specifically for the `MLA` instruction.
class MLA extends MUL$MLA {
  const MLA({
    @required int condition,
    @required int s,
    @required int destinationRegister,
    @required int operandRegister1,
    @required int operandRegister2,
    @required int operandRegister3,
  }) : super._(
          condition: condition,
          s: s,
          destinationRegister: destinationRegister,
          operandRegister1: operandRegister1,
          operandRegister2: operandRegister2,
          operandRegister3: operandRegister3,
        );
}
