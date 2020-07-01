import 'dart:io';

import 'package:path/path.dart' as path;

/// Uses the bundled FASMARM compile (third_party/fasmarm) to build outputs.
void main() {
  var didError = false;
  _build.forEach((source, output) {
    stdout.writeln('$_tool: $source -> $output');
    final result = Process.runSync(_tool, [
      source,
      output,
    ]);
    if (result.stdout != null) {
      stdout.writeln(result.stdout);
    }
    if (result.stderr != null) {
      stderr.writeln(result.stderr);
      didError = true;
    }
  });
  if (didError) {
    exitCode = 1;
  }
}

final _fasmarm = path.join('third_party', 'fasmarm');

final _tool = (() {
  if (Platform.isWindows) {
    return path.join(_fasmarm, 'FASMARM.exe');
  } else if (Platform.isLinux) {
    return path.join(_fasmarm, 'fasmarm');
  } else {
    throw UnsupportedError(Platform.operatingSystem);
  }
})();

final _build = {
  path.join(
    'third_party',
    'fasmarm',
    'ARMDOC',
    'InstructionFormatsARM.asm',
  ): path.join(
    'test',
    '_data',
    'InstructionFormatsARM.bin',
  ),
};
