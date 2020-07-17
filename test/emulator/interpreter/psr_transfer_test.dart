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
        destination: r0,
      );
      expect(decode(instruction), 'mrs r0, cpsr');

      interpreter.execute(instruction);
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

      interpreter.execute(instruction);
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
          ShiftedImmediate.assembleUint8(
            ('1111' '1111' '1111' '1111' '1111' '1111' '1111' '1111').bits,
          ),
        ),
      );
      expect(decode(instruction), 'mrs r0, spsr');

      // User mode: Only flag bits are write-able.
      interpreter.execute(instruction);
      expect(
        cpu.cpsr,
        defaultPSR.update(
          isSigned: true,
          isZero: true,
          isCarry: true,
          isOverflow: true,
        ),
      );
    });

    test('SPSR = r0', () {});

    test('CPSR_flg = r0', () {});

    test('CPSR_cnd = r0', () {});
  });
}
