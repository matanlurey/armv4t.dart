part of '../../instruction.dart';

/// Store halfword.
///
/// Lo register operand | Hi register operand | Condition codes set
/// ------------------- | ------------------- | -------------------
/// ✔                   | 🗙                   | 🗙
abstract class STRH extends ThumbInstruction {
  final int baseRegister;
  final int destinationRegister;

  const STRH._({
    @required this.baseRegister,
    @required this.destinationRegister,
  }) : super._();
}

/// A sub-type of [STRH].
///
/// Add [offsetRegister] to the base address in [baseRegister]. Store bits 0-15
/// of [destinationRegister] at the resulting address.
class STRH$SignExtendedByteOrHalfWord extends STRH {
  final int offsetRegister;

  const STRH$SignExtendedByteOrHalfWord({
    @required this.offsetRegister,
    @required int baseRegister,
    @required int destinationRegister,
  }) : super._(
          baseRegister: baseRegister,
          destinationRegister: destinationRegister,
        );

  @override
  R accept<R, C>(
    ThumbInstructionVisitor<R, C> visitor, [
    C context,
  ]) =>
      visitor.visitSTRH$SignExtendedByteOrHalfWord(this, context);
}

/// A sub-type of [STRH].
///
/// Add [immediateValue] to the base address in [baseRegister] and store bits
/// 0-15 of [destinationRegister] at the resulting address.
class STRH$HalfWord extends STRB {
  final int immediateValue;

  const STRH$HalfWord({
    @required this.immediateValue,
    @required int baseRegister,
    @required int destinationRegister,
  }) : super._(
          baseRegister: baseRegister,
          destinationRegister: destinationRegister,
        );

  @override
  R accept<R, C>(
    ThumbInstructionVisitor<R, C> visitor, [
    C context,
  ]) =>
      visitor.visitSTRH$HalfWord(this, context);
}
