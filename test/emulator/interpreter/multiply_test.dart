import 'package:armv4t/decode.dart';
import 'package:armv4t/src/common/binary.dart';
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
  final r1 = RegisterNotPC(Uint4(1));
  final r2 = RegisterNotPC(Uint4(2));
  final r3 = RegisterNotPC(Uint4(3));

  setUp(() {
    cpu = Arm7Processor();
    interpreter = ArmInterpreter(cpu);
  });

  group('MUL', () {
    MULArmInstruction instruction;

    test('r0 = r1 * r2', () {
      instruction = MULArmInstruction(
        condition: Condition.al,
        setConditionCodes: false,
        operand1: r1,
        operand2: r2,
        destination: r0,
      );
      expect(decode(instruction), 'mul r0, r1, r2');

      cpu[1] = Uint32(1000);
      cpu[2] = Uint32(32);
      interpreter.execute(instruction);

      expect(cpu[0], Uint32(1000 * 32));
    });
  });

  group('MLA', () {
    MLAArmInstruction instruction;

    test('r0 = r1 * r2 + r0', () {
      instruction = MLAArmInstruction(
        condition: Condition.al,
        setConditionCodes: false,
        operand1: r1,
        operand2: r2,
        operand3: r0,
        destination: r0,
      );
      expect(decode(instruction), 'mla r0, r1, r2');

      cpu[0] = Uint32(512);
      cpu[1] = Uint32(1000);
      cpu[2] = Uint32(32);
      interpreter.execute(instruction);

      expect(cpu[0], Uint32(1000 * 32 + 512));
    });
  });

  group('UMULL', () {
    UMULLArmInstruction instruction;

    test('r0|r1 = r2 * r3', () {
      instruction = UMULLArmInstruction(
        condition: Condition.al,
        setConditionCodes: false,
        operand1: r2,
        operand2: r3,
        destinationHiBits: r0,
        destinationLoBits: r1,
      );
      expect(decode(instruction), 'umull r1, r0, r2, r3');

      cpu[2] = Uint32(4294967295);
      cpu[3] = Uint32(2);
      interpreter.execute(instruction);

      expect(cpu[0], Uint32(1));
      expect(cpu[1], Uint32(4294967294));
    });
  });

  group('UMLAL', () {
    UMLALArmInstruction instruction;

    test('RdHiLo = Rm * Rs + RdHiLo', () {
      instruction = UMLALArmInstruction(
        condition: Condition.al,
        setConditionCodes: false,
        operand1: r2,
        operand2: r3,
        destinationHiBits: r0,
        destinationLoBits: r1,
      );
      expect(decode(instruction), 'umlal r1, r0, r2, r3');

      cpu[0] = Uint32(1);
      cpu[1] = Uint32(2);
      cpu[2] = Uint32(4294967295);
      cpu[3] = Uint32(2);
      interpreter.execute(instruction);

      expect(cpu[0], Uint32(3));
      expect(cpu[1], Uint32(0));
    });
  });

  group('SMULL', () {
    SMULLArmInstruction instruction;

    test('RdHiLo = Rm * Rs', () {
      instruction = SMULLArmInstruction(
        condition: Condition.al,
        setConditionCodes: false,
        operand1: r2,
        operand2: r3,
        destinationHiBits: r0,
        destinationLoBits: r1,
      );
      expect(decode(instruction), 'smull r1, r0, r2, r3');

      cpu[2] = Int32(-2147483648).toUnsigned();
      cpu[3] = Int32(2).toUnsigned();
      interpreter.execute(instruction);

      expect(cpu[0], Int32(-1).toUnsigned());
      expect(cpu[1], Int32(0).toUnsigned());
    });
  });

  group('SMLAL', () {
    SMLALArmInstruction instruction;

    test('RdHiLo = Rm * Rs + RdHiLo', () {
      instruction = SMLALArmInstruction(
        condition: Condition.al,
        setConditionCodes: false,
        operand1: r2,
        operand2: r3,
        destinationHiBits: r0,
        destinationLoBits: r1,
      );
      expect(decode(instruction), 'smlal r1, r0, r2, r3');

      cpu[0] = Int32(-1).toUnsigned();
      cpu[1] = Int32(-1).toUnsigned();
      cpu[2] = Int32(-2147483648).toUnsigned();
      cpu[3] = Int32(2).toUnsigned();
      interpreter.execute(instruction);

      expect(cpu[0], Int32(-3).toUnsigned());
      expect(cpu[1], Int32(-1).toUnsigned());
    });
  });
}
