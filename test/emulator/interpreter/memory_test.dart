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

  final r0 = RegisterNotPC(Uint4(0));
  final defaultPSR = StatusRegister();

  setUp(() {
    cpu = Arm7Processor();
    interpreter = ArmInterpreter(cpu, Memory.none());
  });
}
