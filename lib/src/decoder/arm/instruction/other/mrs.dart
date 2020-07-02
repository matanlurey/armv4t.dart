part of '../../instruction.dart';

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
