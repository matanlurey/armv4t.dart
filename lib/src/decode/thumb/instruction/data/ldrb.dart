part of '../../instruction.dart';

/// Load byte.
///
/// Lo register operand | Hi register operand | Condition codes set
/// ------------------- | ------------------- | -------------------
/// ✔                   | 🗙                   | 🗙
abstract class LDRB extends ThumbInstruction {
  final int baseRegister;
  final int destinationRegister;

  const LDRB._({
    @required this.baseRegister,
    @required this.destinationRegister,
  }) : super._();
}

/// A sub-type of [LDRB].
///
/// Pre-indexed byte load: Calculate the source address by adding together the
/// value in [baseRegister] and the value in [offsetRegister]. Load the byte
/// value at the resulting address.
class LDRB$Indexed extends LDRB {
  final int offsetRegister;

  const LDRB$Indexed({
    @required this.offsetRegister,
    @required int baseRegister,
    @required int destinationRegister,
  }) : super._(
          baseRegister: baseRegister,
          destinationRegister: destinationRegister,
        );
}

/// A sub-type of [LDRB].
///
/// Calculate source address by adding together the value in [baseRegister] and
/// [immediateValue]. Load the byte value at the address into
/// [destinationRegister].
class LDRB$Immediate extends LDRB {
  final int immediateValue;

  const LDRB$Immediate({
    @required this.immediateValue,
    @required int baseRegister,
    @required int destinationRegister,
  }) : super._(
          baseRegister: baseRegister,
          destinationRegister: destinationRegister,
        );
}
