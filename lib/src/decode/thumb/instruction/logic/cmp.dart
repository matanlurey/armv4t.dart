part of '../../instruction.dart';

/// Compare.
///
/// Compare contents of [destinationRegister] with 8-bit [immediateValue].
///
/// Lo register operand | Hi register operand | Condition codes set
/// ------------------- | ------------------- | -------------------
/// ✔                   | ✔                   | ✔
abstract class CMP extends ThumbInstruction {
  final int destinationRegister;

  const CMP._({
    @required this.destinationRegister,
  }) : super._();
}

/// A sub-type of [CMP].
///
/// Compare contents of [destinationRegister] with 8-bit [immediateValue].
class CMP$Immediate extends CMP {
  final int immediateValue;

  const CMP$Immediate({
    @required this.immediateValue,
    @required int destinationRegister,
  }) : super._(
          destinationRegister: destinationRegister,
        );
}

/// A sub-type of [CMP].
///
/// Sets condition codes on `Rd - Rs`.
class CMP$ALU extends CMP {
  final int sourceRegister;

  const CMP$ALU({
    @required this.sourceRegister,
    @required int destinationRegister,
  }) : super._(
          destinationRegister: destinationRegister,
        );
}

/// A sub-type of [CMP].
///
/// Compare a register in the range 0-7 with a register in the range 8-15. Sets
/// the condition code flags on the result.
class CMP$HiToLo extends CMP {
  final int sourceRegister;

  const CMP$HiToLo({
    @required int destinationRegister,
    @required this.sourceRegister,
  }) : super._(
          destinationRegister: destinationRegister,
        );
}

/// A sub-type of [CMP].
///
/// Compare a register in the range 8-15 with a register in the range 0-7. Sets
/// the condition code flags on the result.
class CMP$LoToHi extends CMP {
  final int sourceRegister;

  const CMP$LoToHi({
    @required this.sourceRegister,
    @required int destinationRegister,
  }) : super._(
          destinationRegister: destinationRegister,
        );
}

/// A sub-type of [CMP].
///
/// Compares two registers in the range 8-15. Sets the condition flags on the
/// result.
class CMP$HiToHi extends CMP {
  final int sourceRegister;

  const CMP$HiToHi({
    @required this.sourceRegister,
    @required int destinationRegister,
  }) : super._(
          destinationRegister: destinationRegister,
        );
}
