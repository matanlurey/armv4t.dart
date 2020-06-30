part of '../printer.dart';

/// Encapsualtes code to print block data transfers (`LDM`, `STM`).
mixin ArmLoadAndStoreMultiplePrintHelper {
  static const _incrementBefore = 'ib';
  static const _incrementAfter = 'ia';
  static const _decrementBefore = 'db';
  static const _decrementAfter = 'da';

  /// Converts the provided bits into an assembler string mnemonic.
  ///
  /// ```
  /// STM{cond}<a_mode4L> Rd{!}, <reglist>^
  ///          ^^^^^^^^^^
  /// ```
  ///
  /// Addressing mode `4L` uses the non-stack mnemonics.
  String _addressingMode4L({
    @required int prePostIndexingBit,
    @required int upDownBit,
  }) {
    if (prePostIndexingBit == 0) {
      // P = 0
      if (upDownBit == 0) {
        // U = 0
        // DA
        return _decrementAfter;
      } else {
        // U = 1
        // IA
        return _incrementAfter;
      }
    } else {
      // P = 1
      if (upDownBit == 0) {
        // U = 0
        // DB
        return _decrementBefore;
      } else {
        // U = 1
        // IB
        return _incrementBefore;
      }
    }
  }
}
