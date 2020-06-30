part of '../printer.dart';

/// Encapsulates code to print coprocessor data transfers (`LDC`, `STC`).
mixin ArmLoadAndStoreCoprocessorPrintHelper {
  /// Converts an [offset] into an assembler string.
  ///
  /// [offset], or _addressing mode 5_ as specified in ARM, can be:
  ///
  /// 1. An expression which generates an address: `<expression>`.
  ///    The assembler will attempt to generate an instruction using the program
  ///    counter (`PC`) as a base and a corrected immediate offset to address
  ///    the location by evaluating the expression. This will be a PC-relative,
  ///    pre-indexed address. If the address is out of range, and error will be
  ///    generated.
  ///
  ///    Format: `[Rn, #+/-(8bit_Offset*4)]`
  ///
  /// 2. A pre-indexed addressing specification:
  ///    - `[Rn]`: Offset of zero.
  ///    - `[Rn, <#expression>]{!}`: Offset of `<expression>` bytes.
  ///
  ///    Format: `[Rn, #+/-(8bit_Offset*4)]!`
  ///
  /// 3. A post-indexed addressing specification:
  ///   - `[Rn], <#expression>`: Offset of `<expression>` bytes.
  ///
  ///   Format: `[Rn], #+/-(8bit_Offset*4)`
  ///
  /// > NOTE: If `Rn` is `R15`, the assembler will subtract 8 from the offset
  /// > value to allow for ARM7TDI pipelining.
  String _addressingMode5(
    int offset,
    int register, {
    @required int prePostIndexingBit,
    @required int upDownBit,
    @required int writeBackBit,
  }) {
    final prefix = '${upDownBit == 0 ? '-' : '+'}';
    if (prePostIndexingBit == 0) {
      if (writeBackBit == 0) {
        // 1: [Rn, #+/-(Offset)]
        return '[r$register, $prefix$offset]';
      } else {
        // 2: [Rn, #+/-(8bit_Offset*4)]!
        return '[r$register, $prefix$offset]!';
      }
    } else {
      // 3: [Rn], #+/-(8bit_Offset*4)
      assert(writeBackBit == 0);
      return '[r$register], $prefix$offset';
    }
  }
}
