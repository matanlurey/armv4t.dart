import 'package:armv4t/src/common/binary.dart';
import 'package:armv4t/src/decoder/arm/condition.dart';
import 'package:armv4t/src/decoder/arm/format.dart';
import 'package:armv4t/src/decoder/arm/instruction.dart';
import 'package:armv4t/src/decoder/arm/printer.dart';
import 'package:binary/binary.dart';
import 'package:meta/meta.dart';
import 'package:test/test.dart';

final _always = Uint4(Condition.al.value);

void main() {
  const formatDecoder = ArmFormatDecoder();
  const formatEncoder = ArmFormatEncoder();
  const decoder = ArmInstructionDecoder();
  const printer = ArmInstructionPrinter();

  Uint32 encode(ArmFormat format) {
    return formatEncoder.convert(format);
  }

  String decode(Uint32 instruction) {
    final format = formatDecoder.convert(instruction);
    return format.accept(decoder).accept(printer);
  }

  group('Branch and Exchange', () {
    test('BX', () async {
      final format = BranchAndExchange(
        condition: _always,
        operand: Uint4(8),
      );
      expect(decode(encode(format)), 'bx r8');
    });
  });

  group('Branch and Link', () {
    test('B', () async {
      final format = Branch(
        condition: _always,
        link: false,
        offset: Uint24(4096),
      );
      expect(decode(encode(format)), 'b 4096');
    });

    test('BL', () async {
      final format = Branch(
        condition: _always,
        link: true,
        offset: Uint24(4096),
      );
      expect(decode(encode(format)), 'bl 4096');
    });
  });

  group('Data Processing', () {
    group('AND -> MVN <Immediate>', () {
      final opCodes = [
        'and',
        'eor',
        'sub',
        'rsb',
        'add',
        'adc',
        'sbc',
        'rsc',
        'tst',
        'teq',
        'cmp',
        'cmn',
        'orr',
        'mov',
        'bic',
        'mvn',
      ];
      final setS = {'tst', 'teq', 'cmp', 'cmn'};
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
          if (setS.contains(key)) {
            expect(decode(encode(format)), '$key r2, 4');
          } else {
            expect(decode(encode(format)), '$key r3, r2, 4');
          }
        });
      }
    });

    group('<Set Condition Code/Privileged Mode>', () {
      final opCodes = [
        'and',
        'eor',
        'sub',
        'rsb',
        'add',
        'adc',
        'sbc',
        'rsc',
        'tst',
        'teq',
        'cmp',
        'cmn',
        'orr',
        'mov',
        'bic',
        'mvn',
      ];
      final setS = {'tst', 'teq', 'cmp', 'cmn'};
      for (var i = 0; i < opCodes.length; i++) {
        final key = opCodes[i];
        test(key, () {
          final format = DataProcessingOrPsrTransfer(
            condition: _always,
            immediateOperand: true,
            opCode: Uint4(i),
            setConditionCodes: !setS.contains(key),
            operand1Register: Uint4(2),
            destinationRegister: Uint4(3),
            operand2: Uint12(4),
          );
          if (!setS.contains(key)) {
            expect(decode(encode(format)), '${key}s r3, r2, 4');
          } else {
            // TODO: Test for ${key}p.
          }
        });
      }
    });

    group('<Shifted Register>', () {
      int encodeOp2ByRegister(int shiftR, ShiftType type, int operandR) {
        return [
          '${shiftR.toBinaryPadded(4)}',
          '0',
          '${type.index.toBinaryPadded(2)}',
          '1',
          '${operandR.toBinaryPadded(4)}',
        ].join('').parseBits();
      }

      int encodeOp2ByImmediate(int shiftV, ShiftType type, int operandR) {
        return [
          '${shiftV.toBinaryPadded(5)}',
          '${type.index.toBinaryPadded(2)}',
          '0',
          '${operandR.toBinaryPadded(4)}',
        ].join('').parseBits();
      }

      ArmFormat createInstruction(int operand2) {
        return DataProcessingOrPsrTransfer(
          condition: _always,
          immediateOperand: false,
          opCode: Uint4(0),
          setConditionCodes: false,
          operand1Register: Uint4(2),
          destinationRegister: Uint4(3),
          operand2: Uint12(operand2),
        );
      }

      group('(By Immediate)', () {
        test('LSL', () {
          final format = createInstruction(
            encodeOp2ByImmediate(4, ShiftType.LSL, 8),
          );
          expect(decode(encode(format)), 'and r3, r2, r8, lsl 4');
        });

        test('LSR', () {
          final format = createInstruction(
            encodeOp2ByImmediate(4, ShiftType.LSR, 8),
          );
          expect(decode(encode(format)), 'and r3, r2, r8, lsr 4');
        });

        test('ASR', () {
          final format = createInstruction(
            encodeOp2ByImmediate(4, ShiftType.ASR, 8),
          );
          expect(decode(encode(format)), 'and r3, r2, r8, asr 4');
        });

        test('ROR', () {
          final format = createInstruction(
            encodeOp2ByImmediate(4, ShiftType.ROR, 8),
          );
          expect(decode(encode(format)), 'and r3, r2, r8, ror 4');
        });

        test('RRX', () {
          final format = createInstruction(
            encodeOp2ByImmediate(0, ShiftType.ROR, 8),
          );
          expect(decode(encode(format)), 'and r3, r2, r8, rrx');
        });
      });

      group('(By Register)', () {
        test('LSL', () {
          final format = createInstruction(
            encodeOp2ByRegister(4, ShiftType.LSL, 8),
          );
          expect(decode(encode(format)), 'and r3, r2, r8, lsl r4');
        });

        test('LSR', () {
          final format = createInstruction(
            encodeOp2ByRegister(4, ShiftType.LSR, 8),
          );
          expect(decode(encode(format)), 'and r3, r2, r8, lsr r4');
        });

        test('ASR', () {
          final format = createInstruction(
            encodeOp2ByRegister(4, ShiftType.ASR, 8),
          );
          expect(decode(encode(format)), 'and r3, r2, r8, asr r4');
        });

        test('ROR', () {
          final format = createInstruction(
            encodeOp2ByRegister(4, ShiftType.ROR, 8),
          );
          expect(decode(encode(format)), 'and r3, r2, r8, ror r4');
        });
      });
    });
  });

  group('PSR Transfer', () {
    group('MRS', () {
      DataProcessingOrPsrTransfer create({@required bool useSPSR}) {
        return DataProcessingOrPsrTransfer(
          condition: _always,
          immediateOperand: true,
          opCode: Uint4(useSPSR ? 0xa : 0xb),
          setConditionCodes: false,
          operand1Register: Uint4(2),
          destinationRegister: Uint4(3),
          operand2: Uint12(0),
        );
      }

      test('SPSR', () {
        expect(decode(encode(create(useSPSR: true))), 'mrs r3, cpsr');
      });

      test('CPSR', () {
        expect(decode(encode(create(useSPSR: false))), 'mrs r3, spsr');
      });
    });

    group('MSR', () {
      test('Register -> PSR', () {
        final format = DataProcessingOrPsrTransfer(
          condition: _always,
          immediateOperand: true,
          opCode: Uint4(0x8),
          setConditionCodes: false,
          operand1Register: Uint4(2),
          destinationRegister: Uint4(0),
          operand2: Uint12(0),
        );
        // TODO: Fix.
        expect(decode(encode(format)), 'msr cpsr, r2');
      });

      test('Register or Immediate -> PSR Flag Bits', () {
        final format = DataProcessingOrPsrTransfer(
          condition: _always,
          immediateOperand: true,
          opCode: Uint4(0x8),
          setConditionCodes: false,
          operand1Register: Uint4(2),
          destinationRegister: Uint4(0),
          operand2: Uint12(0),
        );
        // TODO: Fix.
        expect(decode(encode(format)), 'msr cpsr, r2');
      });
    });
  });
}
