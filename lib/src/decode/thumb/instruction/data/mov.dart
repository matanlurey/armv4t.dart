part of '../../instruction.dart';

/// Move register.
///
/// Lo register operand | Hi register operand | Condition codes set
/// ------------------- | ------------------- | -------------------
/// ✔                   | ✔                   | ✔
abstract class MOV extends ThumbInstruction {
  final int destinationRegister;

  const MOV._({
    @required this.destinationRegister,
  }) : super._();
}

/// A sub-type of [MOV].
///
/// Move 8-bit [immediateValue] into [destinationRegister].
class MOV$Immediate extends MOV {
  final int immediateValue;

  const MOV$Immediate({
    @required this.immediateValue,
    @required int destinationRegister,
  }) : super._(
          destinationRegister: destinationRegister,
        );
}

/// A sub-type of [MOV].
///
/// Move a value from a register in the range 8-15 to a register in the range
/// 0-7.
class MOV$HiToLo extends MOV {
  final int sourceRegister;

  const MOV$HiToLo({
    @required int destinationRegister,
    @required this.sourceRegister,
  }) : super._(
          destinationRegister: destinationRegister,
        );
}

/// A sub-type of [MOV].
///
/// Moves a value from a register in the range 0-7 to a register in the range
/// 8-15.
class MOV$LoToHi extends MOV {
  final int sourceRegister;

  const MOV$LoToHi({
    @required this.sourceRegister,
    @required int destinationRegister,
  }) : super._(
          destinationRegister: destinationRegister,
        );
}

/// A sub-type of [MOV].
///
/// Moves a value between two registers in the range 8-15.
class MOV$HiToHi extends MOV {
  final int sourceRegister;

  const MOV$HiToHi({
    @required this.sourceRegister,
    @required int destinationRegister,
  }) : super._(
          destinationRegister: destinationRegister,
        );
}
