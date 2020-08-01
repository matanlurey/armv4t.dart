import 'package:armv4t/decode.dart';
import 'package:armv4t/src/common/binary.dart';
import 'package:armv4t/src/emulator/interpreter.dart';
import 'package:armv4t/src/emulator/memory.dart';
import 'package:armv4t/src/emulator/processor.dart';
import 'package:binary/binary.dart';
import 'package:test/test.dart';

void main() {
  final printer = const ArmInstructionPrinter();

  String decode(ArmInstruction i) => i.accept(printer);

  Arm7Processor cpu;
  ArmInterpreter interpreter;

  setUp(() {
    cpu = Arm7Processor(registers: Arm7Processor.testUserState());
    interpreter = ArmInterpreter(cpu, Memory.none());
  });

  group('B', () {
    BArmInstruction instruction;

    test('PC += 8 + 16 * 4', () {
      instruction = BArmInstruction(
        condition: Condition.al,
        offset: Int24(4),
      );
      expect(decode(instruction), 'b 4');

      interpreter.run(instruction);

      expect(cpu.programCounter, Uint32(24));
    });
  });

  group('BL', () {
    BLArmInstruction instruction;

    test('PC += 8 + 16 * 4', () {
      instruction = BLArmInstruction(
        condition: Condition.al,
        offset: Int24(4),
      );
      expect(decode(instruction), 'bl 4');

      cpu.programCounter = Uint32(16);
      interpreter.run(instruction);

      expect(cpu.programCounter, Uint32(40));
      expect(cpu.linkRegister, Uint32(20));
    });
  });

  group('BX', () {
    BXArmInstruction instruction;

    test('PC = r0', () {
      instruction = BXArmInstruction(
        condition: Condition.al,
        operand: RegisterNotPC(Uint4(0)),
      );
      expect(decode(instruction), 'bx r0');

      cpu[0] = Uint32('1001'.bits);
      interpreter.run(instruction);

      expect(cpu.cpsr.thumbState, isTrue);
      expect(cpu.programCounter, Uint32('1000'.bits));
    });
  });

  group('SWI', () {
    SWIArmInstruction instruction;

    test('', () {
      instruction = SWIArmInstruction(
        condition: Condition.al,
        comment: Comment(Uint24.zero),
      );
      expect(decode(instruction), 'swi 0');

      final cpsr = cpu.cpsr;
      interpreter.run(instruction);

      expect(cpu.linkRegister, Uint32.zero);
      expect(cpu.spsr, cpsr);
      expect(cpu.cpsr, cpsr.update(mode: ArmOperatingMode.svc));
      expect(cpu.programCounter, Uint32(0x08));
    });
  });
}
