part of '../../instruction.dart';

/// Add.
///
/// Lo register operand | Hi register operand | Condition codes set
/// ------------------- | ------------------- | -------------------
/// ✔                   | ✔                   | ✔
abstract class ADD extends ThumbInstruction {
  final int destinationRegister;

  const ADD._({
    @required this.destinationRegister,
  }) : super._();
}

/// A sub-type of [ADD].
///
/// Adds contents of [otherRegister] to [sourceRegister]. Place the results ib
/// [destinationRegister].
class ADD$AddSubtract$Register extends ADD {
  final int otherRegister;
  final int sourceRegister;

  const ADD$AddSubtract$Register({
    @required int destinationRegister,
    @required this.sourceRegister,
    @required this.otherRegister,
  }) : super._(
          destinationRegister: destinationRegister,
        );
}

/// A sub-type of [ADD].
///
/// Adds 3-bit [immediateValue] to the contents of [sourceRegister]. Place the
/// results in [destinationRegister].
class ADD$AddSubtract$Offset3 extends ADD {
  final int immediateValue;
  final int sourceRegister;

  const ADD$AddSubtract$Offset3({
    @required int destinationRegister,
    @required this.sourceRegister,
    @required this.immediateValue,
  }) : super._(
          destinationRegister: destinationRegister,
        );
}

/// A sub-type of [ADD].
///
/// Adds 8-bit [immediateValue] to contents of [destinationRegister] and places
/// the result [destinationRegister].
class ADD$MoveCompareAddSubtractImmediate extends ADD {
  final int immediateValue;

  const ADD$MoveCompareAddSubtractImmediate({
    @required int destinationRegister,
    @required this.immediateValue,
  }) : super._(
          destinationRegister: destinationRegister,
        );
}

/// A sub-type of [ADD].
///
/// Adds a register in the range 8-15 to a register in the range 0-7.
class ADD$HiToLo extends ADD {
  final int sourceRegister;

  const ADD$HiToLo({
    @required int destinationRegister,
    @required this.sourceRegister,
  }) : super._(
          destinationRegister: destinationRegister,
        );
}

/// A sub-type of [ADD].
///
/// Adds a register in the range 0-7 to a register in the range 8-15.
class ADD$LoToHi extends ADD {
  final int sourceRegister;

  const ADD$LoToHi({
    @required this.sourceRegister,
    @required int destinationRegister,
  }) : super._(
          destinationRegister: destinationRegister,
        );
}

/// A sub-type of [ADD].
///
/// Adds two registers in the range 8-15.
class ADD$HiToHi extends ADD {
  final int sourceRegister;

  const ADD$HiToHi({
    @required this.sourceRegister,
    @required int destinationRegister,
  }) : super._(
          destinationRegister: destinationRegister,
        );
}

/// A sub-type of [ADD].
///
/// Adds [immediateValue] to the current value of the program counter (`PC`) and
/// load the result into [destinationRegister].
class ADD$LoadAddress$PC extends ADD {
  final int immediateValue;

  const ADD$LoadAddress$PC({
    @required this.immediateValue,
    @required int destinationRegister,
  }) : super._(
          destinationRegister: destinationRegister,
        );
}

/// A sub-type of [ADD].
///
/// Adds [immediateValue] to the current value of the stack pointer (`SP`) and
/// load the result into [destinationRegister].
class ADD$LoadAddress$SP extends ADD {
  final int immediateValue;

  const ADD$LoadAddress$SP({
    @required this.immediateValue,
    @required int destinationRegister,
  }) : super._(
          destinationRegister: destinationRegister,
        );
}

/// A sub-type of [ADD].
///
/// Adds [immediateValue] to the stack pointer (`SP`).
class ADD$OffsetToStackPointer$Positive extends ADD {
  final int immediateValue;

  const ADD$OffsetToStackPointer$Positive({
    @required this.immediateValue,
    @required int destinationRegister,
  }) : super._(
          destinationRegister: destinationRegister,
        );
}

/// A sub-type of [ADD].
///
/// Adds `-` [immediateValue] to the stack pointer (`SP`).
class ADD$OffsetToStackPointer$Negative extends ADD {
  final int immediateValue;

  const ADD$OffsetToStackPointer$Negative({
    @required this.immediateValue,
    @required int destinationRegister,
  }) : super._(
          destinationRegister: destinationRegister,
        );
}
