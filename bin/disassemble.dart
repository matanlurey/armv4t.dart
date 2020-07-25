import 'dart:io';
import 'dart:typed_data';

import 'package:args/args.dart';
import 'package:armv4t/decode.dart';
import 'package:binary/binary.dart';

final _argParser = ArgParser(allowTrailingOptions: true);

/// Usage:
///
/// ```sh
/// $ pub run armv4t:disassemble <input>
/// ```
void main(List<String> args) {
  final parsed = _argParser.parse(args);

  if (parsed.rest.isEmpty) {
    stderr.writeln('Expected a trailing argument, <input>.');
    return exit(1);
  }

  if (parsed.rest.length > 1) {
    stderr.writeln('Expected 1 trailing argument, got ${parsed.rest}.');
    return exit(1);
  }

  final input = File(parsed.rest.first);

  if (!input.existsSync()) {
    stderr.writeln('No file found at "${input.path}".');
    return exit(1);
  }

  final bytes = input.readAsBytesSync();

  if (bytes.isEmpty) {
    stderr.writeln('Input was an empty binary file.');
    return exit(1);
  }

  if (bytes.length % 4 != 0) {
    stderr.writeln('Input does not seem to be word-address aligned.');
    return exit(1);
  }

  final words = Uint32List.view(bytes.buffer);

  for (var i = 0; i < words.length; i++) {
    final decoded = _disassemble(words[i]);
    stdout.writeln(
      '$decoded'.padRight(32, ' ') + '; 0x${(i * 4).toRadixString(16)}',
    );
  }
}

String _disassemble(int opCode) {
  final format = const ArmFormatDecoder().convert(Uint32(opCode));
  final decode = format.accept(const ArmInstructionDecoder());
  return decode.accept(const ArmInstructionPrinter());
}
