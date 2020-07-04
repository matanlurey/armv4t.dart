@TestOn('vm')
library armv4t.test.decoder.arm.output_test;

import 'package:armv4t/src/common/binary.dart';
import 'package:armv4t/src/decoder/arm/condition.dart';
import 'package:armv4t/src/decoder/arm/format.dart';
import 'package:armv4t/src/decoder/arm/instruction.dart';
import 'package:armv4t/src/decoder/arm/printer.dart';
import 'package:binary/binary.dart';
import 'package:goldenrod/goldenrod.dart';
import 'package:path/path.dart' as path;
import 'package:test/test.dart';

final _always = Uint4(Condition.al.value);

void main() {
  ArmFormatDecoder formatDecoder;
  ArmFormatEncoder formatEncoder;
  ArmInstructionDecoder decoder;
  ArmInstructionPrinter printer;

  setUpAll(() {
    formatDecoder = const ArmFormatDecoder();
    formatEncoder = const ArmFormatEncoder();
    decoder = const ArmInstructionDecoder();
    printer = const ArmInstructionPrinter();
  });

  Uint32 encode(ArmFormat format) {
    return formatEncoder.convert(format);
  }

  String decode(Uint32 instruction) {
    final format = formatDecoder.convert(instruction);
    final output = format.accept(decoder).accept(printer);
    return '$output ; 0x${instruction.value.toRadixString(16)}';
  }

  group('Branch and Exchange', () {
    final file = path.join(
      'test',
      'decoder',
      'arm',
      'output',
      'branch_and_exchange.json',
    );
    test('BX', () async {
      final format = BranchAndExchange(
        condition: _always,
        operand: Uint4(8),
      );
      expect(
        decode(encode(format)),
        await matchesGoldenKey(key: 'BX', file: file),
      );
    });
  });

  group('Branch and Link', () {
    final file = path.join(
      'test',
      'decoder',
      'arm',
      'output',
      'branch_and_link.json',
    );

    test('B', () async {
      final format = Branch(
        condition: _always,
        link: false,
        offset: Uint24(4096),
      );
      expect(
        decode(encode(format)),
        await matchesGoldenKey(key: 'B', file: file),
      );
    });

    test('BL', () async {
      final format = Branch(
        condition: _always,
        link: true,
        offset: Uint24(4096),
      );
      expect(
        decode(encode(format)),
        await matchesGoldenKey(key: 'BL', file: file),
      );
    });
  });

  group('Data Processing', () {
    final file = path.join(
      'test',
      'decoder',
      'arm',
      'output',
      'data_processing.json',
    );

    group('AND -> MVN <Immediate>', () {
      final opCodes = [
        'AND',
        'EOR',
        'SUB',
        'RSB',
        'ADD',
        'ADC',
        'SBC',
        'RSC',
        'TST',
        'TEQ',
        'CMP',
        'CMN',
        'ORR',
        'MOV',
        'BIC',
        'MVN',
      ];
      final setS = {'TST', 'TEQ', 'CMP', 'CMN'};
      for (var i = 0; i < opCodes.length; i++) {
        final key = opCodes[i];
        test('$key', () async {
          final format = DataProcessingOrPsrTransfer(
            condition: _always,
            immediateOperand: true,
            opCode: Uint4(i),
            setConditionCodes: setS.contains(key),
            operand1Register: Uint4(2),
            destinationRegister: Uint4(3),
            operand2: Uint12(4),
          );
          expect(
            decode(encode(format)),
            await matchesGoldenKey(key: key, file: file),
          );
        });
      }
    });

    group('AND <Shifted Register>', () {
      ShiftType.values.forEach((shiftType) {
        test('$shiftType', () async {
          final key = 'AND.Register:$shiftType';
          final format = DataProcessingOrPsrTransfer(
            condition: _always,
            immediateOperand: false,
            opCode: Uint4(0),
            setConditionCodes: false,
            operand1Register: Uint4(2),
            destinationRegister: Uint4(3),
            // TODO: Fix and/or finish.
            operand2: Uint12(0),
          );
          expect(
            decode(encode(format)),
            await matchesGoldenKey(key: key, file: file),
          );
        });
      });
    });
  });
}
