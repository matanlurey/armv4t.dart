part of '../../instruction.dart';

/// Load Multiple.
///
/// The [LDM] instruction permits block moves of memory to the registers and
/// enables efficient stack operations. The registers may be listed in any
/// order, but the registers are always loaded in order with the lowest
/// numbered register getting the value from the lowest memory address. If `Rn`
/// is also listed in the register list and register writeback ([w]-bit) is set,
/// the final value in `Rn` is unpredictable.
///
/// The `addressingMode` field determines how the _next address_ is calculated
/// (bits [p] and [w]), which controls how the address is updated in conjunction
/// with each register load. The four `addressingMode` values are:
///
/// - `IA` - Increment address by 4 after each load (post-increment).
/// - `IB`  Increment address by 4 before each load (pre-increment).
/// - `DA` - Decrement address by 4 before each load (post-decrement).
/// - `DB` - Decrement address by 4 before each load (pre-decrement).
///
/// The "!" following `Rn` controls the value of the writeback bit (bit [w]),
/// and signifies that `Rn` should be updated with the ending address at the end
/// of the instruction. If the "!" is not present (`W = 0`), the value of `Rn`
/// will be unchanged at the end of the instruction.
///
/// For use in conjunction with stack addressing, four alternative names can be
/// used for the addressing modes. These names are based on the type of stack
/// being used isntead of the addressing mode being used. This eliminates
/// confusion in coding stack push and pop operations, such the type of stack
/// will be the same for both the `LDM` and `STM` instructions. In `ARM` syntax,
/// a full stack is one where the stack pointer points to the last used (full)
/// location. An empty stack is one where the stack pointer points to the next
/// available (empty) stack location. As well, a stack can grow through
/// increasing memory addresses (ascending), or downward through decreasing
/// memorty addresses (descending):
///
/// - `FA` (Full ascending) - Post increment (`DA`) on pop.
/// - `FD` (Full descending) - Post-increment (`IA`) on pop.
/// - `EA` (Empty ascending) - Pre-decrement (`DB`) on pop.
/// - `ED` (Empty descending) - Pre-incrementon (`IB`) on pop.
///
/// ## Syntax
/// `LDM{<cond>} <addressing_mode>, <Rn>{!}, <registers>`
///
/// ## RTL
/// ```
/// if (cond)
///   start_address <- Rn
///   for i = 0 to 14
///     if (register_list[i] == 1)
///       Ri <- memory[next_address]
///   if (regsiter_list[15] == 1)
///     PC <- memory[next_address] & 0xFFFFFFFC
///   if (writeback)
///     Rn <- end_address
/// ```
///
/// > NOTE: There are three distinct variations of the [LDM] instruction. Two
/// > of them are for use in conjunction with exception processing, and are not
/// > described here.
class LDM extends ArmInstruction {
  final int p;

  final int u;

  final int w;

  final int sourceRegister;

  final int registerList;

  const LDM({
    @required int condition,
    @required this.p,
    @required this.u,
    @required this.w,
    @required this.sourceRegister,
    @required this.registerList,
  }) : super._(condition);

  @override
  R accept<R, C>(
    ArmInstructionVisitor<R, C> visitor, [
    C context,
  ]) =>
      visitor.visitLDM(this, context);
}
