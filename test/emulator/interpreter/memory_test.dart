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
    memory = Memory(10);
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

        // Read memory address 5.
        cpu[1] = Uint32(5);
        memory.storeWord(Uint32(5), Uint16(10240));
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

        // Read memory address 5.
        cpu[1] = Uint32(5);
        memory.storeByte(Uint32(5), Uint8(255));
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
          offset: Or2.left(Immediate(Uint12(5))),
        );
        expect(decode(instruction), 'ldr r0, [r1, 5]');

        // Read memory address 3 + 5.
        cpu[1] = Uint32(3);
        memory.storeWord(Uint32(8), Uint16(10240));
        interpreter.execute(instruction);

        expect(cpu[0], Uint32(10240));
        expect(cpu[1], Uint32(3), reason: 'No write back');
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
          offset: Or2.left(Immediate(Uint12(5))),
        );
        expect(decode(instruction), 'ldr r0, [r1, 5]!');

        // Read memory address 3 + 5.
        cpu[1] = Uint32(3);
        memory.storeWord(Uint32(8), Uint16(10240));
        interpreter.execute(instruction);

        expect(cpu[0], Uint32(10240));
        expect(cpu[1], Uint32(8), reason: 'Explicit writeback');
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
          offset: Or2.left(Immediate(Uint12(2))),
        );
        expect(decode(instruction), 'ldr r0, [r1, -2]');

        // Read memory address 3 - 2.
        cpu[1] = Uint32(3);
        memory.storeWord(Uint32(1), Uint16(10240));
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
          offset: Or2.left(Immediate(Uint12(2))),
        );

        // Read memory address 3.
        cpu[1] = Uint32(3);
        memory.storeWord(Uint32(3), Uint16(10240));
        interpreter.execute(instruction);

        expect(cpu[0], Uint32(10240));
        expect(cpu[1], Uint32(5), reason: 'Implicit write back');
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
        expect(memory.loadWord(Uint32(4)), Uint16(10240));
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

        // Store r1 into memory location 4 + 3.
        cpu[0] = Uint32(4);
        cpu[1] = Uint32(10240);
        interpreter.execute(instruction);

        expect(cpu[0], Uint32(4));
        expect(cpu[1], Uint32(10240));
        expect(memory.loadWord(Uint32(7)), Uint16(10240));
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
          offset: Or2.left(Immediate(Uint12(3))),
        );
        expect(decode(instruction), 'str r1, [r0, -3]');

        // Store r1 into memory location 4 - 3.
        cpu[0] = Uint32(4);
        cpu[1] = Uint32(10240);
        interpreter.execute(instruction);

        expect(cpu[0], Uint32(4));
        expect(cpu[1], Uint32(10240));
        expect(memory.loadWord(Uint32(1)), Uint16(10240));
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
        expect(memory.loadWord(Uint32(4)), Uint16(10240));
      });
    });
  });
}
