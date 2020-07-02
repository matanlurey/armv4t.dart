part of '../../instruction.dart';

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

  SWP._({
    @required Condition condition,
    @required this.transferByte,
    @required this.base,
    @required this.destination,
    @required this.source,
  }) : super._(condition: condition);
}
