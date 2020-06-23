part of '../../instruction.dart';

/// Push registers.
///
/// Lo register operand | Hi register operand | Condition codes set
/// ------------------- | ------------------- | -------------------
/// ✔                   | 🗙                   | 🗙
abstract class PUSH extends ThumbInstruction {
  final int registerList;

  const PUSH._({
    @required this.registerList,
  }) : super._();
}

/// A sub-type of [PUSH].
///
/// Push the registers specified by [registerList] onto the stack. Update the
/// stack pointer (`SP`).
class PUSH$Registers extends PUSH {
  const PUSH$Registers({
    @required int registerList,
  }) : super._(
          registerList: registerList,
        );
}

//// A sub-type of [PUSH].
///
/// Push the Link Register (`LR`) and the registers specifeid by [registerList]
/// (if any) onto the stack. Update the stack pointer (`SP`).
class PUSH$RegistersAndLinkRegister extends PUSH {
  const PUSH$RegistersAndLinkRegister({
    @required int registerList,
  }) : super._(
          registerList: registerList,
        );
}
