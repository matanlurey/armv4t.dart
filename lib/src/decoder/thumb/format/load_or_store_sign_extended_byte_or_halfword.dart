part of '../format.dart';

class LoadOrStoreSignExtendedByteOrHalfword extends ThumbFormat {
  final bool hBit;
  final bool sBit;
  final Uint3 offsetRegister;
  final Uint3 baseRegister;
  final Uint3 sourceOrdestinationRegister;

  const LoadOrStoreSignExtendedByteOrHalfword({
    @required this.hBit,
    @required this.sBit,
    @required this.offsetRegister,
    @required this.baseRegister,
    @required this.sourceOrdestinationRegister,
  }) : super._();

  @override
  R accept<R, C>(ThumbFormatVisitor<R, C> visitor, [C context]) {
    return visitor.visitLoadOrStoreSignExtendedByteOrHalfword(this, context);
  }

  @override
  Map<String, int> _values() {
    return {
      'h': hBit ? 1 : 0,
      's': sBit ? 1 : 0,
      'o': offsetRegister.value,
      'b': baseRegister.value,
      'd': sourceOrdestinationRegister.value,
    };
  }
}
