part of '../../instruction.dart';

/// Logical Shift Right.
///
/// Lo register operand | Hi register operand | Condition codes set
/// ------------------- | ------------------- | -------------------
/// ✔                   | 🗙                   | ✔
abstract class LSR extends ThumbInstruction {
  final int destinationRegister;
  final int sourceRegister;

  const LSR._({
    @required this.destinationRegister,
    @required this.sourceRegister,
  }) : super._();
}

/// A sub-type of [LSR].
///
/// Perform logical shift right on [sourceRegister] by a 5-bit [immediateValue]
/// and store the result in [destinationRegister].
class LSR$MoveShiftedRegister extends LSR {
  final int immediateValue;

  const LSR$MoveShiftedRegister({
    @required this.immediateValue,
    @required int destinationRegister,
    @required int sourceRegister,
  }) : super._(
          destinationRegister: destinationRegister,
          sourceRegister: sourceRegister,
        );
}

/// A sub-type of [LSR].
///
/// `Rd := Rd >> Rs`
class LSR$ALU extends LSR {
  const LSR$ALU({
    @required int destinationRegister,
    @required int sourceRegister,
  }) : super._(
          destinationRegister: destinationRegister,
          sourceRegister: sourceRegister,
        );
}
