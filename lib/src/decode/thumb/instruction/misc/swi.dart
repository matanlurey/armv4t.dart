part of '../../instruction.dart';

/// Software Interrupt.
///
/// Move the address to the next instruction in the link register (`LR`), move
/// the current program status register (`CPSR`) to the saved program status
/// register (`SPSR`), load the SWI vector address (`0x8`) into the program
/// counter (`PC`). Switch to `ARM` state and enter supervisor (`SVC`) mode.
///
/// Lo register operand | Hi register operand | Condition codes set
/// ------------------- | ------------------- | -------------------
/// 🗙                   | 🗙                   | 🗙
class SWI extends ThumbInstruction {
  /// An 8-bit value used solely by the SWI handler: ignored by the processor.
  final int value;

  const SWI({@required this.value}) : super._();

  @override
  R accept<R, C>(
    ThumbInstructionVisitor<R, C> visitor, [
    C context,
  ]) =>
      visitor.visitSWI(this, context);
}
