import 'dart:io';

import 'package:armv4t/armv4t.dart';
import 'package:armv4t/debug.dart';
import 'package:binary/binary.dart';

void main(List<String> args) {
  if (args.length != 1) {
    stderr.writeln('Expected <path.bin> as only argument');
    exit(1);
  }

  final path = File(args.first);
  if (!path.existsSync()) {
    stderr.writeln('Could not find file at "$path"');
    exit(1);
  }

  final program = path.readAsBytesSync();
  final processor = Arm7Processor();
  final debugger = ArmDebugger(processor);
  final emulator = ArmVM(
    cpu: processor,
    memory: Memory.from(program),
    debugHooks: debugger,
  );

  stdout.writeln('Read ${program.length} bytes into memory');
  stdout.writeln('You may assign starting register values (i.e. r0=10)');
  stdout.writeln('Press enter (without any input) to run the program');

  var input = stdin.readLineSync();

  while (input.isNotEmpty) {
    if (input.startsWith('r')) {
      final register = int.parse(input.substring(1, input.indexOf('=')));
      final assigned = int.parse(input.split('=').last);
      processor[register] = Uint32(assigned);
      try {} catch (e) {
        stderr.write('Unsupported: "$input".');
      }
    } else {
      stderr.writeln('Unrecognized input. Try rN=10, or leave blank.');
    }
    input = stdin.readLineSync();
  }

  void execute() {
    if (emulator.step()) {
      stdout.writeln(debugger.events.join('\n'));
      execute();
    }
  }

  execute();
  stdout.writeln('\n~~~ Execution complete ~~~\n');
}
