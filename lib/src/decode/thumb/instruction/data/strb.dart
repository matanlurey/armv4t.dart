part of '../../instruction.dart';

/// Store byte.
///
/// Lo register operand | Hi register operand | Condition codes set
/// ------------------- | ------------------- | -------------------
/// ✔                   | 🗙                   | 🗙
abstract class STRB extends ThumbInstruction {
  final int baseRegister;
  final int destinationRegister;

  const STRB._({
    @required this.baseRegister,
    @required this.destinationRegister,
  }) : super._();
}

/// A sub-type of [STRB].
///
/// Pre-indexed word load: Calculate the target address by adding together the
/// value in [baseRegister] and the value in [offsetRegister]. Store the byte
/// value in [destinationRegister] at the resulting address.
class STRB$RelativeOffset extends STRB {
  final int offsetRegister;

  const STRB$RelativeOffset({
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
      visitor.visitSTRB$RelativeOffset(this, context);
}

/// A sub-type of [LDR].
///
/// Calculate the target address by adding together the value in [baseRegister]
/// and [immediateValue]. Store the byte value in [destinationRegister] at the
/// address.
class STRB$ImmediateOffset extends STRB {
  final int immediateValue;

  const STRB$ImmediateOffset({
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
      visitor.visitSTRB$ImmediateOffset(this, context);
}
