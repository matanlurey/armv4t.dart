part of '../../instruction.dart';

/// Arithmetic Shift Right.
///
/// Lo register operand | Hi register operand | Condition codes set
/// ------------------- | ------------------- | -------------------
/// ✔                   | 🗙                   | ✔
abstract class ASR extends ThumbInstruction {
  final int destinationRegister;
  final int sourceRegister;

  const ASR._({
    @required this.destinationRegister,
    @required this.sourceRegister,
  }) : super._();
}

/// A sub-type of [ASR].
///
/// Performs arithmetic shift right on [sourceRegister] by a 5-bit
/// [immediateValue] and stores the result in [destinationRegister].
class ASR$Immediate extends ASR {
  final int immediateValue;

  const ASR$Immediate({
    @required this.immediateValue,
    @required int destinationRegister,
    @required int sourceRegister,
  }) : super._(
          destinationRegister: destinationRegister,
          sourceRegister: sourceRegister,
        );
}

/// A sub-type of [ASR].
///
/// `Rd := Rd >> Rs`
class LSR$ALU extends ASR {
  const LSR$ALU({
    @required int destinationRegister,
    @required int sourceRegister,
  }) : super._(
          destinationRegister: destinationRegister,
          sourceRegister: sourceRegister,
        );
}
