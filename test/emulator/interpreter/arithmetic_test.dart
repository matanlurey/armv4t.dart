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

  final r0 = RegisterAny(Uint4(0));
  final r1 = RegisterAny(Uint4(1));
  final r2 = RegisterAny(Uint4(2));
  final defaultPSR = StatusRegister();

  setUp(() {
    cpu = Arm7Processor();
    interpreter = ArmInterpreter(cpu);
  });

  // ADD op1 + op2
  group('ADD', () {
    ADDArmInstruction instruction;

    test('r2 = r0 + r1', () {
      instruction = ADDArmInstruction(
        condition: Condition.al,
        setConditionCodes: false,
        operand1: r0,
        operand2: Or3.left(
          ShiftedRegister(r1, ShiftType.LSL, Immediate(Uint4(0))),
        ),
        destination: r2,
      );
      expect(decode(instruction), 'add r2, r0, r1');

      cpu[0] = Uint32(1);
      cpu[1] = Uint32(2);
      interpreter.execute(instruction);

      expect(cpu[2], Uint32(3));
      expect(cpu.cpsr, defaultPSR);
    });

    test('r2 = r0 + r1 [Z=1]', () {
      instruction = ADDArmInstruction(
        condition: Condition.al,
        setConditionCodes: true,
        operand1: r0,
        operand2: Or3.left(
          ShiftedRegister(r1, ShiftType.LSL, Immediate(Uint4(0))),
        ),
        destination: r2,
      );
      expect(decode(instruction), 'adds r2, r0, r1');

      cpu[0] = cpu[1] = Uint32.zero;
      interpreter.execute(instruction);

      expect(cpu[2], Uint32.zero);
      expect(cpu.cpsr, defaultPSR.update(isZero: true));
    });

    test('r2 = r0 + 1020', () {
      instruction = ADDArmInstruction(
        condition: Condition.al,
        setConditionCodes: false,
        operand1: r0,
        operand2: Or3.right(ShiftedImmediate.assembleUint8(1020)),
        destination: r2,
      );
      expect(decode(instruction), 'add r2, r0, 1020');

      interpreter.execute(instruction);

      expect(cpu[2], Uint32(1020));
      expect(cpu.cpsr, defaultPSR);
    });
  });

  // ADC op1 + op2 + carry
  group('ADC', () {
    ADCArmInstruction instruction;

    test('r0 = r1 + 2 + 1', () {
      instruction = ADCArmInstruction(
        condition: Condition.al,
        setConditionCodes: false,
        operand1: r0,
        operand2: Or3.right(ShiftedImmediate.assembleUint8(2)),
        destination: r1,
      );
      expect(decode(instruction), 'adc r1, r0, 2');

      cpu.cpsr = cpu.cpsr.update(isCarry: true);
      interpreter.execute(instruction);

      expect(cpu[1], Uint32(3));
      expect(cpu.cpsr, defaultPSR.update(isCarry: true));
    });
  });

  // SUB op1 - op2
  group('SUB', () {
    SUBArmInstruction instruction;

    test('r2 = r0 - r1 [N=1]', () {
      instruction = SUBArmInstruction(
        condition: Condition.al,
        setConditionCodes: true,
        operand1: r0,
        operand2: Or3.left(
          ShiftedRegister(r1, ShiftType.LSL, Immediate(Uint4(0))),
        ),
        destination: r2,
      );
      expect(decode(instruction), 'subs r2, r0, r1');

      cpu[0] = Uint32(1);
      cpu[1] = Uint32(2);
      interpreter.execute(instruction);

      expect(cpu[2], Uint32(0xffffffff));
      expect(cpu.cpsr, defaultPSR.update(isSigned: true, isOverflow: true));
    });
  });

  // SUB op1 - op2 + carry - 1
  group('SBC', () {
    SBCArmInstruction instruction;

    test('r2 = r0 - r1', () {
      instruction = SBCArmInstruction(
        condition: Condition.al,
        setConditionCodes: true,
        operand1: r0,
        operand2: Or3.left(
          ShiftedRegister(r1, ShiftType.LSL, Immediate(Uint4(0))),
        ),
        destination: r2,
      );
      expect(decode(instruction), 'sbcs r2, r0, r1');

      cpu.cpsr = cpu.cpsr.update(isCarry: true);
      cpu[0] = Uint32(2);
      cpu[1] = Uint32(1);
      interpreter.execute(instruction);

      expect(cpu[2], Uint32(1));
      expect(cpu.cpsr, defaultPSR);
    });
  });

  // RSB op2 - op1
  group('RSB', () {
    RSBArmInstruction instruction;

    test('r2 = r1 - r0', () {
      instruction = RSBArmInstruction(
        condition: Condition.al,
        setConditionCodes: false,
        operand1: r0,
        operand2: Or3.left(
          ShiftedRegister(r1, ShiftType.LSL, Immediate(Uint4(0))),
        ),
        destination: r2,
      );
      expect(decode(instruction), 'rsb r2, r0, r1');

      cpu[0] = Uint32(2);
      cpu[1] = Uint32(3);
      interpreter.execute(instruction);

      expect(cpu[2], Uint32(1));
      expect(cpu.cpsr, defaultPSR);
    });
  });

  // RSC op2 - op1 + carry - 1
  group('RSC', () {
    RSCArmInstruction instruction;

    test('r2 = r1 - r0', () {
      instruction = RSCArmInstruction(
        condition: Condition.al,
        setConditionCodes: true,
        operand1: r0,
        operand2: Or3.left(
          ShiftedRegister(r1, ShiftType.LSL, Immediate(Uint4(0))),
        ),
        destination: r2,
      );
      expect(decode(instruction), 'rscs r2, r0, r1');

      cpu.cpsr = cpu.cpsr.update(isCarry: true);
      cpu[0] = Uint32(2);
      cpu[1] = Uint32(3);
      interpreter.execute(instruction);

      expect(cpu[2], Uint32(1));
      expect(cpu.cpsr, defaultPSR);
    });
  });

  group('AND', () {
    ANDArmInstruction instruction;
  });

  group('EOR', () {
    EORArmInstruction instruction;
  });

  group('ORR', () {
    ORRArmInstruction instruction;
  });

  group('BIC', () {
    BICArmInstruction instruction;
  });

  group('MOV', () {
    MOVArmInstruction instruction;
  });

  group('MVN', () {
    MVNArmInstruction instruction;
  });

  group('TST', () {
    TSTArmInstruction instruction;
  });

  group('TEQ', () {
    TEQArmInstruction instruction;
  });

  group('CMP', () {
    CMPArmInstruction instruction;
  });

  group('CMN', () {
    CMNArmInstruction instruction;
  });
}
