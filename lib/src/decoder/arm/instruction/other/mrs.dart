part of '../../instruction.dart';

/// `MRS{cond} Rd,Psr`.
///
/// ## Execution
///
/// `Rd = Psr`
///
/// ## Cycles
///
/// `1S`.
@immutable
@sealed
class MRS extends PsrTransferArmInstruction {
  /// Destination register.
  final RegisterNotPC destination;

  MRS({
    @required Condition condition,
    @required bool useSPSR,
    @required this.destination,
  }) : super._(
          condition: condition,
          useSPSR: useSPSR,
        );

  @override
  R accept<R, C>(ArmInstructionVisitor<R, C> visitor, [C context]) {
    return visitor.visitMRS(this, context);
  }

  @override
  List<Object> _values() => [condition, useSPSR, destination];
}
