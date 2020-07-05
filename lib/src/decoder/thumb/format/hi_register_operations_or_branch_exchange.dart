part of '../format.dart';

class HiRegisterOperationsOrBranchExchangeThumbFormat extends ThumbFormat {
  final Uint2 opCode;
  final Uint2 hCodes;
  final Uint3 source;
  final Uint3 destination;

  const HiRegisterOperationsOrBranchExchangeThumbFormat({
    @required this.opCode,
    @required this.hCodes,
    @required this.source,
    @required this.destination,
  }) : super._();

  @override
  R accept<R, C>(ThumbInstructionVisitor<R, C> visitor, [C context]) {
    throw UnimplementedError();
  }

  @override
  Map<String, int> _values() {
    return {
      'p': opCode.value,
      'h': hCodes.value,
      's': source.value,
      'd': destination.value,
    };
  }
}
