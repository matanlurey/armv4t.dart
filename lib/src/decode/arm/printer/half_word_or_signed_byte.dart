part of '../printer.dart';

/// Encapsulates code to print instructions that use addressing mode 3.
mixin ArmLoadAndStoreHalfWordOrLoadSignedByte {
  /// Converts and [offset] into an assembler string.
  String _addressingMode3(
    int offset,
    int register, {
    @required int immediateOffset,
    @required int prePostIndexingBit,
    @required int upDownBit,
    @required int writeBackBit,
  }) {
    final sign = upDownBit == 1 ? '+' : '-';
    if (prePostIndexingBit == 0) {
      // POST
      if (immediateOffset == 0) {
        // Post-indexed [Rn], #+/-8bit_Offset
        return '[R$register], #${sign}$offset';
      } else {
        // Post-indexed [Rn], +/-Rm
        return '[R$register], ${sign}$offset';
      }
    } else {
      // PRE
      if (writeBackBit == 0) {
        if (immediateOffset == 0) {
          // Immediate offset [Rn, #+/-8bit_Offset]
          return '[R$register, #${sign}$offset]';
        } else {
          // Register [Rn, +/-Rm]
          return '[R$register, #${sign}R$offset]';
        }
      } else {
        if (immediateOffset == 0) {
          // Pre-indexed [Rn, #+/-8bit_Offset]!
          return '[R$register, #${sign}$offset]!';
        } else {
          // Pre-indexed [Rn, +/-Rm]!
          return '[R$register, #${sign}R$offset]!';
        }
      }
    }
  }
}
