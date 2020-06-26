import 'package:armv4t/src/decode/arm/format.dart';
import 'package:armv4t/src/decode/arm/instruction.dart';
import 'package:armv4t/src/decode/arm/printer.dart';
import 'package:binary/binary.dart';
import 'package:test/test.dart';

void main() {
  final visitor = ArmDecoder();

  ArmInstruction decode(int bits) {
    final pattern = ArmInstructionSet.allFormats.match(bits);
    final format = ArmInstructionSet.mapDecoders[pattern];
    return format.decodeBits(bits).accept(visitor);
  }

  group('Data processing or PSR transfer: should decode', () {
    // TODO: Test.
  });

  group('Multiply: should decode', () {
    // TODO: Test.
  });

  group('Multiply long: should decode', () {
    // TODO: Test.
  });

  group('Single data swap: should decode', () {
    // TODO: Test.
  });

  group('Branch and exchange: should decode', () {
    // TODO: Test.
  });

  group('Halfword data transfer register offset: should decode', () {
    // TODO: Test.
  });

  group('Halfword data transfer immediate offset: should decode', () {
    // TODO: Test.
  });

  group('Single data transfer: should decode', () {
    // TODO: Test.
  });

  group('Block data transfer: should decode', () {
    // TODO: Test.
  });

  group('Branch: should decode', () {
    // TODO: Test.
  });

  group('Coprocessor data transfer: should decode', () {
    // TODO: Test.
  });

  group('Coprocessor data operation: should decode', () {
    // TODO: Test.
  });

  group('Coprocessor regsiter transfer: should decode', () {
    // TODO: Test.
  });

  group('Software interrupt: should decode', () {
    // TODO: Test.
  });
}

const _printer = ArmInstructionPrinter();

Matcher _matchesASM(String asm) => _ArmAssemblyMatcher(asm);

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
      final result = describe.accept(_printer);
      return matcher.matches(result, matchState);
    } else {
      return false;
    }
  }
}
