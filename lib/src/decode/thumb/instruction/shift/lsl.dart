part of '../../instruction.dart';

/// Logical shift left.
///
/// Lo register operand | Hi register operand | Condition codes set
/// ------------------- | ------------------- | -------------------
/// ✔                   | 🗙                   | ✔
abstract class LSL extends ThumbInstruction {
  final int destinationRegister;
  final int sourceRegister;

  const LSL._({
    @required this.destinationRegister,
    @required this.sourceRegister,
  }) : super._();
}

/// A sub-type of [LSL].
///
/// Shifts [sourceRegister] by a 5-bit [immediateValue] and store the result in
/// [destinationRegister].
class LSL$MoveShiftedRegister extends LSL {
  final int immediateValue;

  const LSL$MoveShiftedRegister({
    @required this.immediateValue,
    @required int destinationRegister,
    @required int sourceRegister,
  }) : super._(
          destinationRegister: destinationRegister,
          sourceRegister: sourceRegister,
        );
}

/// A sub-type of [LSL].
///
/// `Rd := Rd << Rs`
class LSL$ALU extends LSL {
  const LSL$ALU({
    @required int destinationRegister,
    @required int sourceRegister,
  }) : super._(
          destinationRegister: destinationRegister,
          sourceRegister: sourceRegister,
        );
}
