part of '../../instruction.dart';

/// Load word.
///
/// Lo register operand | Hi register operand | Condition codes set
/// ------------------- | ------------------- | -------------------
/// ✔                   | 🗙                   | 🗙
abstract class LDR extends ThumbInstruction {
  final int destinationRegister;

  const LDR._({
    @required this.destinationRegister,
  }) : super._();
}

/// A sub-type of [LDR].
///
/// Add unsigned offset (255 words, 1020 bytes) in [immediateValue] to the
/// current value of the `PC`. Loads the word from the resulting address into
/// [destinationRegister].
class LDR$AddUnsignedImmediate extends LDR {
  final int immediateValue;

  const LDR$AddUnsignedImmediate({
    @required this.immediateValue,
    @required int destinationRegister,
  }) : super._(
          destinationRegister: destinationRegister,
        );
}

/// A sub-type of [LDR].
///
/// Calculate the source address by adding together the value in [baseRegister]
/// and the value in [offsetRegister]. Load the contents of the address into
/// [destinationRegister].
class LDR$Indexed extends LDR {
  final int baseRegister;
  final int offsetRegister;

  const LDR$Indexed({
    @required this.baseRegister,
    @required this.offsetRegister,
    @required int destinationRegister,
  }) : super._(
          destinationRegister: destinationRegister,
        );
}

/// A sub-type of [LDR].
///
/// Calculate the source address by adding together the value in [baseRegister]
/// and [immediateValue]. Loads [destinationRegister] from the address.
class LDR$Immediate extends LDR {
  final int immediateValue;
  final int baseRegister;

  const LDR$Immediate({
    @required this.immediateValue,
    @required this.baseRegister,
    @required int destinationRegister,
  }) : super._(
          destinationRegister: destinationRegister,
        );
}

/// A sub-type of [LDR].
///
/// Adds unsigned offset (255 words, 1020 bytes) in [immediateValue] to the
/// current value of the `SP` (`R7`). Load the word from the resulting address
/// into [destinationRegister].
class LDR$Relative extends LDR {
  final int immediateValue;

  const LDR$Relative({
    @required this.immediateValue,
    @required int destinationRegister,
  }) : super._(
          destinationRegister: destinationRegister,
        );
}
