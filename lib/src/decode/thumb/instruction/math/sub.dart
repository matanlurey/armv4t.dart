part of '../../instruction.dart';

/// Subtract.
///
/// Lo register operand | Hi register operand | Condition codes set
/// ------------------- | ------------------- | -------------------
/// ✔                   | 🗙                   | ✔
abstract class SUB extends ThumbInstruction {
  final int destinationRegister;

  const SUB._({
    @required this.destinationRegister,
  }) : super._();
}

/// A sub-type of [SUB].
///
/// Subtracts contents of [otherRegister] to [sourceRegister]. Place the results
/// in [destinationRegister].
class SUB$AddSubtract$Register extends SUB {
  final int otherRegister;
  final int sourceRegister;

  const SUB$AddSubtract$Register({
    @required int destinationRegister,
    @required this.sourceRegister,
    @required this.otherRegister,
  }) : super._(
          destinationRegister: destinationRegister,
        );
}

/// A sub-type of [SUB].
///
/// Subtracts 3-bit [immediateValue] to the contents of [sourceRegister]. Place
/// the results in [destinationRegister].
class SUB$AddSubtract$Offset3 extends SUB {
  final int immediateValue;
  final int sourceRegister;

  const SUB$AddSubtract$Offset3({
    @required int destinationRegister,
    @required this.sourceRegister,
    @required this.immediateValue,
  }) : super._(
          destinationRegister: destinationRegister,
        );
}

/// A sub-type of [SUB].
///
/// Subtracts 8-bit [immediateValue] to contents of [destinationRegister] and
/// places the result [destinationRegister].
class SUB$MoveCompareAddSubtractImmediate extends SUB {
  final int immediateValue;

  const SUB$MoveCompareAddSubtractImmediate({
    @required int destinationRegister,
    @required this.immediateValue,
  }) : super._(
          destinationRegister: destinationRegister,
        );
}
