part of '../format.dart';

class AluOperationThumbFormat extends ThumbFormat {
  final Uint3 opCode;
  final Uint3 source;
  final Uint3 destination;

  const AluOperationThumbFormat({
    @required this.opCode,
    @required this.source,
    @required this.destination,
  }) : super._();

  @override
  R accept<R, C>(ThumbInstructionVisitor<R, C> visitor, [C context]) {
    return visitor.visitAluOperation(this, context);
  }

  @override
  Map<String, int> _values() {
    return {
      'p': opCode.value,
      's': source.value,
      'd': destination.value,
    };
  }
}
