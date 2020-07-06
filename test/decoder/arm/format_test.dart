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
    a = DataProcessingOrPsrTransferArmFormat(
      condition: Uint4('1000'.bits),
      immediateOperand: true,
      opCode: Uint4('1010'.bits),
      setConditionCodes: true,
      operand1Register: Uint4('1100'.bits),
      destinationRegister: Uint4('0011'.bits),
      operand2: Uint12('1100' '0011' '0101'.bits),
    );
  });

  test('Multiply', () {
    a = MultiplyArmFormat(
      condition: Uint4('1000'.bits),
      accumulate: true,
      setConditionCodes: true,
      destinationRegister: Uint4('0011'.bits),
      operandRegister1: Uint4('1100'.bits),
      operandRegister2: Uint4('1010'.bits),
      operandRegister3: Uint4('0101'.bits),
    );
  });

  test('MultiplyLong', () {
    a = MultiplyLongArmFormat(
      condition: Uint4('1000'.bits),
      signed: true,
      accumulate: true,
      setConditionCodes: true,
      destinationRegisterHi: Uint4('0011'.bits),
      destinationRegisterLo: Uint4('1100'.bits),
      operandRegister1: Uint4('1100'.bits),
      operandRegister2: Uint4('0101'.bits),
    );
  });

  test('SingleDataSwap', () {
    a = SingleDataSwapArmFormat(
      condition: Uint4('1000'.bits),
      swapByteQuantity: true,
      baseRegister: Uint4('1100'.bits),
      destinationRegister: Uint4('0011'.bits),
      sourceRegister: Uint4('0101'.bits),
    );
  });

  test('BranchAndExchange', () {
    a = BranchAndExchangeArmFormat(
      condition: Uint4('1000'.bits),
      operand: Uint4('0101'.bits),
    );
  });

  test('HalfwordDataTransfer', () {
    a = HalfwordDataTransferArmFormat(
      condition: Uint4('1000'.bits),
      preIndexingBit: true,
      addOffsetBit: true,
      immediateOffset: true,
      writeAddressBit: true,
      loadMemoryBit: true,
      baseRegister: Uint4('1100'.bits),
      sourceOrDestinationRegister: Uint4('0011'.bits),
      offsetHiNibble: Uint4('0101'.bits),
      opCode: Uint2('10'.bits),
      offsetLoNibble: Uint4('1010'.bits),
    );
  });

  test('SingleDataTransfer', () {
    a = SingleDataTransferArmFormat(
      condition: Uint4('1000'.bits),
      immediateOffset: true,
      preIndexingBit: true,
      addOffsetBit: true,
      byteQuantityBit: true,
      writeAddressBit: true,
      loadMemoryBit: true,
      baseRegister: Uint4('1100'.bits),
      sourceOrDestinationRegister: Uint4('0011'.bits),
      offset: Uint12('1010' '0101' '1100'.bits),
    );
  });

  test('BlockDataTransfer', () {
    a = BlockDataTransferArmFormat(
      condition: Uint4('1000'.bits),
      preIndexingBit: true,
      addOffsetBit: true,
      loadPsrOrForceUserMode: true,
      writeAddressBit: true,
      loadMemoryBit: true,
      baseRegister: Uint4('0011'.bits),
      registerList: Uint16('0000' '1010' '0101' '1100'.bits),
    );
  });

  test('Branch', () {
    a = BranchArmFormat(
      condition: Uint4('1000'.bits),
      link: true,
      offset: Uint24('0000' '1010' '0101' '1100'.bits),
    );
  });

  test('SoftwareInterrupt', () {
    a = SoftwareInterruptArmFormat(
      condition: Uint4('1000'.bits),
      comment: Uint24('0000' '1010' '0101' '1100'.bits),
    );
  });
}
