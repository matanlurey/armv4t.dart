part of '../../instruction.dart';

/// Pop registers.
///
/// Lo register operand | Hi register operand | Condition codes set
/// ------------------- | ------------------- | -------------------
/// ✔                   | 🗙                   | 🗙
abstract class POP extends ThumbInstruction {
  final int registerList;

  const POP._({
    @required this.registerList,
  }) : super._();
}

/// A sub-type of [POP].
///
/// Pop values off the stack into the registers specified by [registerList].
/// Update the stack pointer (`SP`).
class POP$Registers extends POP {
  const POP$Registers({
    @required int registerList,
  }) : super._(
          registerList: registerList,
        );

  @override
  R accept<R, C>(
    ThumbInstructionVisitor<R, C> visitor, [
    C context,
  ]) =>
      visitor.visitPOP$Registers(this, context);
}

//// A sub-type of [POP].
///
/// Pop values off the stack and load into the registers specified by
/// [registerList]. Pop the program counter (`PC`) off the stack. Update the
/// stack pointer (`SP`).
class POP$RegistersAndLinkRegister extends POP {
  const POP$RegistersAndLinkRegister({
    @required int registerList,
  }) : super._(
          registerList: registerList,
        );

  @override
  R accept<R, C>(
    ThumbInstructionVisitor<R, C> visitor, [
    C context,
  ]) =>
      visitor.visitPOP$RegistersAndLinkRegister(this, context);
}
