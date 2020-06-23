part of '../../instruction.dart';

/// Load half-word.
///
/// Lo register operand | Hi register operand | Condition codes set
/// ------------------- | ------------------- | -------------------
/// ✔                   | 🗙                   | 🗙
abstract class LDRH extends ThumbInstruction {
  final int baseRegister;
  final int destinationRegister;

  const LDRH._({
    @required this.baseRegister,
    @required this.destinationRegister,
  }) : super._();
}

/// A sub-type of [LDRH].
///
/// Add [offsetRegister] to the base address in [baseRegister]. Load bits 0-15
/// of [destinationRegister] from the resulting address, and set bits 16-31 of
/// [destinationRegister] to 0.
class LDRH$SignExtendedByteOrHalfWord extends LDRH {
  final int offsetRegister;

  const LDRH$SignExtendedByteOrHalfWord({
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
      visitor.visitLDRH$SignExtendedByteOrHalfWord(this, context);
}

/// A sub-type of [LDRH].
///
/// Add [immediateValue] to the base address in [baseRegister]. Load bits 0-15
/// from the resulting address into [destinationRegister] and sets bits 16-31
/// to zero.
class LDRH$HalfWord extends STRB {
  final int immediateValue;

  const LDRH$HalfWord({
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
      visitor.visitLDRH$HalfWord(this, context);
}
