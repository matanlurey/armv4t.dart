part of '../../instruction.dart';

/// `SWP{cond}{B} Rd,Rm,[Rn]`.
///
/// ## Execution
///
/// `Rd = [Rn], [Rn] = Rm`.
///
/// ## Cycles
///
/// `1S+2N+1I`.
@immutable
@sealed
class SWP
    /**/ extends ArmInstruction
    /**/ implements
        HasTransferByte {
  /// `B`: Whether to transfer a byte (8-bits, `1`) otherwise a word (32, `0`).
  @override
  final bool transferByte;

  /// Base register.
  final RegisterNotPC base;

  /// Destination register.
  final RegisterNotPC destination;

  /// Source register.
  final RegisterNotPC source;

  SWP({
    @required Condition condition,
    @required this.transferByte,
    @required this.base,
    @required this.destination,
    @required this.source,
  }) : super._(condition: condition);

  @override
  R accept<R, C>(ArmInstructionVisitor<R, C> visitor, [C context]) {
    return visitor.visitSWP(this, context);
  }
}
