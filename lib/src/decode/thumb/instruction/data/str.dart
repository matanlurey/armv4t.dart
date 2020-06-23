part of '../../instruction.dart';

/// Store word.
///
/// Lo register operand | Hi register operand | Condition codes set
/// ------------------- | ------------------- | -------------------
/// ✔                   | 🗙                   | 🗙
abstract class STR extends ThumbInstruction {
  final int destinationRegister;

  const STR._({
    @required this.destinationRegister,
  }) : super._();
}

/// A sub-type of [STR].
///
/// Pre-indexed word store: Calculate the target address by adding together the
/// value in [baseRegister] and the value in [offsetRegister]. Store the
/// contents of [destinationRegister] at the address.
class STR$RelativeOffset extends STR {
  final int baseRegister;
  final int offsetRegister;

  const STR$RelativeOffset({
    @required this.offsetRegister,
    @required this.baseRegister,
    @required int destinationRegister,
  }) : super._(
          destinationRegister: destinationRegister,
        );

  @override
  R accept<R, C>(
    ThumbInstructionVisitor<R, C> visitor, [
    C context,
  ]) =>
      visitor.visitSTR$RelativeOffset(this, context);
}

/// A sub-type of [STR].
///
/// Calculate the target address by adding together the value of [baseRegister]
/// and [immediateValue]. Store the contents of [destinationRegister] at the
/// address.
class STR$ImmediateOffset extends STR {
  final int baseRegister;
  final int immediateValue;

  const STR$ImmediateOffset({
    @required this.immediateValue,
    @required this.baseRegister,
    @required int destinationRegister,
  }) : super._(
          destinationRegister: destinationRegister,
        );

  @override
  R accept<R, C>(
    ThumbInstructionVisitor<R, C> visitor, [
    C context,
  ]) =>
      visitor.visitSTR$ImmediateOffset(this, context);
}

/// A sub-type of [STR].
///
/// Adds unsigned offsewt (255 words, 1020 bytes) in [immediateValue] to the
/// current value of the `SP` (`R7`). Store the contents of
/// [destinationRegister] at the resulting address.
class STR$SPRelative extends STR {
  final int immediateValue;

  const STR$SPRelative({
    @required this.immediateValue,
    @required int destinationRegister,
  }) : super._(
          destinationRegister: destinationRegister,
        );

  @override
  R accept<R, C>(
    ThumbInstructionVisitor<R, C> visitor, [
    C context,
  ]) =>
      visitor.visitSTR$SPRelative(this, context);
}
