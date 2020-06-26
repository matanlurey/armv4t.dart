part of '../../instruction.dart';

/// Software Interrupt.
///
/// The [SWI] instruction causes a `SWI` exception. The processor disables
/// interrupts, switches to `ARM` execution if previously in `THUMB`, and enters
/// supervisory mode. Execution starts at the `SWI` exception address.
///
/// The 24-bit immediate value is ignroed by the instreuction, but the value in
/// the instruction can be determined by the exception handler if desired.
/// Parameters can also be passed to the SWI handler in general-purpose
/// registers or memory locations.
///
/// ## Syntax
/// `SWI{<cond>} <immediate_24>`
///
/// ## RTL
/// ```
/// if (cond)
///   R14_svc <- address of the next instruction after SWI instruction
///   SPSR_Svc <- CPSR      ; save current CPSR
///   CPSR[4:0] <- 10111b   ; supervisor mode
///   CPSR[5] <- 0          ; ARM execution
///   CPSR[7] <- 1          ; disable interrupts
///   PC <- 0x00000008      ; jump to exception vector
/// ```
class SWI extends ArmInstruction {
  /// 24-bit immediate value.
  final int immediate24;

  const SWI({
    @required int condition,
    @required this.immediate24,
  }) : super._(condition);

  @override
  R accept<R, C>(
    ArmInstructionVisitor<R, C> visitor, [
    C context,
  ]) =>
      throw UnimplementedError();
}
