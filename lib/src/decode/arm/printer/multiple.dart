part of '../printer.dart';

/// Encapsualtes code to print block data transfers (`LDM`, `STM`).
mixin ArmLoadAndStoreMultiplePrintHelper {
  static const _incrementBefore = 'IB';
  static const _incrementAfter = 'IA';
  static const _decrementBefore = 'DB';
  static const _decrementAfter = 'DA';

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
      // P = 0 (POST)
      if (upDownBit == 0) {
        // U = 0 (DOWN)
        return _incrementBefore;
      } else {
        // U = 1 (UP)
        return _incrementAfter;
      }
    } else {
      // P = 1 (PRE)
      if (upDownBit == 0) {
        // U = 0 (DOWN)
        return _decrementBefore;
      } else {
        // U = 1 (UP)
        return _decrementAfter;
      }
    }
  }
}
