import 'package:armv4t/decode.dart';
import 'package:armv4t/src/emulator/interpreter.dart';
import 'package:armv4t/src/processor.dart';
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
    cpu = Arm7Processor();
    interpreter = ArmInterpreter(cpu);
  });

  group('MRS', () {
    MRSArmInstruction instruction;

    test('r0 = CPSR', () {
      instruction = MRSArmInstruction(
        condition: Condition.al,
        useSPSR: false,
        destination: RegisterNotPC(Uint4(0)),
      );
      expect(decode(instruction), 'mrs r0, cpsr');

      interpreter.execute(instruction);
      expect(cpu[0], cpu.cpsr.toBits());
    });

    test('r0 = SPSR', () {
      instruction = MRSArmInstruction(
        condition: Condition.al,
        useSPSR: true,
        destination: RegisterNotPC(Uint4(0)),
      );
      expect(decode(instruction), 'mrs r0, spsr');

      cpu.unsafeSetCpsr(cpu.cpsr.update(mode: ArmOperatingMode.svc));

      interpreter.execute(instruction);
      expect(cpu[0], cpu.spsr.toBits());
    });
  });

  group('MSR', () {
    MSRArmInstruction instruction;
  });
}
