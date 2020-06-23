part of '../../instruction.dart';

/// Store word.
///
/// Lo register operand | Hi register operand | Condition codes set
/// ------------------- | ------------------- | -------------------
/// ✔                   | 🗙                   | 🗙
abstract class STR extends ThumbInstruction {
  final int destinationRegister;

  const STR._({
    @required this.destinationRegister,
  }) : super._();
}

/// A sub-type of [STR].
///
/// Pre-indexed word store: Calculate the target address by adding together the
/// value in [baseRegister] and the value in [offsetRegister]. Store the
/// contents of [destinationRegister] at the address.
class STR$Indexed extends STR {
  final int baseRegister;
  final int offsetRegister;

  const STR$Indexed({
    @required this.offsetRegister,
    @required this.baseRegister,
    @required int destinationRegister,
  }) : super._(
          destinationRegister: destinationRegister,
        );
}

/// A sub-type of [STR].
///
/// Calculate the target address by adding together the value of [baseRegister]
/// and [immediateValue]. Store the contents of [destinationRegister] at the
/// address.
class STR$Immediate extends STR {
  final int baseRegister;
  final int immediateValue;

  const STR$Immediate({
    @required this.immediateValue,
    @required this.baseRegister,
    @required int destinationRegister,
  }) : super._(
          destinationRegister: destinationRegister,
        );
}

/// A sub-type of [STR].
///
/// Adds unsigned offsewt (255 words, 1020 bytes) in [immediateValue] to the
/// current value of the `SP` (`R7`). Store the contents of
/// [destinationRegister] at the resulting address.
class STR$Relative extends STR {
  final int immediateValue;

  const STR$Relative({
    @required this.immediateValue,
    @required int destinationRegister,
  }) : super._(
          destinationRegister: destinationRegister,
        );
}
