import 'package:armv4t/src/decode/arm/condition.dart';
import 'package:armv4t/src/decode/arm/format.dart';
import 'package:armv4t/src/decode/arm/instruction.dart';
import 'package:armv4t/src/decode/arm/printer.dart';
import 'package:binary/binary.dart';
import 'package:test/test.dart';

/// Encodes an `ARM`-encoded 32-bit instruction.
int encode(List<String> bits, {Condition condition = Condition.AL}) {
  var result = bits.join('');
  if (result.length < 32) {
    result = '${condition.index.toBinaryPadded(4)}$result';
  }
  return result.parseBits();
}

/// Decodes an `ARM`-encoded 32-bit instruction.
ArmInstruction decode(int bits) {
  final pattern = ArmInstructionSet.allFormats.match(bits);
  final format = ArmInstructionSet.mapDecoders[pattern];
  return format.decodeBits(bits).accept(const ArmDecoder());
}

/// Returns a matcher that matches the printed output [asm].
Matcher matchesASM(String asm) => _ArmAssemblyMatcher(asm);

class _ArmAssemblyMatcher extends Matcher {
  final String _assembly;

  const _ArmAssemblyMatcher(this._assembly);

  @override
  Description describe(Description description) {
    return description.add(_assembly);
  }

  @override
  bool matches(Object describe, Map<Object, Object> matchState) {
    if (describe is ArmInstruction) {
      final matcher = equals(_assembly);
      final result = describe.accept(const ArmInstructionPrinter());
      return matcher.matches(result, matchState);
    } else {
      return false;
    }
  }
}
