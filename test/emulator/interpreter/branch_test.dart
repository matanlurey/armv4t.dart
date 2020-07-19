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

  setUp(() {
    cpu = Arm7Processor();
    interpreter = ArmInterpreter(cpu, Memory.none());
  });

  group('B', () {
    BArmInstruction instruction;

    test('PC += 8 + 16 * 4', () {
      instruction = BArmInstruction(
        condition: Condition.al,
        offset: Uint24(16),
      );
      expect(decode(instruction), 'b 16');

      interpreter.execute(instruction);

      expect(cpu.programCounter, Uint32(0 + 8 + 16 * 4));
    });
  });

  group('BL', () {
    BLArmInstruction instruction;

    test('PC += 8 + 16 * 4', () {
      instruction = BLArmInstruction(
        condition: Condition.al,
        offset: Uint24(16),
      );
      expect(decode(instruction), 'bl 16');

      cpu.programCounter = Uint32(16);
      interpreter.execute(instruction);

      expect(cpu.programCounter, Uint32(16 + 8 + 16 * 4));
      expect(cpu.linkRegister, Uint32(16 + 4));
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
      interpreter.execute(instruction);

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
      interpreter.execute(instruction);

      expect(cpu.linkRegister, Uint32.zero);
      expect(cpu.spsr, cpsr);
      expect(cpu.cpsr, cpsr.update(mode: ArmOperatingMode.svc));
      expect(cpu.programCounter, Uint32(0x08));
    });
  });
}
