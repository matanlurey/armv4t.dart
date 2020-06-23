part of '../../instruction.dart';

/// Store byte.
///
/// Lo register operand | Hi register operand | Condition codes set
/// ------------------- | ------------------- | -------------------
/// ✔                   | 🗙                   | 🗙
abstract class STRB extends ThumbInstruction {
  final int baseRegister;
  final int destinationRegister;

  const STRB._({
    @required this.baseRegister,
    @required this.destinationRegister,
  }) : super._();
}

/// A sub-type of [STRB].
///
/// Pre-indexed word load: Calculate the target address by adding together the
/// value in [baseRegister] and the value in [offsetRegister]. Store the byte
/// value in [destinationRegister] at the resulting address.
class STRB$Indexed extends STRB {
  final int offsetRegister;

  const STRB$Indexed._({
    @required this.offsetRegister,
    @required int baseRegister,
    @required int destinationRegister,
  }) : super._(
          baseRegister: baseRegister,
          destinationRegister: destinationRegister,
        );
}

/// A sub-type of [LDR].
///
/// Calculate the target address by adding together the value in [baseRegister]
/// and [immediateValue]. Store the byte value in [destinationRegister] at the
/// address.
class STRB$Immediate extends STRB {
  final int immediateValue;

  const STRB$Immediate({
    @required this.immediateValue,
    @required int baseRegister,
    @required int destinationRegister,
  }) : super._(
          baseRegister: baseRegister,
          destinationRegister: destinationRegister,
        );
}
