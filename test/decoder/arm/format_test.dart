import 'package:armv4t/src/common/binary.dart';
import 'package:armv4t/src/decoder/arm/format.dart';
import 'package:binary/binary.dart';
import 'package:test/test.dart';

void main() {
  ArmFormatDecoder decoder;
  ArmFormatEncoder encoder;
  ArmFormat a;

  setUpAll(() {
    decoder = const ArmFormatDecoder();
    encoder = const ArmFormatEncoder();
  });

  setUp(() {
    a = null;
  });

  tearDown(() {
    if (a == null) {
      return;
    }
    final b = decoder.convert(encoder.convert(a));
    expect(b, a, reason: '${encoder.convert(a).toBinaryPadded()}');
  });

  test('DataProcessingOrPsrTransfer', () {
    a = DataProcessingOrPsrTransfer(
      condition: Uint4('1000'.parseBits()),
      immediateOperand: true,
      opCode: Uint4('1010'.parseBits()),
      setConditionCodes: true,
      operand1Register: Uint4('1100'.parseBits()),
      destinationRegister: Uint4('0011'.parseBits()),
      operand2: Uint12('1100' '0011' '0101'.parseBits()),
    );
  });

  test('Multiply', () {
    a = Multiply(
      condition: Uint4('1000'.parseBits()),
      accumulate: true,
      setConditionCodes: true,
      destinationRegister: Uint4('0011'.parseBits()),
      operandRegister1: Uint4('1100'.parseBits()),
      operandRegister2: Uint4('1010'.parseBits()),
      operandRegister3: Uint4('0101'.parseBits()),
    );
  });

  test('MultiplyLong', () {
    a = MultiplyLong(
      condition: Uint4('1000'.parseBits()),
      signed: true,
      accumulate: true,
      setConditionCodes: true,
      destinationRegisterHi: Uint4('0011'.parseBits()),
      destinationRegisterLo: Uint4('1100'.parseBits()),
      operandRegister1: Uint4('1100'.parseBits()),
      operandRegister2: Uint4('0101'.parseBits()),
    );
  });

  test('SingleDataSwap', () {
    a = SingleDataSwap(
      condition: Uint4('1000'.parseBits()),
      swapByteQuantity: true,
      baseRegister: Uint4('1100'.parseBits()),
      destinationRegister: Uint4('0011'.parseBits()),
      sourceRegister: Uint4('0101'.parseBits()),
    );
  });

  test('BranchAndExchange', () {
    a = BranchAndExchange(
      condition: Uint4('1000'.parseBits()),
      operand: Uint4('0101'.parseBits()),
    );
  });

  test('HalfwordDataTransfer', () {
    a = HalfwordDataTransfer(
      condition: Uint4('1000'.parseBits()),
      preIndexingBit: true,
      addOffsetBit: true,
      immediateOffset: true,
      writeAddressBit: true,
      loadMemoryBit: true,
      baseRegister: Uint4('1100'.parseBits()),
      sourceOrDestinationRegister: Uint4('0011'.parseBits()),
      offsetHiNibble: Uint4('0101'.parseBits()),
      opCode: Uint2('10'.parseBits()),
      offsetLoNibble: Uint4('1010'.parseBits()),
    );
  });

  test('SingleDataTransfer', () {
    a = SingleDataTransfer(
      condition: Uint4('1000'.parseBits()),
      immediateOffset: true,
      preIndexingBit: true,
      addOffsetBit: true,
      byteQuantityBit: true,
      writeAddressBit: true,
      loadMemoryBit: true,
      baseRegister: Uint4('1100'.parseBits()),
      sourceOrDestinationRegister: Uint4('0011'.parseBits()),
      offset: Uint12('1010' '0101' '1100'.parseBits()),
    );
  });

  test('BlockDataTransfer', () {
    a = BlockDataTransfer(
      condition: Uint4('1000'.parseBits()),
      preIndexingBit: true,
      addOffsetBit: true,
      loadPsrOrForceUserMode: true,
      writeAddressBit: true,
      loadMemoryBit: true,
      baseRegister: Uint4('0011'.parseBits()),
      registerList: Uint16('0000' '1010' '0101' '1100'.parseBits()),
    );
  });

  test('Branch', () {
    a = Branch(
      condition: Uint4('1000'.parseBits()),
      link: true,
      offset: Uint24('0000' '1010' '0101' '1100'.parseBits()),
    );
  });

  test('SoftwareInterrupt', () {
    a = SoftwareInterrupt(
      condition: Uint4('1000'.parseBits()),
      comment: Uint24('0000' '1010' '0101' '1100'.parseBits()),
    );
  });
}
