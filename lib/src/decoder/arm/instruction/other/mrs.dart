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
class MRS extends PsrTransfer {
  /// Destination register.
  final RegisterAny destination;

  MRS._({
    @required Condition condition,
    @required bool useSPSR,
    @required this.destination,
  }) : super._(
          condition: condition,
          useSPSR: useSPSR,
        );
}
