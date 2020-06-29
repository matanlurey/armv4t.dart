part of '../printer.dart';

/// Encapsulates code to print instructions that use addressing mode 2.
mixin ArmLoadAndStoreWordOrUnsignedBytePrintHelper {
  /// Provide a way to encode a shifter operand.
  @visibleForOverriding
  String _shifterOperand(int immediate, int bits);

  /// Converts and [offset] into an assembler string.
  String _addressingMode2(
    int offset,
    int register, {
    @required int immediateOffset,
    @required int prePostIndexingBit,
    @required int upDownBit,
    @required int writeBackBit,
  }) {
    if (prePostIndexingBit == 0) {
      return _addressingMode2$PostIndexedOffset(
        offset,
        register,
        immediateOffset: immediateOffset,
        upDownBit: upDownBit,
      );
    } else {
      // PRE.
      if (writeBackBit == 0) {
        return _addressingMode2$ImmediateOffset(
          offset,
          register,
          immediateOffset: immediateOffset,
          upDownBit: upDownBit,
        );
      } else {
        return _addressingMode2$PreIndexedOffset(
          offset,
          register,
          immediateOffset: immediateOffset,
          upDownBit: upDownBit,
        );
      }
    }
  }

  String _addressingMode2$ImmediateOffset(
    int offset,
    int register, {
    @required int immediateOffset,
    @required int upDownBit,
  }) {
    var result = '[R$register, ';
    if (upDownBit == 0) {
      result = '$result-';
    } else {
      result = '$result+';
    }
    return '$result${_shifterOperand(immediateOffset, offset)}]';
  }

  String _addressingMode2$PreIndexedOffset(
    int offset,
    int register, {
    @required int immediateOffset,
    @required int upDownBit,
  }) {
    final result = _addressingMode2$ImmediateOffset(
      offset,
      register,
      immediateOffset: immediateOffset,
      upDownBit: upDownBit,
    );
    return '$result!';
  }

  String _addressingMode2$PostIndexedOffset(
    int offset,
    int register, {
    @required int immediateOffset,
    @required int upDownBit,
  }) {
    final op = _shifterOperand(immediateOffset, offset);
    if (op.endsWith('RRX')) {
      return _addressingMode2$PostIndexedOffset$RRX(
        register,
        op,
        upDownBit: upDownBit,
      );
    } else {
      var result = '[R$register], ';
      if (upDownBit == 0) {
        result = '$result-';
      } else {
        result = '$result+';
      }
      return '$result$op';
    }
  }

  String _addressingMode2$PostIndexedOffset$RRX(
    int register,
    String offset, {
    @required int upDownBit,
  }) {
    final prefix = upDownBit == 0 ? '-' : '+';
    return '[R$register, $prefix$offset]';
  }
}
