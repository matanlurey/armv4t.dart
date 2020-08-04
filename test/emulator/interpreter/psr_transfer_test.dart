import 'package:armv4t/decode.dart';
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

  final r0 = RegisterNotPC(Uint4(0));
  final defaultPSR = StatusRegister();

  setUp(() {
    cpu = Arm7Processor(registers: Arm7Processor.testUserState());
    interpreter = ArmInterpreter(cpu, Memory.none());
  });

  group('MRS', () {
    MRSArmInstruction instruction;

    test('r0 = CPSR', () {
      instruction = MRSArmInstruction(
        condition: Condition.al,
        useSPSR: false,
        destination: r0,
      );
      expect(decode(instruction), 'mrs r0, cpsr');

      interpreter.run(instruction);
      expect(cpu[0], cpu.cpsr.toBits());
    });

    test('r0 = SPSR', () {
      instruction = MRSArmInstruction(
        condition: Condition.al,
        useSPSR: true,
        destination: r0,
      );
      expect(decode(instruction), 'mrs r0, spsr');

      cpu.unsafeSetCpsr(cpu.cpsr.update(mode: ArmOperatingMode.svc));
      interpreter.run(instruction);
      expect(cpu[0], cpu.spsr.toBits());
    });
  });

  group('MSR', () {
    MSRArmInstruction instruction;

    test('CPSR = r0', () {
      instruction = MSRArmInstruction(
        condition: Condition.al,
        useSPSR: false,
        allowChangingFlags: true,
        allowChangingControls: true,
        sourceOrImmediate: Or2.right(
          ShiftedImmediate.assembleUint8(0xf),
        ),
      );
      expect(decode(instruction), 'msr cpsr, 15');

      interpreter.run(instruction);
      expect(cpu.cpsr, defaultPSR);
    });

    test('SPSR_flg = r0', () {
      instruction = MSRArmInstruction(
        condition: Condition.al,
        useSPSR: true,
        allowChangingFlags: true,
        allowChangingControls: false,
        sourceOrImmediate: Or2.right(
          ShiftedImmediate.assembleUint8(
            ('1111' '0000' '0000' '0000' '0000' '0000' '0000' '0000').bits,
          ),
        ),
      );
      expect(decode(instruction), 'msr spsr_flg, 4026531840');

      cpu.unsafeSetCpsr(cpu.cpsr.update(mode: ArmOperatingMode.svc));
      interpreter.run(instruction);
      expect(
        cpu.spsr,
        defaultPSR.update(
          mode: ArmOperatingMode.svc,
          isCarry: true,
          isOverflow: true,
          isZero: true,
          isSigned: true,
        ),
      );
    });
  });
}
