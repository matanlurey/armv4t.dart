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

  final r0 = RegisterAny(Uint4(0));
  final r1 = RegisterAny(Uint4(1));
  final r2 = RegisterAny(Uint4(2));
  final defaultPSR = StatusRegister();

  setUp(() {
    cpu = Arm7Processor();
    interpreter = ArmInterpreter(cpu, Memory.none());
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
      interpreter.run(instruction);

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
      interpreter.run(instruction);

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

      interpreter.run(instruction);

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
      interpreter.run(instruction);

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
      interpreter.run(instruction);

      expect(cpu[2], Uint32(0xffffffff));
      expect(cpu.cpsr, defaultPSR.update(isSigned: true, isOverflow: false));
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
      interpreter.run(instruction);

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
      interpreter.run(instruction);

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
      interpreter.run(instruction);

      expect(cpu[2], Uint32(1));
      expect(cpu.cpsr, defaultPSR);
    });
  });

  group('AND', () {
    ANDArmInstruction instruction;

    test('r1 = r0 & IMM', () {
      instruction = ANDArmInstruction(
        condition: Condition.al,
        setConditionCodes: false,
        operand1: r0,
        destination: r1,
        operand2: Or3.right(ShiftedImmediate.assembleUint8('101'.bits)),
      );

      cpu[0] = Uint32('011'.bits);
      interpreter.run(instruction);

      expect(cpu[1], Uint32(1));
      expect(cpu.cpsr, defaultPSR);
    });
  });

  group('EOR', () {
    EORArmInstruction instruction;

    test('r1 = r0 ^ IMM', () {
      instruction = EORArmInstruction(
        condition: Condition.al,
        setConditionCodes: false,
        operand1: r0,
        destination: r1,
        operand2: Or3.right(ShiftedImmediate.assembleUint8('101'.bits)),
      );

      cpu[0] = Uint32('011'.bits);
      interpreter.run(instruction);

      expect(cpu[1], Uint32('110'.bits));
      expect(cpu.cpsr, defaultPSR);
    });
  });

  group('ORR', () {
    ORRArmInstruction instruction;

    test('r1 = r0 | IMM', () {
      instruction = ORRArmInstruction(
        condition: Condition.al,
        setConditionCodes: false,
        operand1: r0,
        destination: r1,
        operand2: Or3.right(ShiftedImmediate.assembleUint8('101'.bits)),
      );

      cpu[0] = Uint32('011'.bits);
      interpreter.run(instruction);

      expect(cpu[1], Uint32('111'.bits));
      expect(cpu.cpsr, defaultPSR);
    });
  });

  group('BIC', () {
    BICArmInstruction instruction;

    test('r1 = r0 & ~IMM', () {
      instruction = BICArmInstruction(
        condition: Condition.al,
        setConditionCodes: false,
        operand1: r0,
        destination: r1,
        operand2: Or3.right(ShiftedImmediate.assembleUint8('101'.bits)),
      );

      cpu[0] = Uint32('011'.bits);
      interpreter.run(instruction);

      expect(cpu[1], Uint32('010'.bits));
      expect(cpu.cpsr, defaultPSR);
    });
  });

  group('MOV', () {
    MOVArmInstruction instruction;

    test('r1 = IMM', () {
      instruction = MOVArmInstruction(
        condition: Condition.al,
        setConditionCodes: false,
        operand1: Register.filledWith0s,
        destination: r1,
        operand2: Or3.right(ShiftedImmediate.assembleUint8(512)),
      );

      interpreter.run(instruction);

      expect(cpu[1], Uint32(512));
      expect(cpu.cpsr, defaultPSR);
    });
  });

  group('MVN', () {
    MVNArmInstruction instruction;

    test('r1 = ~IMM', () {
      instruction = MVNArmInstruction(
        condition: Condition.al,
        setConditionCodes: false,
        operand1: Register.filledWith0s,
        destination: r1,
        operand2: Or3.right(ShiftedImmediate.assembleUint8(32)),
      );

      interpreter.run(instruction);

      expect(cpu[1], Uint32((~32).toUnsigned(32)));
      expect(cpu.cpsr, defaultPSR);
    });
  });

  group('TST', () {
    TSTArmInstruction instruction;

    test('r1 & IMM', () {
      instruction = TSTArmInstruction(
        condition: Condition.al,
        operand1: r1,
        destination: Register.filledWith0s,
        operand2: Or3.right(ShiftedImmediate.assembleUint8(0)),
      );

      interpreter.run(instruction);

      expect(cpu.cpsr, defaultPSR.update(isZero: true));
    });
  });

  group('TEQ', () {
    TEQArmInstruction instruction;

    test('r1 ^ r2', () {
      instruction = TEQArmInstruction(
        condition: Condition.al,
        operand1: r1,
        destination: Register.filledWith0s,
        operand2: Or3.left(
          ShiftedRegister(r2, ShiftType.LSL, Immediate(Uint4.zero)),
        ),
      );

      cpu[1] = Uint32(1);
      cpu[2] = Uint32((-8).toUnsigned(32));
      interpreter.run(instruction);

      expect(cpu.cpsr, defaultPSR.update(isSigned: true));
    });
  });

  group('CMP', () {
    CMPArmInstruction instruction;

    test('r1 - r2 [6 - 24]', () {
      instruction = CMPArmInstruction(
        condition: Condition.al,
        operand1: r1,
        destination: Register.filledWith0s,
        operand2: Or3.left(
          ShiftedRegister(r2, ShiftType.LSL, Immediate(Uint4.zero)),
        ),
      );

      cpu[1] = Uint32(6);
      cpu[2] = Uint32(24);
      interpreter.run(instruction);

      expect(cpu.cpsr, defaultPSR.update(isSigned: true, isOverflow: false));
    });

    test('r1 - r2 [54 - 24]', () {
      instruction = CMPArmInstruction(
        condition: Condition.al,
        operand1: r1,
        destination: Register.filledWith0s,
        operand2: Or3.left(
          ShiftedRegister(r2, ShiftType.LSL, Immediate(Uint4.zero)),
        ),
      );

      cpu[1] = Uint32(54);
      cpu[2] = Uint32(24);
      interpreter.run(instruction);

      expect(cpu.cpsr, defaultPSR.update(isSigned: false, isOverflow: false));
    });
  });

  group('CMN', () {
    CMNArmInstruction instruction;

    test('r1 + r2', () {
      instruction = CMNArmInstruction(
        condition: Condition.al,
        operand1: r1,
        destination: Register.filledWith0s,
        operand2: Or3.left(
          ShiftedRegister(r2, ShiftType.LSL, Immediate(Uint4.zero)),
        ),
      );

      cpu[1] = Uint32(1);
      cpu[2] = Uint32(2);
      interpreter.run(instruction);

      expect(cpu.cpsr, defaultPSR);
    });
  });
}
