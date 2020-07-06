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
      final format = BranchAndExchangeArmFormat(
        condition: _always,
        operand: Uint4(8),
      );
      expect(decode(encode(format)), 'bx r8');
    });
  });

  group('Branch and Link', () {
    test('B', () async {
      final format = BranchArmFormat(
        condition: _always,
        link: false,
        offset: Uint24(4096),
      );
      expect(decode(encode(format)), 'b 4096');
    });

    test('BL', () async {
      final format = BranchArmFormat(
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
      final noRn = {'mov', 'mvn'};
      for (var i = 0; i < opCodes.length; i++) {
        final key = opCodes[i];
        test('$key', () async {
          final format = DataProcessingOrPsrTransferArmFormat(
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
          } else if (noRn.contains(key)) {
            expect(decode(encode(format)), '$key r3, 4');
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
      final noRn = {'mov', 'mvn'};
      for (var i = 0; i < opCodes.length; i++) {
        final key = opCodes[i];
        test(key, () {
          final format = DataProcessingOrPsrTransferArmFormat(
            condition: _always,
            immediateOperand: true,
            opCode: Uint4(i),
            setConditionCodes: !setS.contains(key),
            operand1Register: Uint4(2),
            destinationRegister: Uint4(3),
            operand2: Uint12(4),
          );
          if (!setS.contains(key)) {
            if (noRn.contains(key)) {
              expect(decode(encode(format)), '${key}s r3, 4');
            } else {
              expect(decode(encode(format)), '${key}s r3, r2, 4');
            }
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
        ].join('').bits;
      }

      int encodeOp2ByImmediate(int shiftV, ShiftType type, int operandR) {
        return [
          '${shiftV.toBinaryPadded(5)}',
          '${type.index.toBinaryPadded(2)}',
          '0',
          '${operandR.toBinaryPadded(4)}',
        ].join('').bits;
      }

      ArmFormat createInstruction(int operand2) {
        return DataProcessingOrPsrTransferArmFormat(
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
      DataProcessingOrPsrTransferArmFormat create({@required bool useSPSR}) {
        return DataProcessingOrPsrTransferArmFormat(
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
      test('Register -> [C]PSR', () {
        final format = DataProcessingOrPsrTransferArmFormat(
          condition: _always,
          immediateOperand: false,
          opCode: Uint4(0x8),
          setConditionCodes: false,
          operand1Register: Uint4(2),
          destinationRegister: Uint4(0),
          operand2: Uint12(2),
        );
        expect(decode(encode(format)), 'msr cpsr, r2');
      });

      test('Register -> [S]PSR', () {
        final format = DataProcessingOrPsrTransferArmFormat(
          condition: _always,
          immediateOperand: false,
          opCode: Uint4(0x9),
          setConditionCodes: false,
          operand1Register: Uint4(2),
          destinationRegister: Uint4(0),
          operand2: Uint12(2),
        );
        expect(decode(encode(format)), 'msr spsr, r2');
      });

      test('Register -> [C]PSR Flag Bits', () {
        final format = DataProcessingOrPsrTransferArmFormat(
          condition: _always,
          immediateOperand: false,
          opCode: Uint4(0x8),
          setConditionCodes: false,
          operand1Register: Uint4('1000'.bits),
          destinationRegister: Uint4(0),
          operand2: Uint12(2),
        );
        expect(decode(encode(format)), 'msr cpsr_flg, r2');
      });

      test('Register -> [S]PSR Flag Bits', () {
        final format = DataProcessingOrPsrTransferArmFormat(
          condition: _always,
          immediateOperand: false,
          opCode: Uint4(0x9),
          setConditionCodes: false,
          operand1Register: Uint4('1000'.bits),
          destinationRegister: Uint4(0),
          operand2: Uint12(2),
        );
        expect(decode(encode(format)), 'msr spsr_flg, r2');
      });

      test('Immediate -> PSR Flag Bits', () {
        final format = DataProcessingOrPsrTransferArmFormat(
          condition: _always,
          immediateOperand: true,
          opCode: Uint4(0x8),
          setConditionCodes: false,
          operand1Register: Uint4('1000'.bits),
          destinationRegister: Uint4(0),
          operand2: Uint12(2),
        );
        expect(decode(encode(format)), 'msr cpsr_flg, 2');
      });
    });
  });

  group('Multiply and Multiply-Accumulate', () {
    test('MUL', () {
      final format = MultiplyArmFormat(
        condition: _always,
        accumulate: false,
        setConditionCodes: false,
        destinationRegister: Uint4(0),
        operandRegister1: Uint4(1),
        operandRegister2: Uint4(2),
        operandRegister3: Uint4(3),
      );
      expect(decode(encode(format)), 'mul r0, r1, r2');
    });

    test('MLA', () {
      final format = MultiplyArmFormat(
        condition: _always,
        accumulate: true,
        setConditionCodes: false,
        destinationRegister: Uint4(0),
        operandRegister1: Uint4(1),
        operandRegister2: Uint4(2),
        operandRegister3: Uint4(3),
      );
      expect(decode(encode(format)), 'mla r0, r1, r2');
    });
  });

  group('Multiply Long and Multiply-Accumulate Long', () {
    test('UMULL', () {
      final format = MultiplyLongArmFormat(
        condition: _always,
        signed: false,
        accumulate: false,
        setConditionCodes: false,
        destinationRegisterHi: Uint4(2),
        destinationRegisterLo: Uint4(4),
        operandRegister1: Uint4(6),
        operandRegister2: Uint4(8),
      );
      expect(decode(encode(format)), 'umull r4, r2, r6, r8');
    });

    test('UMLAL', () {
      final format = MultiplyLongArmFormat(
        condition: _always,
        signed: false,
        accumulate: true,
        setConditionCodes: false,
        destinationRegisterHi: Uint4(2),
        destinationRegisterLo: Uint4(4),
        operandRegister1: Uint4(6),
        operandRegister2: Uint4(8),
      );
      expect(decode(encode(format)), 'umlal r4, r2, r6, r8');
    });

    test('SMULL', () {
      final format = MultiplyLongArmFormat(
        condition: _always,
        signed: true,
        accumulate: false,
        setConditionCodes: false,
        destinationRegisterHi: Uint4(2),
        destinationRegisterLo: Uint4(4),
        operandRegister1: Uint4(6),
        operandRegister2: Uint4(8),
      );
      expect(decode(encode(format)), 'smull r4, r2, r6, r8');
    });

    test('SMLAL', () {
      final format = MultiplyLongArmFormat(
        condition: _always,
        signed: true,
        accumulate: true,
        setConditionCodes: false,
        destinationRegisterHi: Uint4(2),
        destinationRegisterLo: Uint4(4),
        operandRegister1: Uint4(6),
        operandRegister2: Uint4(8),
      );
      expect(decode(encode(format)), 'smlal r4, r2, r6, r8');
    });
  });

  group('Single Data Transfer', () {
    group('STR', () {
      test('Immediate <Address> w/ PC as Base', () {
        final format = SingleDataTransferArmFormat(
          condition: _always,
          immediateOffset: true,
          preIndexingBit: true,
          addOffsetBit: true,
          byteQuantityBit: false,
          writeAddressBit: false,
          loadMemoryBit: false,
          baseRegister: Uint4(15),
          sourceOrDestinationRegister: Uint4(4),
          offset: Uint12(6),
        );
        expect(decode(encode(format)), 'str r4, 6');
      });

      group('Pre-Indexed', () {
        test('offset of zero', () {
          final format = SingleDataTransferArmFormat(
            condition: _always,
            immediateOffset: true,
            preIndexingBit: true,
            addOffsetBit: true,
            byteQuantityBit: false,
            writeAddressBit: false,
            loadMemoryBit: false,
            baseRegister: Uint4(6),
            sourceOrDestinationRegister: Uint4(4),
            offset: Uint12(0),
          );
          expect(decode(encode(format)), 'str r4, [r6]');
        });

        test('offset <expression> bytes', () {
          final format = SingleDataTransferArmFormat(
            condition: _always,
            immediateOffset: true,
            preIndexingBit: true,
            addOffsetBit: true,
            byteQuantityBit: false,
            writeAddressBit: false,
            loadMemoryBit: false,
            baseRegister: Uint4(6),
            sourceOrDestinationRegister: Uint4(4),
            offset: Uint12(8),
          );
          expect(decode(encode(format)), 'str r4, [r6, 8]');
        });

        test('offset <expression> bytes w/ write-back', () {
          final format = SingleDataTransferArmFormat(
            condition: _always,
            immediateOffset: true,
            preIndexingBit: true,
            addOffsetBit: true,
            byteQuantityBit: false,
            writeAddressBit: true,
            loadMemoryBit: false,
            baseRegister: Uint4(6),
            sourceOrDestinationRegister: Uint4(4),
            offset: Uint12(8),
          );
          expect(decode(encode(format)), 'str r4, [r6, 8]!');
        });

        test('offset of + contents, no shift', () {
          final format = SingleDataTransferArmFormat(
            condition: _always,
            immediateOffset: false,
            preIndexingBit: true,
            addOffsetBit: true,
            byteQuantityBit: false,
            writeAddressBit: false,
            loadMemoryBit: false,
            baseRegister: Uint4(6),
            sourceOrDestinationRegister: Uint4(4),
            offset: Uint12(8),
          );
          expect(decode(encode(format)), 'str r4, [r6, r8]');
        });

        test('offset of - contents, no shift', () {
          final format = SingleDataTransferArmFormat(
            condition: _always,
            immediateOffset: false,
            preIndexingBit: true,
            addOffsetBit: false,
            byteQuantityBit: false,
            writeAddressBit: false,
            loadMemoryBit: false,
            baseRegister: Uint4(6),
            sourceOrDestinationRegister: Uint4(4),
            offset: Uint12(8),
          );
          expect(decode(encode(format)), 'str r4, [r6, -r8]');
        });

        test('offset of + contents, shift, w/ write-back', () {
          final format = SingleDataTransferArmFormat(
            condition: _always,
            immediateOffset: false,
            preIndexingBit: true,
            addOffsetBit: true,
            byteQuantityBit: false,
            writeAddressBit: true,
            loadMemoryBit: false,
            baseRegister: Uint4(6),
            sourceOrDestinationRegister: Uint4(4),
            offset: Uint12('0100' '0101' '0111'.bits),
          );
          expect(decode(encode(format)), 'str r4, [r6, r7, asr 8]!');
        });
      });

      group('Post-Indexed', () {
        test('offset <expression> bytes', () {
          final format = SingleDataTransferArmFormat(
            condition: _always,
            immediateOffset: true,
            preIndexingBit: false,
            addOffsetBit: true,
            byteQuantityBit: false,
            writeAddressBit: false,
            loadMemoryBit: false,
            baseRegister: Uint4(6),
            sourceOrDestinationRegister: Uint4(4),
            offset: Uint12(8),
          );
          expect(decode(encode(format)), 'str r4, [r6], 8');
        });

        test('offset <expression> bytes with non-privileged mode', () {
          final format = SingleDataTransferArmFormat(
            condition: _always,
            immediateOffset: true,
            preIndexingBit: false,
            addOffsetBit: true,
            byteQuantityBit: false,
            writeAddressBit: true,
            loadMemoryBit: false,
            baseRegister: Uint4(6),
            sourceOrDestinationRegister: Uint4(4),
            offset: Uint12(8),
          );
          expect(decode(encode(format)), 'strt r4, [r6], 8');
        });

        test('offset of - contents', () {
          final format = SingleDataTransferArmFormat(
            condition: _always,
            immediateOffset: true,
            preIndexingBit: false,
            addOffsetBit: false,
            byteQuantityBit: false,
            writeAddressBit: false,
            loadMemoryBit: false,
            baseRegister: Uint4(6),
            sourceOrDestinationRegister: Uint4(4),
            offset: Uint12(8),
          );
          expect(decode(encode(format)), 'str r4, [r6], -8');
        });

        test('offset of + contents with shift', () {
          final format = SingleDataTransferArmFormat(
            condition: _always,
            immediateOffset: false,
            preIndexingBit: false,
            addOffsetBit: true,
            byteQuantityBit: false,
            writeAddressBit: false,
            loadMemoryBit: false,
            baseRegister: Uint4(6),
            sourceOrDestinationRegister: Uint4(4),
            offset: Uint12('0100' '0101' '0111'.bits),
          );
          expect(decode(encode(format)), 'str r4, [r6], r7, asr 8');
        });
      });
    });

    group('LDR', () {
      // Most of the serious test cases are handled by STR.
      test('expression w/ byte transfer', () {
        final format = SingleDataTransferArmFormat(
          condition: _always,
          immediateOffset: true,
          preIndexingBit: true,
          addOffsetBit: true,
          byteQuantityBit: true,
          writeAddressBit: false,
          loadMemoryBit: false,
          baseRegister: Uint4(15),
          sourceOrDestinationRegister: Uint4(4),
          offset: Uint12(6),
        );
        expect(decode(encode(format)), 'strb r4, 6');
      });
    });
  });

  group('Halfword Data Transfer', () {
    group('LDRH', () {
      ArmFormat createLDRH({
        bool preIndexingBit = false,
        bool addOffsetBit = true,
        bool immediateOffset = false,
        bool writeAddressBit = false,
        bool loadMemoryBit = true,
        int baseRegister = 1,
        int immediateHiBits = 2,
        int immediateLoBits = 4,
        @required int opCode,
      }) {
        return HalfwordDataTransferArmFormat(
          condition: _always,
          preIndexingBit: preIndexingBit,
          addOffsetBit: addOffsetBit,
          immediateOffset: immediateOffset,
          writeAddressBit: writeAddressBit,
          loadMemoryBit: loadMemoryBit,
          baseRegister: Uint4(baseRegister),
          sourceOrDestinationRegister: Uint4(2),
          offsetHiNibble: immediateOffset ? Uint4(immediateHiBits) : Uint4(0),
          opCode: Uint2(opCode),
          offsetLoNibble: Uint4(immediateLoBits),
        );
      }

      test('<Immediate Offset>', () {
        final format = createLDRH(
          preIndexingBit: true,
          immediateOffset: true,
          baseRegister: 15,
          opCode: 0x1,
        );
        expect(decode(encode(format)), 'ldrh r2, 36');
      });

      group('Pre-indexed', () {
        test('<Offset of 0>', () {
          final format = createLDRH(
            preIndexingBit: true,
            immediateOffset: true,
            baseRegister: 4,
            opCode: 0x1,
            immediateHiBits: 0,
            immediateLoBits: 0,
          );
          expect(decode(encode(format)), 'ldrh r2, [r4]');
        });

        test('Offset of <Expression> Bytes', () {
          final format = createLDRH(
            preIndexingBit: true,
            immediateOffset: true,
            baseRegister: 4,
            opCode: 0x1,
            immediateHiBits: 0,
            immediateLoBits: 8,
          );
          expect(decode(encode(format)), 'ldrh r2, [r4, 8]');
        });

        test('Offset of <Expression> Bytes w/ Write-Back', () {
          final format = createLDRH(
            preIndexingBit: true,
            immediateOffset: true,
            baseRegister: 4,
            opCode: 0x1,
            writeAddressBit: true,
            immediateHiBits: 0,
            immediateLoBits: 8,
          );
          expect(decode(encode(format)), 'ldrh r2, [r4, 8]!');
        });

        test('Offset of + Contents of Index Register', () {
          final format = createLDRH(
            preIndexingBit: true,
            immediateOffset: false,
            baseRegister: 4,
            opCode: 0x1,
            immediateHiBits: 0,
            immediateLoBits: 6,
          );
          expect(decode(encode(format)), 'ldrh r2, [r4, r6]');
        });
      });

      group('Post-indexed', () {
        test('Offset of <Expression> Bytes', () {
          final format = createLDRH(
            preIndexingBit: false,
            immediateOffset: true,
            baseRegister: 4,
            opCode: 0x1,
            immediateHiBits: 0,
            immediateLoBits: 8,
          );
          expect(decode(encode(format)), 'ldrh r2, [r4], 8');
        });

        test('Offset of - Contents of Index Register', () {
          final format = createLDRH(
            preIndexingBit: false,
            immediateOffset: false,
            addOffsetBit: false,
            baseRegister: 4,
            opCode: 0x1,
            immediateHiBits: 0,
            immediateLoBits: 6,
          );
          expect(decode(encode(format)), 'ldrh r2, [r4], -r6');
        });
      });
    });

    test('STRH', () {
      final format = HalfwordDataTransferArmFormat(
        condition: _always,
        preIndexingBit: true,
        addOffsetBit: true,
        immediateOffset: true,
        writeAddressBit: false,
        loadMemoryBit: false,
        baseRegister: Uint4(15),
        sourceOrDestinationRegister: Uint4(2),
        offsetHiNibble: Uint4(6),
        opCode: Uint2(0x0),
        offsetLoNibble: Uint4(6),
      );
      expect(decode(encode(format)), 'strh r2, 102');
    });

    test('LDRSB', () {
      final format = HalfwordDataTransferArmFormat(
        condition: _always,
        preIndexingBit: true,
        addOffsetBit: true,
        immediateOffset: true,
        writeAddressBit: false,
        loadMemoryBit: true,
        baseRegister: Uint4(15),
        sourceOrDestinationRegister: Uint4(2),
        offsetHiNibble: Uint4(6),
        opCode: Uint2(0x2),
        offsetLoNibble: Uint4(6),
      );
      expect(decode(encode(format)), 'ldrsb r2, 102');
    });

    test('LDRSH', () {
      final format = HalfwordDataTransferArmFormat(
        condition: _always,
        preIndexingBit: true,
        addOffsetBit: true,
        immediateOffset: true,
        writeAddressBit: false,
        loadMemoryBit: true,
        baseRegister: Uint4(15),
        sourceOrDestinationRegister: Uint4(2),
        offsetHiNibble: Uint4(6),
        opCode: Uint2(0x3),
        offsetLoNibble: Uint4(6),
      );
      expect(decode(encode(format)), 'ldrsh r2, 102');
    });
  });

  group('Block Data Transfer', () {
    group('LDM', () {
      ArmFormat createLDM({
        @required bool preIndexingBit,
        @required bool addOffsetBit,
      }) {
        return BlockDataTransferArmFormat(
          condition: _always,
          preIndexingBit: preIndexingBit,
          addOffsetBit: addOffsetBit,
          loadPsrOrForceUserMode: false,
          writeAddressBit: false,
          loadMemoryBit: true,
          baseRegister: Uint4(4),
          registerList: Uint16(32),
        );
      }

      test('IB', () {
        expect(
          decode(encode(createLDM(preIndexingBit: true, addOffsetBit: true))),
          'ldmib r4, {r5}',
        );
      });

      test('IA', () {
        expect(
          decode(encode(createLDM(preIndexingBit: false, addOffsetBit: true))),
          'ldmia r4, {r5}',
        );
      });

      test('DB', () {
        expect(
          decode(encode(createLDM(preIndexingBit: true, addOffsetBit: false))),
          'ldmdb r4, {r5}',
        );
      });

      test('DA', () {
        expect(
          decode(encode(createLDM(preIndexingBit: false, addOffsetBit: false))),
          'ldmda r4, {r5}',
        );
      });
    });

    group('STM', () {
      ArmFormat createSTM({
        bool loadPsrOrForceUserMode = false,
        bool writeAddressBit = false,
        int registerList = 32,
      }) {
        return BlockDataTransferArmFormat(
          condition: _always,
          preIndexingBit: true,
          addOffsetBit: true,
          loadPsrOrForceUserMode: loadPsrOrForceUserMode,
          writeAddressBit: writeAddressBit,
          loadMemoryBit: false,
          baseRegister: Uint4(4),
          registerList: Uint16(registerList),
        );
      }

      test('w/ Write-Back', () {
        expect(
          decode(encode(createSTM(writeAddressBit: true))),
          'stmib r4!, {r5}',
        );
      });

      test('w/ Set S Bit', () {
        expect(
          decode(encode(createSTM(loadPsrOrForceUserMode: true))),
          'stmib r4, {r5}^',
        );
      });

      test('Register Range', () {
        expect(
          decode(encode(createSTM(
            registerList: '0000' '0011' '0100' '1011'.bits,
          ))),
          'stmib r4, {r0-r1, r3, r6, r8-r9}',
        );
      });
    });
  });

  group('Single Data Swap', () {
    ArmFormat createSWP({bool swapByteQuantity = false}) {
      return SingleDataSwapArmFormat(
        condition: _always,
        swapByteQuantity: swapByteQuantity,
        baseRegister: Uint4(2),
        destinationRegister: Uint4(4),
        sourceRegister: Uint4(6),
      );
    }

    test('SWP', () {
      expect(
        decode(encode(createSWP())),
        'swp r4, r6, [r2]',
      );
    });

    test('SWPB', () {
      expect(
        decode(encode(createSWP(swapByteQuantity: true))),
        'swpb r4, r6, [r2]',
      );
    });
  });

  group('Software Interrupt', () {
    test('SWI', () {
      final format = SoftwareInterruptArmFormat(
        condition: _always,
        comment: Uint24(1024),
      );
      expect(decode(encode(format)), 'swi 1024');
    });
  });
}
