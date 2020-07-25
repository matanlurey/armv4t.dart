import 'package:armv4t/armv4t.dart';
import 'package:armv4t/decode.dart';
import 'package:binary/binary.dart';
import 'package:test/test.dart';

void main() {
  ArmInterpreter interpreter;

  test('should support writing r15 = 0', () {
    final cpu = Arm7Processor();
    interpreter = ArmInterpreter(cpu, Memory.none());

    interpreter.step(MOVArmInstruction(
      condition: Condition.al,
      setConditionCodes: false,
      operand1: Register.filledWith0s,
      destination: RegisterAny(Uint4(15)),
      operand2: Or3.right(ShiftedImmediate.assembleUint8(0)),
    ));

    expect(cpu.programCounter, Uint32.zero);
  });
}
