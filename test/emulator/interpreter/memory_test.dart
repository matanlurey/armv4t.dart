import 'package:armv4t/decode.dart';
import 'package:armv4t/src/emulator/interpreter.dart';
import 'package:armv4t/src/emulator/memory.dart';
import 'package:armv4t/src/processor.dart';
import 'package:binary/binary.dart';
import 'package:test/test.dart';

void main() {
  final printer = const ArmInstructionPrinter();

  String decode(ArmInstruction i) => i.accept(printer);

  Arm7Processor cpu;
  ArmInterpreter interpreter;
  Memory memory;

  final r0 = RegisterAny(Uint4(0));
  final r1 = RegisterAny(Uint4(1));

  setUp(() {
    cpu = Arm7Processor();
    memory = Memory(20);
    interpreter = ArmInterpreter(cpu, memory);
  });

  group('Single Data Transfer:', () {
    group('LDR should load', () {
      LDRArmInstruction instruction;

      test('r0 = [r1]: Word', () {
        instruction = LDRArmInstruction(
          condition: Condition.al,
          addOffsetBeforeTransfer: true,
          addOffsetToBase: true,
          writeAddressIntoBaseOrForceNonPrivilegedAccess: false,
          transferByte: false,
          base: r1,
          destination: r0,
          offset: Or2.left(Immediate(Uint12.zero)),
        );
        expect(decode(instruction), 'ldr r0, [r1]');

        // Read memory address 4.
        cpu[1] = Uint32(4);
        memory.storeWord(Uint32(4), Uint32(10240));
        interpreter.execute(instruction);

        expect(cpu[0], Uint32(10240));
      });

      test('r0 = [r1]: Byte', () {
        instruction = LDRArmInstruction(
          condition: Condition.al,
          addOffsetBeforeTransfer: true,
          addOffsetToBase: true,
          writeAddressIntoBaseOrForceNonPrivilegedAccess: false,
          transferByte: true,
          base: r1,
          destination: r0,
          offset: Or2.left(Immediate(Uint12.zero)),
        );
        expect(decode(instruction), 'ldrb r0, [r1]');

        // Read memory address 4.
        cpu[1] = Uint32(4);
        memory.storeByte(Uint32(4), Uint8(255));
        interpreter.execute(instruction);

        expect(cpu[0], Uint32(255));
      });

      test('r0 = [r1 + O]', () {
        instruction = LDRArmInstruction(
          condition: Condition.al,
          addOffsetBeforeTransfer: true,
          addOffsetToBase: true,
          writeAddressIntoBaseOrForceNonPrivilegedAccess: false,
          transferByte: false,
          base: r1,
          destination: r0,
          offset: Or2.left(Immediate(Uint12(3))),
        );
        expect(decode(instruction), 'ldr r0, [r1, 3]');

        // Read memory address 1 + 3.
        cpu[1] = Uint32(1);
        memory.storeWord(Uint32(4), Uint32(10240));
        interpreter.execute(instruction);

        expect(cpu[0], Uint32(10240));
        expect(cpu[1], Uint32(1), reason: 'No write back');
      });

      test('r0 = [r1] + O: Writeback', () {
        instruction = LDRArmInstruction(
          condition: Condition.al,
          addOffsetBeforeTransfer: true,
          addOffsetToBase: true,
          writeAddressIntoBaseOrForceNonPrivilegedAccess: true,
          transferByte: false,
          base: r1,
          destination: r0,
          offset: Or2.left(Immediate(Uint12(3))),
        );
        expect(decode(instruction), 'ldr r0, [r1, 3]!');

        // Read memory address 1 + 3.
        cpu[1] = Uint32(1);
        memory.storeWord(Uint32(4), Uint32(10240));
        interpreter.execute(instruction);

        expect(cpu[0], Uint32(10240));
        expect(cpu[1], Uint32(4), reason: 'Explicit writeback');
      });

      test('r0 = [r1 - O]', () {
        instruction = LDRArmInstruction(
          condition: Condition.al,
          addOffsetBeforeTransfer: true,
          addOffsetToBase: false,
          writeAddressIntoBaseOrForceNonPrivilegedAccess: false,
          transferByte: false,
          base: r1,
          destination: r0,
          offset: Or2.left(Immediate(Uint12(3))),
        );
        expect(decode(instruction), 'ldr r0, [r1, -3]');

        // Read memory address 3 - 3.
        cpu[1] = Uint32(3);
        memory.storeWord(Uint32(0), Uint32(10240));
        interpreter.execute(instruction);

        expect(cpu[0], Uint32(10240));
        expect(cpu[1], Uint32(3));
      });

      test('ro = [r1] + O', () {
        instruction = LDRArmInstruction(
          condition: Condition.al,
          addOffsetBeforeTransfer: false,
          addOffsetToBase: true,
          writeAddressIntoBaseOrForceNonPrivilegedAccess: false,
          transferByte: false,
          base: r1,
          destination: r0,
          offset: Or2.left(Immediate(Uint12(4))),
        );

        // Read memory address 0.
        cpu[1] = Uint32(0);
        memory.storeWord(Uint32(0), Uint32(10240));
        interpreter.execute(instruction);

        expect(cpu[0], Uint32(10240));
        expect(cpu[1], Uint32(4), reason: 'Implicit write back');
      });
    });

    group('STR should store', () {
      STRArmInstruction instruction;

      test('[r0] = r1: Word', () {
        instruction = STRArmInstruction(
          condition: Condition.al,
          addOffsetBeforeTransfer: true,
          addOffsetToBase: true,
          writeAddressIntoBaseOrForceNonPrivilegedAccess: false,
          transferByte: false,
          base: r0,
          destination: r1,
          offset: Or2.left(Immediate(Uint12.zero)),
        );
        expect(decode(instruction), 'str r1, [r0]');

        // Store r1 into memory location 4.
        cpu[0] = Uint32(4);
        cpu[1] = Uint32(10240);
        interpreter.execute(instruction);

        expect(cpu[0], Uint32(4));
        expect(cpu[1], Uint32(10240));
        expect(memory.loadWord(Uint32(4)), Uint32(10240));
      });

      test('[r0] = r1: Byte', () {
        instruction = STRArmInstruction(
          condition: Condition.al,
          addOffsetBeforeTransfer: true,
          addOffsetToBase: true,
          writeAddressIntoBaseOrForceNonPrivilegedAccess: false,
          transferByte: true,
          base: r0,
          destination: r1,
          offset: Or2.left(Immediate(Uint12.zero)),
        );
        expect(decode(instruction), 'strb r1, [r0]');

        // Store r1 into memory location 4.
        cpu[0] = Uint32(4);
        cpu[1] = Uint32(255);
        interpreter.execute(instruction);

        expect(cpu[0], Uint32(4));
        expect(cpu[1], Uint32(255));
        expect(memory.loadByte(Uint32(4)), Uint8(255));
      });

      test('[r0] = r1 + O', () {
        instruction = STRArmInstruction(
          condition: Condition.al,
          addOffsetBeforeTransfer: true,
          addOffsetToBase: true,
          writeAddressIntoBaseOrForceNonPrivilegedAccess: false,
          transferByte: false,
          base: r0,
          destination: r1,
          offset: Or2.left(Immediate(Uint12(3))),
        );
        expect(decode(instruction), 'str r1, [r0, 3]');

        // Store r1 into memory location 1 + 3.
        cpu[0] = Uint32(1);
        cpu[1] = Uint32(10240);
        interpreter.execute(instruction);

        expect(cpu[0], Uint32(1));
        expect(cpu[1], Uint32(10240));
        expect(memory.loadWord(Uint32(4)), Uint32(10240));
      });

      test('[r0] = r1 - O', () {
        instruction = STRArmInstruction(
          condition: Condition.al,
          addOffsetBeforeTransfer: true,
          addOffsetToBase: false,
          writeAddressIntoBaseOrForceNonPrivilegedAccess: false,
          transferByte: false,
          base: r0,
          destination: r1,
          offset: Or2.left(Immediate(Uint12(4))),
        );
        expect(decode(instruction), 'str r1, [r0, -4]');

        // Store r1 into memory location 4 - 4.
        cpu[0] = Uint32(4);
        cpu[1] = Uint32(10240);
        interpreter.execute(instruction);

        expect(cpu[0], Uint32(4));
        expect(cpu[1], Uint32(10240));
        expect(memory.loadWord(Uint32(0)), Uint32(10240));
      });

      test('[r0] = r1 + O', () {
        instruction = STRArmInstruction(
          condition: Condition.al,
          addOffsetBeforeTransfer: false,
          addOffsetToBase: true,
          writeAddressIntoBaseOrForceNonPrivilegedAccess: false,
          transferByte: false,
          base: r0,
          destination: r1,
          offset: Or2.left(Immediate(Uint12(3))),
        );
        expect(decode(instruction), 'str r1, [r0], 3');

        // Store r1 into memory location 4.
        cpu[0] = Uint32(4);
        cpu[1] = Uint32(10240);
        interpreter.execute(instruction);

        expect(cpu[0], Uint32(7), reason: 'Writeback (Implicit)');
        expect(cpu[1], Uint32(10240));
        expect(memory.loadWord(Uint32(4)), Uint32(10240));
      });
    });
  });

  group('Halfword and Signed Data Transfer:', () {
    group('LDRH', () {
      LDRHArmInstruction instruction;

      test('r0 = [r1]', () {
        instruction = LDRHArmInstruction(
          condition: Condition.al,
          addOffsetBeforeTransfer: true,
          addOffsetToBase: true,
          writeAddressIntoBase: false,
          base: r1,
          destination: r0,
          offset: Or2.right(Immediate(Uint8.zero)),
        );
        expect(decode(instruction), 'ldrh r0, [r1]');

        cpu[1] = Uint32(2);
        memory.storeHalfWord(Uint32(2), Uint16(16));
        interpreter.execute(instruction);

        expect(cpu[0], Uint32(16));
      });
    });

    group('LDRSH', () {
      LDRSHArmInstruction instruction;

      test('r0 = [r1]', () {
        instruction = LDRSHArmInstruction(
          condition: Condition.al,
          addOffsetBeforeTransfer: true,
          addOffsetToBase: true,
          writeAddressIntoBase: false,
          base: r1,
          destination: r0,
          offset: Or2.right(Immediate(Uint8.zero)),
        );
        expect(decode(instruction), 'ldrsh r0, [r1]');

        cpu[1] = Uint32(2);
        memory.storeHalfWord(
          Uint32(2),
          Uint16(('1000' '0000' '0000' '0000').bits),
        );
        interpreter.execute(instruction);

        expect(
          cpu[0],
          Uint32(
            ('1111' '1111' '1111' '1111' '1000' '0000' '0000' '0000').bits,
          ),
        );
      });
    });

    group('LDRSB', () {
      LDRSBArmInstruction instruction;

      test('r0 = [r1]', () {
        instruction = LDRSBArmInstruction(
          condition: Condition.al,
          addOffsetBeforeTransfer: true,
          addOffsetToBase: true,
          writeAddressIntoBase: false,
          base: r1,
          destination: r0,
          offset: Or2.right(Immediate(Uint8.zero)),
        );
        expect(decode(instruction), 'ldrsb r0, [r1]');

        cpu[1] = Uint32(2);
        memory.storeByte(
          Uint32(2),
          Uint8(('1000' '0000').bits),
        );
        interpreter.execute(instruction);

        expect(
          cpu[0],
          Uint32(
            ('1111' '1111' '1111' '1111' '1111' '1111' '1000' '0000').bits,
          ),
        );
      });
    });

    group('STRH', () {
      STRHArmInstruction instruction;

      test('[r1] = r0', () {
        instruction = STRHArmInstruction(
          condition: Condition.al,
          addOffsetBeforeTransfer: true,
          addOffsetToBase: true,
          writeAddressIntoBase: false,
          base: r1,
          source: r0,
          offset: Or2.right(Immediate(Uint8.zero)),
        );
        expect(decode(instruction), 'strh r0, [r1]');

        cpu[0] = Uint32(24);
        cpu[1] = Uint32(2);
        interpreter.execute(instruction);

        expect(memory.loadHalfWord(Uint32(2)), Uint16(24));
      });
    });
  });

  group('Block Data Transfer', () {
    group('LDM', () {
      LDMArmInstruction instruction;

      test('r{1-3} = [r0]', () {
        instruction = LDMArmInstruction(
          condition: Condition.al,
          addOffsetBeforeTransfer: true,
          addOffsetToBase: true,
          writeAddressIntoBase: false,
          loadPsr: false,
          base: r0,
          registerList: RegisterList({1, 2, 3}),
        );
        expect(decode(instruction), 'ldmib r0, {r1-r3}');

        memory
          ..storeWord(Uint32(4), Uint32(1))
          ..storeWord(Uint32(8), Uint32(2))
          ..storeWord(Uint32(12), Uint32(3));
        interpreter.execute(instruction);

        expect(cpu[0], Uint32(0), reason: 'No write-back');
        expect(cpu[1], Uint32(1));
        expect(cpu[2], Uint32(2));
        expect(cpu[3], Uint32(3));
      });

      test('r{1-3, 15} = [r0]: Load PSR', () {
        instruction = LDMArmInstruction(
          condition: Condition.al,
          addOffsetBeforeTransfer: true,
          addOffsetToBase: true,
          writeAddressIntoBase: false,
          loadPsr: true,
          base: r0,
          registerList: RegisterList({1, 2, 3, 15}),
        );
        expect(decode(instruction), 'ldmib r0, {r1-r3, r15}^');

        cpu.unsafeSetCpsr(cpu.cpsr.update(mode: ArmOperatingMode.fiq));
        cpu.spsr = cpu.spsr.update(isOverflow: true);
        memory
          ..storeWord(Uint32(4), Uint32(1))
          ..storeWord(Uint32(8), Uint32(2))
          ..storeWord(Uint32(12), Uint32(3))
          ..storeWord(Uint32(16), Uint32(4));
        interpreter.execute(instruction);

        expect(cpu[0], Uint32(0), reason: 'No write-back');
        expect(cpu[1], Uint32(1));
        expect(cpu[2], Uint32(2));
        expect(cpu[3], Uint32(3));
        expect(cpu.programCounter, Uint32(4));
        expect(
          cpu.cpsr,
          StatusRegister().update(
            isOverflow: true,
            mode: ArmOperatingMode.fiq,
          ),
        );
      });

      test('r{1-3} = [r0]: Write-back', () {
        instruction = LDMArmInstruction(
          condition: Condition.al,
          addOffsetBeforeTransfer: true,
          addOffsetToBase: true,
          writeAddressIntoBase: true,
          loadPsr: false,
          base: r0,
          registerList: RegisterList({1, 2, 3}),
        );
        expect(decode(instruction), 'ldmib r0!, {r1-r3}');

        memory
          ..storeWord(Uint32(4), Uint32(1))
          ..storeWord(Uint32(8), Uint32(2))
          ..storeWord(Uint32(12), Uint32(3));
        interpreter.execute(instruction);

        expect(cpu[0], Uint32(12), reason: 'Write-back');
        expect(cpu[1], Uint32(1));
        expect(cpu[2], Uint32(2));
        expect(cpu[3], Uint32(3));
      });
    });

    group('STM', () {
      STMArmInstruction instruction;

      test('[r0...] = {8-10}: User-mode', () {
        instruction = STMArmInstruction(
          condition: Condition.al,
          addOffsetBeforeTransfer: true,
          addOffsetToBase: true,
          writeAddressIntoBase: false,
          forceNonPrivilegedAccess: true,
          base: r0,
          registerList: RegisterList({8, 9, 10}),
        );
        expect(decode(instruction), 'stmib r0, {r8-r10}^');

        cpu.unsafeSetCpsr(cpu.cpsr.update(mode: ArmOperatingMode.fiq));
        cpu
          // Swapped registers (for FIQ).
          ..[8] = Uint32(666)
          ..[9] = Uint32(666)
          ..[10] = Uint32(666)
          // User-mode banked registers.
          ..forceUserModeWrite(8, Uint32(1))
          ..forceUserModeWrite(9, Uint32(2))
          ..forceUserModeWrite(10, Uint32(3));
        interpreter.execute(instruction);

        expect(cpu[0], Uint32(0), reason: 'No write-back');

        // Swapped registers were ignored.
        expect(cpu[8], Uint32(666));
        expect(cpu[9], Uint32(666));
        expect(cpu[10], Uint32(666));

        // User-mode registers.
        expect(cpu.forceUserModeRead(8), Uint32(1));
        expect(cpu.forceUserModeRead(9), Uint32(2));
        expect(cpu.forceUserModeRead(10), Uint32(3));
      });
    });
  });
}
