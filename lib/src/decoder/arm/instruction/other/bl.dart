part of '../../instruction.dart';

/// `BL{cond} label`.
///
/// ## Execution
///
/// `PC = $+8 +/- 32M, LR=$+4`.
///
/// ## Cycles
///
/// `2S+1N`.
class BL extends ArmInstruction {
  final Uint24 offset;

  BL({
    @required Condition condition,
    @required this.offset,
  }) : super._(condition: condition);
}
